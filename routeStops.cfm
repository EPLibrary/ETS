<cfsetting enablecfoutputonly="true">
<cfsetting showdebugoutput="false">
<cfheader name="Content-Type" value="application/json">

<!--- Choose the active database to use. --->
<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
	SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
</cfquery>

<cfset dbprefix = activedb.prefix />

<!--- If we're passed a route_id (url.rid), we return all the relevant stop info here as JSON to populate select lists. Runs very quickly --->

<cfif isDefined("url.rid") AND isNumeric(url.rid)>
<!--- Which agency is this route for? --->
<cfquery name="RouteAgency" dbtype="ODBC" datasource="SecureSource">
	SELECT agency_id FROM vsd.#dbprefix#_routes_all_agencies WHERE route_id='#url.rid#'
</cfquery>
<cfset agencyid = RouteAgency.agency_id />
<cfset agencysuffix = "" />
<cfif agencyid EQ 2><cfset agencysuffix = "_StAlbert" /></cfif>
<cfif agencyid EQ 3><cfset agencySuffix = "_Strathcona" /></cfif>

<!--- This query returns all unique stops on a route, ordered by their sequence. Unfortunately I can't guarantee that I'm returning all stops
<cfquery name="routeStops" dbtype="ODBC" datasource="SecureSource">
	SELECT stime.stop_id, stop_name, stop_lat, stop_lon, min(stop_sequence) AS min_stop_sequence FROM vsd.#dbprefix#_stop_times stime
	JOIN vsd.#dbprefix#_stops s ON s.stop_id=stime.stop_id
	WHERE trip_id = (
		SELECT trip_id FROM (
		SELECT TOP 1 MAX(stop_sequence) AS max_stops, trip_id AS trip_id
		FROM vsd.#dbprefix#_stop_times stimes WHERE trip_id IN (
				SELECT trip_id FROM vsd.#dbprefix#_trips WHERE route_id=#url.rid#)
		GROUP BY trip_id
		) AS max_trip
	)
	GROUP BY stime.stop_id, stop_name, stop_lat, stop_lon
	ORDER BY min_stop_sequence
</cfquery> --->

<!--- If I have a url.routeFrom id, I will only return the stops that are a destination for a trip AFTER the specified route
Hopefully this will make it much easier to select the appropriate stop
--->
<cfif isDefined('url.routeFrom') AND isNumeric(url.routeFrom)>

<cfquery name="routeStops" dbtype="ODBC" datasource="SecureSource">
	SELECT DISTINCT astop_id, sdt.stop_id, stop_name, stop_lat, stop_lon FROM vsd.#dbprefix#_trip_stop_datetimes#agencysuffix# sdt
	JOIN vsd.#dbprefix#_stops_all_agencies_unique s ON s.stop_id=sdt.stop_id
	WHERE route_id='#url.rid#'
	-- Does the current route have any instances
	-- where it is in the same trip as the routeFrom
	-- and has a stop_sequence that is higher?
	AND stop_sequence > (SELECT TOP 1 stop_sequence FROM vsd.#dbprefix#_stop_times_all_agencies WHERE trip_id = sdt.trip_id AND stop_id=#url.routeFrom#)
	-- ORDER BY stop_sequence
</cfquery>
<cfelse>

<cfquery name="routeStops" dbtype="ODBC" datasource="SecureSource">
	SELECT DISTINCT astop_id, sdt.stop_id, stop_name, stop_lat, stop_lon FROM vsd.#dbprefix#_trip_stop_datetimes#agencysuffix# sdt
	JOIN vsd.#dbprefix#_stops_all_agencies_unique s ON s.stop_id=sdt.stop_id
	WHERE route_id='#url.rid#'
	-- ORDER BY stop_sequence
</cfquery>

</cfif>
<!--- Create a simple data structure that I can use with selectize to populate dropdowns --->
<cfset stopOptions = ArrayNew(1) />
<cfloop query="routeStops">
	<cfset stop = structNew() />
	<cfset stop["value"]=astop_id />
	<cfset stop["id"]=astop_id />
	<cfset stop["text"]="#astop_id# #stop_name#" />
	<cfset stop["lat"]="#stop_lat#" />
	<cfset stop["lon"]="#stop_lon#" />
	<cfset ArrayAppend(stopOptions, stop) />
</cfloop>

<cfoutput>#SerializeJSON(stopOptions)#</cfoutput>
<cfelse>
<cfoutput>{}</cfoutput>
</cfif>