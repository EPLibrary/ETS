<!--- 
Accepts lat/lon parameters (also long) and an optional dest (which defaults to 11)
And redirects to www2.epl.ca/ets/
https://apps.epl.ca/dev/ets/?from=2&to=1

Note that a three-decimal place precision is sufficient here if one is concerned about privacy of specific coordinates
 --->

<cfquery name="stations" dbtype="ODBC" datasource="SecureSource">
	SELECT * FROM vsd.EZLRTStations
</cfquery>


<!DOCTYPE html>



<cfif isDefined('url.long') AND NOT isDefined('url.lon')><cfset url.lon = url.long /></cfif>

<!--- Allow a single "Coords" parameter to get converted to lat/lon --->
<cfif isDefined('url.coords') and ListLen(url.coords) EQ 2>
	<cfset url.lat = Trim(ListGetAt(url.coords, 1)) />
	<cfset url.lon = Trim(ListGetAt(url.coords, 2)) />
</cfif>

<cfparam name="dest" default="" />
<cfif isDefined('url.dest') AND isNumeric(url.dest)>
	<cfset dest = url.dest />
</cfif>

<cfset error = false />
<cfset errMsg = "" />

<cfif NOT isDefined('url.lat') OR NOT isNumeric(url.lat)>
	<cfset errMsg &= 'No valid <b>lat</b> specified.<br />' />
	<cfset error = true />
</cfif>
<cfif NOT isDefined('url.lon') OR NOT isNumeric(url.lon)>
	<cfset errMsg &= 'No valid <b>lon</b> specified.<br />' />
	<cfset error = true />
</cfif>
<cfif len(dest) EQ 0>
	<cfset errMsg &= '<b>dest</b> not specified (optional).<br />' />
</cfif>

<cfif error >
<html>
	<head>
		<title>Nearest Edmonton LRT Station</title>
		<style>
			body {
				font-family: sans-serif;
			}
			.error {
				padding:10px;
				color:darkred;
				background-color:rgba(255, 0, 0, .2);
				border-radius:8px;
				border-color:red;
				margin-bottom:10px;
			}

			table {
				/*border: 1px solid #aaa;*/
				border-collapse: collapse;
			}

			table td, table th {
				padding:4px;
				border:1px solid rgba(0, 0, 0, .10);
			}

			table th {
				border-color:black;
			}

			table thead tr {
				background-color:#444;
			}

			table thead tr th {
				color:white;
			}

			table tbody tr:nth-child(even):not(.heading) {
				background-color: #dddddd;
				background-color: rgba(0, 0, 0, .05);
			}

			table tbody tr:nth-child(odd):not(.heading) {
				/* could put another color here */
			}

			h1, h2, h3, h4 {
				margin-bottom:5px;
			}

			@media (prefers-color-scheme: dark) {
				body {
					background-color: black;
					color: white;
				}

				.error {
					color:red;
				}

				table tbody tr:nth-child(even):not(.heading) {
					background-color: #dddddd;
					background-color: rgba(255, 255, 255, .08);
				}

				a {
					color: #25caff;
				}



			}

		</style>
	</head>
	<body>

	<h1>Nearest LRT Station</h1>

	<p>This page is used to automatically showing the Edmonton LRT Schedule for the station nearest to a specified location. It is useful for automated scripts like Siri Shortcuts in iOS 12+.</p>

	<cfif len(errMsg)>
		<h4>The following error has occurred:</h4>
		<div class="error"><cfoutput>#errMsg#</cfoutput></div>
		<b>Valid example:</b> <a href="https://www2.epl.ca/ETS/nearestLRT.cfm?lat=53.5443&lon=-113.4892&dest=3">https://www2.epl.ca/ETS/nearestLRT.cfm?lat=53.5443&lon=-113.4892&dest=3</a>
	</cfif>

	<h3>Parameters</h3>
	<ul>
		<li><b>lat</b> - latitude</li>
		<li><b>lon</b> - longitude (<b>long</b> is also accepted)</li>
		<li><b>dest</b> - <i>optional</i> destination station ID (<a href="#destStns">see the list below</a>)</li>
		<li><b>coords</b> - <i>alternatively</i>, coords may be specified instead of separate lat/lon parameters</li>
	</ul>

	<p>Latitude and Longitude should be specified as coordinates with at least three decimal places of precision. Alternatively, you may use a "coords" parameter that has both coordinates as one parameter.<br/>
		<b>Usage:</b> https://www2.epl.ca/ets/nearestLRT.cfm?coords=53.5443,-113.4892</p>
	<p>The "<b>dest</b>" parameter specifies your destination station ID and is optional. If it is omitted, the destination will default to Churchill Station unless Churchill is the nearest station, in which case the destination will default to Century Park Station.</p>


	
	<h3 id="destStns">Destination Station IDs</h3>
	<table>
		<thead>
			<tr>
				<th>ID</th>
				<th>Station Name</th>
			</tr>
		</thead>
		<cfoutput>
		<cfloop query="stations">
			<tr>
				<td>#StationID#</td>
				<td>#StationName#</td>
			</tr>
		</cfloop>
		</cfoutput>
	</table>

	</body>
	</html>
	<cfabort />
</cfif><!--- error --->

<!--- Now calculate the nearest station to the specified coordinates --->
<cfinclude template="/AppsRoot/Includes/functions/geodistance.cfm" />


<!--- Distance in meters. Initialize with circumference of the earth, as nothing should be further away than this. --->
<cfset MinDistance = 40000000 />
<cfset NearestStationID = 1 />

<cfloop query="stations">
	<cfset StnLat = Trim(ListGetAt(Coordinates, 1)) />
	<cfset StnLon = Trim(ListGetAt(Coordinates, 2)) />
	
	<cfset Distance = GeoDistance(url.lat, url.lon, StnLat, StnLon) />

	<cfif Distance LT MinDistance>
		<cfset MinDistance = Distance />
		<cfset NearestStationID = StationID />
	</cfif>

</cfloop>

<!--- Now determine a reasonable default destination station. This should be specified, but we make a default if not --->
<cfif NOT isNumeric(dest)>
	<!--- If the nearest station is Churchill, default to Century Park --->
	<cfif NearestStationID EQ 11>
		<cfset dest = 1 />
	<cfelse>
		<!--- Otherwise defaul to Churchill --->
		<cfset dest = 11 />
	</cfif>
</cfif>

<cflocation addtoken="false" url="https://www2.epl.ca/ETS/?from=#NearestStationID#&to=#dest#" />