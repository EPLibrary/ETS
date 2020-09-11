<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json" />
<cfif isDefined('url.rid') AND len(url.rid)>
<!--- Choose the active database to use. --->
<cfquery name="activedb" dbtype="ODBC" datasource="ETSRead">
	SELECT TOP 1 * FROM dbo.ETS_activeDB WHERE active = 1
</cfquery>
<cfset dbprefix = activedb.prefix />

<cfquery name="RouteShape" dbtype="ODBC" datasource="ETSRead">
SELECT * FROM dbo.#dbprefix#_shapes
WHERE shape_id=(
SELECT TOP 1 s.shape_id AS ptQty FROM dbo.#dbprefix#_shapes s
JOIN dbo.#dbprefix#_trips t ON s.shape_id=t.shape_id
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