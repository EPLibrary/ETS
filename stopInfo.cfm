<!--- Returns JSON stop information for a given stop --->
<cfsetting enablecfoutputonly="true" showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json">
 
 <cfif isDefined('url.stopid')>
	<!--- If the url.stopid is not an int, make a version that has only the numeric part --->
	<cfset stopidInt = REREplaceNoCase(url.stopid, "\D*(\d+)", "\1") /> 	
	<cfinclude template="#app.includes#/functions/queryToStruct.cfm" />
	<!--- Choose the active database to use. --->
	<cfquery name="activedb" dbtype="ODBC" datasource="ETSRead">
		SELECT TOP 1 * FROM dbo.ETS_activeDB WHERE active = 1
	</cfquery>
	<cfset dbprefix = activedb.prefix />
	<!--- Determine the agency, if possible. This isn't really used now, could be used in the future to show a logo for the stoptime or something. --->
	<!---
	<cfif isDefined('url.trip')>
		<cfquery name="agency" dbtype="ODBC" datasource="ETSRead">
			SELECT r.agency_id FROM dbo.ETS1_trips t
			JOIN dbo.ETS1_routes r ON r.route_id=t.route_id
			WHERE trip_id='#url.trip#'
		</cfquery>
	</cfif>
	--->

	<cfquery name="stopInfo" dbtype="ODBC" datasource="ETSRead">
		SELECT stop_id, stop_name, stop_lat, stop_lon, abbr AS sc FROM dbo.#dbprefix#_stops s
		LEFT OUTER JOIN dbo.ETS_LRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
		WHERE stop_id='#url.stopid#'
	</cfquery>
	<cfset stopInfoStruct = queryToStruct(stopInfo) />

	<!--- If there's a trip, we get the shape and convert it into JSON coordinates for Google Maps --->
	<cfif isDefined('url.trip')>
		<cfquery name="shape" dbtype="ODBC" datasource="ETSRead">
			SELECT * FROM dbo.#dbprefix#_trips t
			JOIN dbo.#dbprefix#_shapes s ON t.shape_id=s.shape_id
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
			<cfquery name="realStopIDs" dbtype="ODBC" datasource="ETSRead">
				SELECT * FROM dbo.ETS_LRTStations WHERE StationID=#url.dest#
			</cfquery>
		</cfif>

		<!--- We can also get the subsequent stops on the trip --->
		<cfquery name="nextStops" dbtype="ODBC" datasource="ETSRead">
			SELECT s.stop_id, s.stop_name, s.stop_lat, s.stop_lon, ls.Abbr as sc FROM dbo.#dbprefix#_stop_times t
			JOIN dbo.#dbprefix#_stops s ON s.stop_id=t.stop_id
			<!--- Not sure if this works --->
			LEFT OUTER JOIN dbo.ETS_LRTStations ls ON ls.stop_id1=s.stop_id OR ls.stop_id2=s.stop_id
			WHERE trip_id='#url.trip#' AND drop_off_type=0
			AND stop_sequence > 
			<cfif isDefined('url.seq') AND isNumeric(url.seq)>
				#url.seq#
			<cfelse>
				(SELECT TOP 1 stop_sequence FROM dbo.#dbprefix#_stop_times WHERE trip_id='#url.trip#' AND stop_id='#stopidInt#' ORDER BY stop_sequence DESC)
			</cfif>
			<cfif isDefined('url.dest') AND isNumeric(url.dest)>
				<cfif isDefined('realStopIDs') AND realStopIDs.recordCount>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM dbo.#dbprefix#_stop_times WHERE trip_id='#url.trip#'
					<cfif isDefined('url.seq') AND isNumeric(url.seq)>AND stop_sequence > #url.seq#</cfif>
					AND (stop_id='#realStopIDs.stop_id1#' OR stop_id='#realStopIDs.stop_id2#') ORDER BY stop_sequence ASC),9999))
				<cfelse>
				AND stop_sequence <= (ISNULL((SELECT TOP 1 stop_sequence FROM dbo.#dbprefix#_stop_times WHERE trip_id='#url.trip#' AND stop_id='#url.dest#' ORDER BY stop_sequence DESC),9999))
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