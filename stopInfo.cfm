<!--- Returns JSON stop information for a given stop --->
<cfsetting enablecfoutputonly="true" />

<cfsetting showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json">
 
 <cfif isDefined('url.stopid') AND isNumeric(url.stopid)>
	<cfinclude template="/AppsRoot/Includes/functions/QueryToStruct.cfm" />
	<!--- Choose the active database to use. --->
	<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
		SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
	</cfquery>
	<cfset dbprefix = activedb.prefix />
	<cfquery name="stopInfo" dbtype="ODBC" datasource="SecureSource">
		SELECT stop_id, stop_name, stop_lat, stop_lon, abbr as sc FROM vsd.#dbprefix#_stops s
		LEFT OUTER JOIN vsd.EZLRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
		WHERE stop_id=#url.stopid#
	</cfquery>
	<cfset stopInfoStruct = QueryToStruct(stopInfo) />

	<!--- If there's a trip, we get the shape and convert it into JSON coordinates for Google Maps --->
	<cfif isDefined('url.trip') AND isNumeric(url.trip)>
		<cfquery name="shape" dbtype="ODBC" datasource="SecureSource">
			SELECT * FROM vsd.#dbprefix#_trips t
			JOIN vsd.#dbprefix#_shapes s ON t.shape_id=s.shape_id
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
		<cfif isDefined('url.dest') AND isNumeric(url.dest) AND url.dest LT 1000>
			<cfquery name="realStopIDs" dbtype="ODBC" datasource="SecureSource">
				SELECT * FROM vsd.EZLRTStations WHERE StationID=#url.dest#
			</cfquery>
		</cfif>

		<!--- We can also get the subsequent stops on the trip --->
		<cfquery name="nextStops" dbtype="ODBC" datasource="SecureSource">
			SELECT s.stop_id, s.stop_name, s.stop_lat, s.stop_lon, ls.Abbr as sc FROM vsd.#dbprefix#_stop_times t
			JOIN vsd.#dbprefix#_stops s ON s.stop_id=t.stop_id
			<!--- Not sure if this works --->
			LEFT OUTER JOIN vsd.EZLRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
			WHERE trip_id='#url.trip#' AND drop_off_type=0
			AND stop_sequence > 
			<cfif isDefined('url.seq') AND isNumeric(url.seq)>
				#url.seq#
			<cfelse>
				(SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times WHERE trip_id='#url.trip#' AND stop_id='#url.stopid#' ORDER BY stop_sequence DESC)
			</cfif>
			<cfif isDefined('url.dest') AND isNumeric(url.dest)>
				<cfif isDefined('realStopIDs') AND realStopIDs.recordCount>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times WHERE trip_id='#url.trip#'
					<cfif isDefined('url.seq') AND isNumeric(url.seq)>AND stop_sequence > #url.seq#</cfif>
					AND (stop_id=#realStopIDs.stop_id1# OR stop_id=#realStopIDs.stop_id2#) ORDER BY stop_sequence ASC),9999))
				<cfelse>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times WHERE trip_id='#url.trip#' AND stop_id=#url.dest# ORDER BY stop_sequence ASC),9999))
				</cfif>
			</cfif>
			ORDER BY stop_sequence
		</cfquery>
		<cfset nextStopInfoStruct = QueryToStruct(query=nextStops, forceArray=true) />
	</cfif>

<cfoutput>{"stop":#SerializeJSON(stopInfoStruct)#</cfoutput>
	<cfif isDefined('routeCoords')>
<cfoutput>,"trip":#lcase(SerializeJSON(routeCoords))#,"next":#SerializeJSON(nextStopInfoStruct)#</cfoutput>
	</cfif>
<cfoutput>}</cfoutput>
<cfelse>
<cfoutput>{error: true, msg: "No StopID defined."}</cfoutput>
</cfif>