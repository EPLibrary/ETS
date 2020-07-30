<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json" />
<cfif isDefined('url.rid') AND len(url.rid)>
<!--- Choose the active database to use. --->
<cfquery name="activedb" dbtype="ODBC" datasource="ETSRead">
	SELECT TOP 1 * FROM dbo.ETS_activeDB WHERE active = 1
</cfquery>
<cfset dbprefix = activedb.prefix />

<!--- Get the prefix for the particular agency this route is for --->
<cfquery name="RouteAgency" dbtype="ODBC" datasource="ETSRead">
	SELECT agency_id FROM dbo.#dbprefix#_routes_all_agencies WHERE route_id='#url.rid#'
</cfquery>
<cfset agencyid = RouteAgency.agency_id />
<cfset agencysuffix = "" />
<cfif agencyid EQ 2><cfset agencysuffix = "_StAlbert" /></cfif>
<cfif agencyid EQ 3><cfset agencySuffix = "_Strathcona" /></cfif>

<cfquery name="RouteShape" dbtype="ODBC" datasource="ETSRead">
SELECT * FROM dbo.#dbprefix#_shapes#agencysuffix#
WHERE shape_id=(
SELECT TOP 1 s.shape_id AS ptQty FROM dbo.#dbprefix#_shapes#agencysuffix# s
JOIN dbo.#dbprefix#_trips#agencysuffix# t ON s.shape_id=t.shape_id
  		WHERE t.route_id = '#url.rid#' GROUP BY s.shape_id ORDER BY count(*) DESC
) ORDER BY shape_pt_sequence
</cfquery>
<cfoutput>{"shape":[<cfloop query="RouteShape"><cfif currentRow GT 1>,</cfif>{"lng":#shape_pt_lon#,"lat":#shape_pt_lat#}</cfloop>]}</cfoutput>
<cfelse>
	<cfset data = structNew() />
	<cfset data.error = true />
	<cfset data.message = "no rid specified." />
	<cfoutput>#serializeJSON(data)#</cfoutput>
</cfif>