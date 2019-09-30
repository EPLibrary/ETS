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

<cfset error = 0 />
<cfset errMsg = "" />

<cfif NOT isDefined('url.lat') OR NOT isNumeric(url.lat)>
	<cfset errMsg &= '<b>lat</b> not specified.<br />' />
	<cfset error++ />
</cfif>
<cfif NOT isDefined('url.lon') OR NOT isNumeric(url.lon)>
	<cfset errMsg &= '<b>lon</b> not specified.<br />' />
	<cfset error++ />
</cfif>
<cfif len(dest) EQ 0>
	<cfset errMsg &= '<b>dest</b> id not specified.<br />' />
	<cfset error++ />
<cfelse>
	<!--- Check that the destination station exists --->
	<cfquery name="checkStationID" dbtype="query">
		SELECT * FROM stations WHERE StationID=#dest#
	</cfquery>
	<cfif checkStationID.RecordCount EQ 0>
		<cfset error++ />
		<cfset errMsg &= '<b>dest</b> stationID <cfoutput>"#dest#"</cfoutput> does not exist.<br />' />
	</cfif>
</cfif>

<cfif error >
<html>
	<head>
		<title>Nearest Edmonton LRT Station</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
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

			.warning {
				color: rgb(200, 170, 0);
			}

			table {
				/*border: 1px solid #aaa;*/
				border-collapse: collapse;
			}

			table td, table th {
				padding:4px;
				border:1px solid rgba(127, 127, 127, .40);
			}

			table th {
				border-color: rgba(127, 127, 127, .40);
			}

			table thead tr {
				background-color:#444;
			}

			table thead tr th {
				color:white;
			}

			table tbody tr:nth-child(even):not(.heading) {
				background-color: #dddddd;
				background-color: rgba(127, 127, 127, 0.3);
			}

			table tbody tr:nth-child(odd):not(.heading) {
				/* could put another color here */
			}

			h1, h2, h3, h4 {
				margin-bottom:5px;
			}

			ul {
				margin-top:0;
			}

			@media (prefers-color-scheme: dark) {
				body {
					background-color: black;
					color: white;
				}

				.error {
					color:red;
				}


				a {
					color: #25caff;
				}



			}

		</style>
	</head>
	<body>

	<h1>Nearest LRT Station</h1>

	<p>This page automatically redirects to the Edmonton LRT Schedule for the station nearest to specified coordinates. This is useful for automated scripts like Siri Shortcuts in iOS 12+.</p>

	<cfif len(errMsg)>
		<h4>The following error<cfif error GT 1>s have<cfelse> has</cfif> occurred:</h4>
		<div class="error"><cfoutput>#errMsg#</cfoutput></div>
		<b>Valid example:</b> <a href="https://www2.epl.ca/ETS/nearestLRT.cfm?lat=53.5443&lon=-113.4892&dest=3">https://www2.epl.ca/ETS/nearestLRT.cfm?lat=53.5443&lon=-113.4892&dest=3</a>
	</cfif>

	<h2>Parameters</h2>
	<ul>
		<li><b>lat</b> - latitude</li>
		<li><b>lon</b> - longitude (<b>long</b> is also accepted)</li>
		<li><b>dest</b> - destination stationID (<a href="#destStns">see the list below</a>)</li>
		<li><b>coords</b> - <i>alternatively</i>, coords may be specified instead of separate lat/lon parameters</li>
	</ul>

	<p>Latitude and Longitude should be specified as decimal coordinates. Alternatively, you may use a "coords" parameter that has both coordinates, separated by a comma, as one parameter.<br/>
		<b>Usage:</b> <a href="https://www2.epl.ca/ets/nearestLRT.cfm?coords=53.5443,-113.4892&dest=1">https://www2.epl.ca/ets/nearestLRT.cfm?coords=53.5443,-113.4892&dest=1</a></p>
	<!--<p>The "<b>dest</b>" parameter specifies your destination station ID and is optional. If it is omitted, the destination will default to Churchill Station unless Churchill is the nearest station, in which case the destination will default to Century Park Station.</p>-->


	
	<h2 id="destStns">Destination Station IDs</h2>
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