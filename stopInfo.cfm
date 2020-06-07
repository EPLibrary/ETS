<!--- Returns JSON stop information for a given stop --->
<cfsetting enablecfoutputonly="true" showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json">
 
 <cfif isDefined('url.stopid')>
	<!--- If the url.stopid is not an int, make a version that has only the numeric part --->
	<cfset stopidInt = REREplaceNoCase(url.stopid, "\D*(\d+)", "\1") /> 	
	<cfinclude template="#appsIncludes#/functions/queryToStruct.cfm" />
	<!--- Choose the active database to use. --->
	<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
		SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
	</cfquery>
	<cfset dbprefix = activedb.prefix />
	<!--- Determine the agency, if possible --->
	<cfset agencyPrefix="" />
	<cfset agencySuffix="" />
	<cfif isDefined('url.trip')>
		<cfquery name="agency" dbtype="ODBC" datasource="SecureSource">
			SELECT t.agency_id FROM vsd.ETS1_trips_all_agencies t
			JOIN vsd.ETS1_agency_all_agencies a ON a.agency_id=t.agency_id
			WHERE trip_id='#url.trip#'
		</cfquery>
		<cfif agency.agency_id EQ 2>
			<cfset agencyPrefix = "StA" />
			<cfset agencySuffix = "_StAlbert" />
		<cfelseif agency.agency_id EQ 3>
			<cfset agencyPrefix = "Str" />
			<cfset agencySuffix = "_Strathcona" />
		</cfif>
		<cfif isNumeric(url.stopid)><cfset url.stopid=agencyPrefix&url.stopid /></cfif>
	</cfif>
	<cfquery name="stopInfo" dbtype="ODBC" datasource="SecureSource">
		<cfif isNumeric(url.stopid)>
		SELECT stop_id, stop_name, stop_lat, stop_lon, abbr AS sc FROM vsd.#dbprefix#_stops s
		LEFT OUTER JOIN vsd.EZLRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
		WHERE stop_id='#url.stopid#'
		<cfelseif left(url.stopid, 3) EQ "Str">
		SELECT stop_id, stop_name, stop_lat, stop_lon, '' AS sc FROM vsd.#dbprefix#_stops_Strathcona s
		WHERE stop_id='#Mid(url.stopid, 4, 99)#'
		<cfelse>
		SELECT stop_id, stop_name, stop_lat, stop_lon, '' AS sc FROM vsd.#dbprefix#_stops_StAlbert s
		WHERE stop_id='#Mid(url.stopid, 4, 99)#'
		</cfif>
	</cfquery>
	<cfset stopInfoStruct = queryToStruct(stopInfo) />

	<!--- If there's a trip, we get the shape and convert it into JSON coordinates for Google Maps --->
	<cfif isDefined('url.trip')>
		<cfquery name="shape" dbtype="ODBC" datasource="SecureSource">
			SELECT * FROM vsd.#dbprefix#_trips#agencySuffix# t
			JOIN vsd.#dbprefix#_shapes#agencySuffix# s ON t.shape_id=s.shape_id
			WHERE trip_id='#url.trip#'
			ORDER BY shape_pt_sequence
		</cfquery>
		<!--- Create an array of structs from the points --->
		<cfset routeCoords = arrayNew(1) />
		<cfloop query="shape">
			<cfset coords = StructNew() />
			<cfset coords.lat = shape.shape_pt_lat />
			<cfset coords.lng = shape.shape_pt_lon />
			<cfset routeCoords[CurrentRow] = coords />
		</cfloop>

		<!--- If the number is small, then this must be an ID from my own LRT stations, so get the real station IDs--->
		<!--- Note: St. Albert also uses single digit numbers for stop ids, so this complicates things --->
		<cfif isDefined('url.dest') AND isNumeric(url.dest) AND url.dest LT 25>
			<cfquery name="realStopIDs" dbtype="ODBC" datasource="SecureSource">
				SELECT * FROM vsd.EZLRTStations WHERE StationID=#url.dest#
			</cfquery>
		</cfif>

		<!--- We can also get the subsequent stops on the trip --->
		<cfquery name="nextStops" dbtype="ODBC" datasource="SecureSource">
			SELECT s.stop_id, s.stop_name, s.stop_lat, s.stop_lon, ls.Abbr as sc FROM vsd.#dbprefix#_stop_times#agencySuffix# t
			JOIN vsd.#dbprefix#_stops#agencySuffix# s ON s.stop_id=t.stop_id
			<!--- Not sure if this works --->
			LEFT OUTER JOIN vsd.EZLRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
			WHERE trip_id='#url.trip#' AND drop_off_type=0
			AND stop_sequence > 
			<cfif isDefined('url.seq') AND isNumeric(url.seq)>
				#url.seq#
			<cfelse>
				(SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times#agencySuffix# WHERE trip_id='#url.trip#' AND stop_id='#stopidInt#' ORDER BY stop_sequence DESC)
			</cfif>
			<cfif isDefined('url.dest') AND isNumeric(url.dest)>
				<cfif isDefined('realStopIDs') AND realStopIDs.recordCount>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times#agencySuffix# WHERE trip_id='#url.trip#'
					<cfif isDefined('url.seq') AND isNumeric(url.seq)>AND stop_sequence > #url.seq#</cfif>
					AND (stop_id='#realStopIDs.stop_id1#' OR stop_id='#realStopIDs.stop_id2#') ORDER BY stop_sequence ASC),9999))
				<cfelse>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times#agencySuffix# WHERE trip_id='#url.trip#' AND stop_id='#url.dest#' ORDER BY stop_sequence DESC),9999))
				</cfif>
			</cfif>
			ORDER BY stop_sequence
		</cfquery>
		<cfset nextStopInfoStruct = queryToStruct(query=nextStops, forceArray=true) />
	</cfif>

<cfoutput>{"stop":#SerializeJSON(stopInfoStruct)#</cfoutput>
	<cfif isDefined('routeCoords')>
<!--- Note that this only works correctly if the Preserve Case on Serialization setting is on in CF Administrator (CF11+), otherwise it could be lcased --->
<cfoutput>,"trip":#SerializeJSON(routeCoords)#,"next":#SerializeJSON(nextStopInfoStruct)#</cfoutput>
	</cfif>
<cfoutput>}</cfoutput>
<cfelse>
<cfoutput>{error: true, msg: "No StopID defined."}</cfoutput>
</cfif>