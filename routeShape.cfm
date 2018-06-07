<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />
<cfheader name="Content-Type" value="application/json" />
<cfif isDefined('url.rid') AND isNumeric(url.rid)>
<!--- Choose the active database to use. --->
<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
	SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
</cfquery>
<cfset dbprefix = activedb.prefix />	
<cfquery name="RouteShape" dbtype="ODBC" datasource="SecureSource">
  SELECT * FROM vsd.#dbprefix#_shapes
  WHERE shape_id=(SELECT TOP 1 shape_id AS ptQty FROM vsd.#dbprefix#_shapes 
  		WHERE shape_id like '#url.rid#-%' GROUP BY shape_id ORDER BY count(*) DESC
  )
</cfquery>
<cfoutput>{"shape":[<cfloop query="RouteShape"><cfif currentRow GT 1>,</cfif>{"lng":#shape_pt_lon#,"lat":#shape_pt_lat#}</cfloop>]}</cfoutput>
</cfif>