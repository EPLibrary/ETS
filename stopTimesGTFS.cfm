
<!--- Simple function that accepts a weekday (2 or more letters) and returns the coldfusion weekday integer --->
<cffunction name="weekdayToNum" returntype="numeric">
	<cfargument name="DayName" required="true" type="String">
	<!--- If passed an int, just return it --->
	<cfif isNumeric(DayName)><cfreturn DayName></cfif>
	<cfswitch expression="#Left(DayName, 2)#">
		<cfcase value="Su">  <cfreturn 1></cfcase>
		<cfcase value="Mo,M"><cfreturn 2></cfcase>
		<cfcase value="Tu">  <cfreturn 3></cfcase>
		<cfcase value="We,W"><cfreturn 4></cfcase>
		<cfcase value="Th">  <cfreturn 5></cfcase>
		<cfcase value="Fr,F"><cfreturn 6></cfcase>
		<cfcase value="Sa">  <cfreturn 7></cfcase>
	</cfswitch>
</cffunction>
<!--- Loaded via ajax or include to show departureTimes table --->
<cfsetting showdebugoutput="false" />
<cfsetting requesttimeout="12" />
<!--- set to 12s as safeguard against runaway recursive function. This page gets really slow, though :(  --->


<cffunction name="getDepartures" returntype="void"
description="Accepts FROM stop_id and a datetime and outputs a table with relevant stops at that bus stop">
	<cfargument name="fromStop" required="true" type="string" />
	<cfargument name="CurrentTime" required="true" type="date" />


	<!--- Set the says of the week --->
	<cfset DOW = CurDOW = DayOfWeek(CurrentTime) />
	<cfset NextDOW = (CurDOW+1) />
	<cfif NextDow GT 7><cfset NextDow -= 7 /></cfif>
	<cfset NextDOW = Left(DayOfWeekAsString(NextDOW),3)>
	<cfset PrevDOW = CurDOW-1 />
	<cfif PrevDOW LTE 0><cfset PrevDOW = PrevDOW+7></cfif>
	<cfset PrevDOW = Left(DayOfWeekAsString(PrevDOW),3)>
	<cfset CurDOW = Left(DayOfWeekAsString(CurDow),3)>


	<cfset maxDepartureMins = 90 />
	<!--- Show two hours if we are looking late at night --->
	<cfif Hour(CurrentTime) GTE 23 OR Hour(CurrentTime) IS 0>
		<cfset maxDepartureMins = 120 />
	</cfif>

	<!--- Set the end of the range we are interested in --->
	<cfset MaxFutureTime = DateAdd('n', maxDepartureMins, CurrentTime)>


	<!--- Below, I am unioning the stops if this is a numeric stop. Now... I only really need to do this
	IF that stopid appears for another city IN SELECT * FROM vsd.ETSX_stops_all_agencies WHERE exclusive=0
	I should check for this first --->
	<cfset useSTA = false />
	<cfset useSTR = false />
	<cfif isNumeric(fromStop)>
		<cfquery name="checkForeignAgencies" dbtype="ODBC" datasource="SecureSource">
			SELECT * FROM vsd.ETS1_stops_all_agencies WHERE stop_id='#fromStop#' AND exclusive=0
		</cfquery>
		<cfloop query="checkForeignAgencies">
			<cfif zone_id IS "St. Albert Transit"><cfset useSTA = true /></cfif>
			<cfif zone_id IS "Strathcona County Transit"><cfset useSTR = true /></cfif>
		</cfloop>
	</cfif>

	<!--- Query that should show the relevant schedule times. --->
	<cfquery name="DepartureTimes" dbtype="ODBC" datasource="SecureSource">
		<!--- if fromStop is numeric, it's an ETS stop --->
		<cfif isNumeric(fromStop)>
			SELECT * FROM (SELECT * FROM vsd.#dbprefix#_trip_stop_datetimes
			<cfif useSTA IS true>
			UNION
			SELECT * FROM vsd.#dbprefix#_trip_stop_datetimes_StAlbert
			</cfif>
			<cfif useSTR IS true>
			UNION
			SELECT * FROM vsd.#dbprefix#_trip_stop_datetimes_Strathcona
			</cfif>
			) AS AllDatetimes
			WHERE stop_id=#fromStop# 
			AND ActualDateTime > #CurrentTime#
			AND ActualDateTime < #maxFutureTime#
			AND pickup_type = 0
			ORDER BY ActualDateTime
		<cfelseif left(fromStop, 3) EQ "Str">
			SELECT * FROM vsd.#dbprefix#_trip_stop_datetimes_Strathcona
			WHERE stop_id=#Mid(fromStop, 4, 99)# 
			AND ActualDateTime > #CurrentTime#
			AND ActualDateTime < #maxFutureTime#
			AND pickup_type = 0
			ORDER BY ActualDateTime
		<cfelse><!--- otherwise it's St. Albert --->
			SELECT * FROM vsd.#dbprefix#_trip_stop_datetimes_StAlbert
			WHERE stop_id=#Mid(fromStop, 4, 99)# 
			AND ActualDateTime > #CurrentTime#
			AND ActualDateTime < #maxFutureTime#
			AND pickup_type = 0
			ORDER BY ActualDateTime
		</cfif>
	</cfquery>
<!--- <cfdump var="#departureTimes#"> --->
	<!--- This assumes a valid stop is given. I should handle this --->
	<cfquery name="StopInfo" dbtype="ODBC" datasource="SecureSource">
		<cfif isNumeric(fromStop)>
		SELECT * FROM vsd.#dbprefix#_stops WHERE stop_id=#fromStop#
		<cfelseif left(fromStop, 3) EQ "Str">
		SELECT * FROM vsd.#dbprefix#_stops_Strathcona WHERE stop_id=#mid(fromStop, 4, 99)#
		<cfelse>
		SELECT * FROM vsd.#dbprefix#_stops_StAlbert WHERE stop_id=#mid(fromStop, 4, 99)#
		</cfif>
	</cfquery>
	
	<cfoutput>
	<table class="altColors" data-stopid="#fromStop#">
	<thead>
		<tr>
			<th colspan="4">Departures from ###fromStop#<br />#StopInfo.stop_name#</th>
		</tr>
	</thead>
	<tbody>
	<cfif DepartureTimes.RecordCount EQ 0>
		<tr>
				<td colspan="3" class="tN" style="text-align: center;">There no stops here during this time.</td>
		</tr>
	<cfelse>
		<cfloop query="DepartureTimes">
			<!--- Only show if the time hasn't elapsed --->
			<tr data-tripid="#trip_id#" data-sequence="#stop_sequence#">
				<td class="tN"><cfif trip_headsign NEQ 1 AND trip_headsign NEQ Left(stop_headsign, len(trip_headsign))>#route_id# </cfif><cfif len(stop_headsign)>#stop_headsign#<cfelseif len(trip_headsign) AND trip_headsign NEQ 1>#trip_headsign#<cfelse>#route_short_name# #route_long_name#</cfif></td>
				<td class="aT" data-scheduled="#ActualDateTime#" data-datetime="#ActualDateTime#">#TimeFormat(ActualDateTime, "h:mm tt")#</td>
				<td class="cD"></td>
			</tr>
			<tr class="dR">
				<!--- This does little when I'm just showing stop times --->
				<td class="dA" colspan="3"><a class="mapLink" data-tripid="#trip_id#" data-sequence="#stop_sequence#" href="javascript:void(0);"><div class="icon">&##x1f5fa;</div><div class="mapBtnLabel">Map</div></a><div class="lateness"></div></td>
			</tr>
		</cfloop>
	</cfif>
	</tbody>
	</table>
	</cfoutput>


</cffunction><!---getDepartures--->


<cfif isDefined('url.fromStop') AND len(url.fromStop)>

		<!--- Choose the active database to use. --->
		<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
			SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
		</cfquery>

		<cfset dbprefix = activedb.prefix />

		<!--- TEMPORARILY SET THIS MANUALLY FOR TESTING. REMOVE THIS LINE FOR PRODUCTION!!! --->
		<!--- <cfset dbprefix = 'ETS2' /> --->

		<!--- Setting date variables for DepartureTimes query --->
		<!--- Set the Day of Week. Sunday is 1, Saturday is 7 --->
		<cfif isDefined('url.dow') AND len(url.dow) GTE 3>
			<cfset DOW = Left(url.dow, 3)>
		<cfelse>
	 		<cfset DOW = Left(DayOfWeekAsString(DayOfWeek(now())),3)>
		</cfif>

		<!--- If it's Monday, and we've specified Sunday, we'll get -1. Add 7 to get 6 days ahead --->
		<cfset dayDiff = weekdayToNum(DOW) - DayOfWeek(now())>
		<cfif dayDiff LT 0><cfset dayDiff+=7></cfif> 

		<!--- Our start datetime for purposes of the query will then be --->
		<cfset CurrentTime = DateAdd('d', dayDiff, now()) >

		<!--- If the user has specified a time, we set it here --->
		<cfif isDefined('url.time') and len(url.time) GTE 3>
			<!--- Create a new currentTime with the speified time url --->
			<cfset CurrentTime=CreateDateTime(Year(CurrentTime), Month(CurrentTime), Day(CurrentTime), Hour(url.time), Minute(url.time), 0)>
		</cfif>
		<!--- Subtract three minutes to account for trains being a little late --->
		<cfset CurrentTime = DateAdd("n", -3, CurrentTime)>



		<!--- Here's where the magic happens. Can call this in a loop if there are multiple stop times --->
		<cfoutput>
		<cfset counter=0 />
		<cfloop list="#url.fromStop#" index="stop">
			<cfif counter++ GT 0><div style="margin:30px;"></div></cfif>
			#getDepartures(stop, currentTime)#
		</cfloop>
		</cfoutput>


</cfif><!---isDefined('url.fromStop')--->