<!--- <cfsetting enablecfoutputonly="true" /> --->
<cfsetting requesttimeout="60" />
<cfsetting showdebugoutput="false" />

<html>
<body>


<!--- TripUpdate.cfm allows a page to request a trip update for a list of tripIDs and a stop.
This is queried from ETSRealTime.exe, which is a Windows command line app made with .NET in C# --->
<cfobject name="gtfsRealtime" component="gtfsRealtime">
<!--- <cfdump var="#server.gtfsrealtime#"> --->

<!--- <cfif isDefined('form.tid') AND isDefined('form.stopID')> --->

	<!--- Get the filename for the TripUpdates.PB --->
	<cfset gtfsRTResp=gtfsRealtime.getPB() />



<cfif isDefined('gtfsRTResp') AND len(gtfsRTResp)>
	<cfset args = "-f #gtfsRTResp#" />

	<cfexecute name="D:\inetpub\CustomTags\lib\ETSRealTime\ETSRealTime.exe"
		arguments = "#args#"
		variable="json"
		errorvariable="error"
		timeout="15" />

	<!--- <cfdump var="#error#"> --->

	<cfset RealTimeData = DeserializeJSON(json) />

<!--- Structure of RealTimeData
message
	entity[1-700]
		id
		trip_update
			route_id
			schedule_relationship
			start_date
			start_time
			trip_id
			stop_time_update[1-30]
				departure
					delay
					departure.uncertainty
					time
				schedule_relationship
				stop_id
				stop_sequence				
--->

	<!--- INSERT everything into one bigass query --->
	<cfquery name="InsertTRIPS" dbtype="ODBC" datasource="ReadWriteSource">
		DELETE FROM ETSRT1_stop_time_update;
		DELETE FROM ETSRT1_trip_update;
		<cfloop array="#RealTimeData.message.entity#" item="e" index="i">
		<cfif i MOD 700 EQ 1>INSERT INTO vsd.ETSRT1_trip_update (id, route_id, schedule_relationship, start_datetime) VALUES</cfif>
		<cfif i MOD 700 NEQ 1>,</cfif>('#e.id#', '#e.trip_update.route_id#', '#e.trip_update.schedule_relationship#', '#e.trip_update.start_date# #e.trip_update.start_time#')
		</cfloop>

		<cfloop array="#RealTimeData.message.entity#" item="e" index="oi">
			<cfloop array="#e.trip_update.stop_time_update#" item="stu" index="i">
				<cfif i EQ 1>
					INSERT INTO vsd.ETSRT1_stop_time_update (trip_id, delay, departure_uncertainty, time, schedule_relationship, stop_id, stop_sequence) VALUES
				</cfif>
				<cfif i NEQ 1>,</cfif>('#e.trip_update.trip_id#',
					<cfif isDefined('stu.departure')>
						#stu.departure.delay#, #stu.departure["departure.uncertainty"]#, #stu.departure.time#
					<cfelse>
						NULL, NULL, NULL
					</cfif>,
					'#stu.schedule_relationship#', '#stu.stop_id#', #stu.stop_sequence#)
			</cfloop>
		</cfloop>

	</cfquery>

	<!--- <cfdump var="#RealTimeData#"> --->

	<!--- <cfoutput>#json#</cfoutput> --->

<cfset intRunTimeInSeconds = DateDiff(
    "s",
    GetPageContext().GetFusionContext().GetStartTime(),
    Now()
    ) />
<p>Realtime data has been updated in <cfoutput>#intRunTimeInSeconds# seconds</cfoutput>.</p>
</body>
</html>
<cfelse><cfoutput>
<p>ERROR: There was a problem getting gtfsRealtime data.</p>
}</cfoutput>
</cfif>
