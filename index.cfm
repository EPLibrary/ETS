<cfsetting showdebugoutput="true">

<cfset opType="LRT Schedule" />
<cfif isDefined('url.fromStop')><cfset opType="Bus Stop Schedule" />
<cfelseif isDefined('url.rid')><cfset opType="Bus Routes" />
</cfif>
<cfset PageTitle="#opType#">
<cfset PageTitleHead="#opType#" />


<!--- Toggle Dark Mode --->
<cfif isDefined('url.dark')>
	<cfif url.dark IS 1>
		<cfcookie name="LRT_DARK" value="true" expires="never" />
	<cfelseif url.dark IS 0>
		<cfcookie name="LRT_DARK" value="false" expires="never" />
	</cfif>
</cfif>


<cfif cgi.SCRIPT_NAME contains "EXEC(" OR cgi.PATH_INFO contains "EXEC(" OR cgi.QUERY_STRING contains "EXEC("><cfabort></cfif>

<!--- Actual HTML Page Begins --->
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="x-ua-compatible" content="IE=Edge" />
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0" />
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<!--- Geo calculation stuff --->
	<script defer src="latlon-spherical.min.js"></script>
    <script defer src="dms.min.js"></script>

	

	<script src="/Javascript/selectize/dist/js/standalone/selectize.min.js"></script>

	<link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
	<link rel="icon" type="image/png" href="/favicon.png" />
	<link rel="apple-touch-icon" sizes="180x180" href="touch-icon-iphone-retina.png" />
	<link rel="apple-touch-icon" sizes="167x167" href="touch-icon-ipad-retina.png" />


	<!--- Custom Stylesheet for www2.epl.ca --->
	<link rel="stylesheet" href="/w2.css?v=0" type="text/css"/>
	<link rel="stylesheet" href="ets.css?v=0" type="text/css"/>
	<link href="/Javascript/selectize/dist/css/selectize.css" type="text/css" rel="stylesheet" />


	<title><cfoutput>#PageTitleHead#</cfoutput></title>


</head>
<body class="<cfif isDefined('cookie.lrt_dark') and cookie.lrt_dark IS true>darkMode</cfif>">

	<script>
		//Utility functions for cookies
		function setCookie(key, value) {
			var expires = new Date();
			expires.setTime(expires.getTime() + (10 * 365 * 24 * 60 * 60 * 1000));
			document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
		}

		function getCookie(key) {
		    var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');
		    return keyValue ? keyValue[2] : null;
		}


		// We can see if the user wants dark mode here and set it if so
		// This approach allows the user to have a setting (saved in a cookie) that they can change, 
		// but it will automatically default to dark mode if their user agent says they prefer color scheme dark
		// Works as before on browsers that don't support prefers-color-scheme media query
		// Originally this was done on document.ready, however that causes a white flash.
		// This way the dark mode takes effect as soon as the body exists and the white flash shouldn't happen.
		// Note that I'm only able to use vanilla JS without any of my functions that are defined later.
		if (getCookie('LRT_DARK') === null && window.matchMedia("(prefers-color-scheme: dark)").matches) {
			// This is almost equivalent to toggleDarkMode() doesn't change the toggle link text, as it doesn't exist yet.
			setCookie('LRT_DARK', true);
			document.body.classList.toggle('darkMode');
		}
	</script>

	<!--- These are used for the map display --->
	<div id="mapModal"><div id="mapCanvas" /></div></div>
	<div id="closeMap"><a href="javascript:void(0);">Close Map</a></div>
	<div class="container clearfix">
	<!--- If a sidebar is defined, it will be inserted here --->

	<div class="page w2Contents">
	<!-- Page contents go below here -->
    

<div class="pageTitle">
<a href="https://www.epl.ca" style="height:38px;display:inline-block;vertical-align:bottom;"><svg id="eplLogo" width="143" height="38" xmlns="http://www.w3.org/2000/svg" xmlns:svg="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin">
  <path id="eplWordmark" d="m64.75716,24.93909c0.113,2.558 1.363,3.723 3.608,3.723c1.62,0 2.927,-0.994 3.182,-1.904l3.552,0c-1.14,3.467 -3.557,4.945 -6.88,4.945c-4.63,0 -7.5,-3.185 -7.5,-7.73c0,-4.403 3.04,-7.756 7.5,-7.756c5,0 7.415,4.21 7.13,8.728l-10.589,0l-0.003,-0.006zm6.566,-2.55c-0.37,-2.046 -1.25,-3.126 -3.21,-3.126c-2.558,0 -3.296,1.99 -3.354,3.13l6.564,0l0,-0.004zm6.42,-5.767l3.835,0l0,1.874l0.057,0c0.966,-1.563 2.557,-2.273 4.375,-2.273c4.603,0 6.678,3.728 6.678,7.9c0,3.92 -2.16,7.59 -6.45,7.59c-1.762,0 -3.438,-0.77 -4.404,-2.216l-0.052,0l0,6.99l-4.035,0l0,-19.871l-0.004,0.006zm10.91,7.386c0,-2.33 -0.938,-4.745 -3.524,-4.745c-2.642,0 -3.494,2.36 -3.494,4.75s0.91,4.66 3.523,4.66c2.643,0 3.495,-2.273 3.495,-4.66l0,-0.005zm6.562,-12.986l4.034,0l0,20.287l-4.034,0l0,-20.293l0,0.006zm7.386,15.913l4.46,0l0,4.375l-4.46,0l0,-4.375zm17.73,-5.143c-0.257,-1.647 -1.31,-2.53 -2.984,-2.53c-2.585,0 -3.438,2.615 -3.438,4.774c0,2.103 0.824,4.632 3.353,4.632c1.87,0 2.95,-1.193 3.21,-2.982l3.89,0c-0.51,3.892 -3.21,6.023 -7.076,6.023c-4.432,0 -7.416,-3.127 -7.416,-7.53c0,-4.575 2.73,-7.956 7.5,-7.956c3.467,0 6.65,1.82 6.905,5.57l-3.95,0l0.006,-0.001zm6.135,-0.653c0.227,-3.78 3.608,-4.916 6.903,-4.916c2.928,0 6.45,0.658 6.45,4.18l0,7.646c0,1.335 0.143,2.67 0.512,3.267l-4.09,0c-0.143,-0.454 -0.257,-0.936 -0.285,-1.42c-1.278,1.335 -3.154,1.82 -4.944,1.82c-2.79,0 -5,-1.394 -5,-4.406c0,-3.324 2.5,-4.12 5,-4.46c2.47,-0.37 4.77,-0.284 4.77,-1.933c0,-1.733 -1.195,-1.99 -2.615,-1.99c-1.536,0 -2.53,0.627 -2.673,2.22l-4.034,0l0.006,-0.008zm9.32,2.983c-0.683,0.596 -2.104,0.624 -3.354,0.852c-1.256,0.257 -2.39,0.683 -2.39,2.16c0,1.505 1.163,1.875 2.47,1.875c3.154,0 3.27,-2.5 3.27,-3.38l0,-1.513l0.004,0.006z" />
  <path d="m12.82716,1.75409l7.322,0l0,29.534l-7.327,0l0.005,-29.534z" fill="#7AC143"/>
  <path d="m23.84816,1.75409l7.323,0l0,29.534l-7.32,0l-0.003,-29.534z" fill="#E50E63"/>
  <path d="m34.87016,1.75409l7.32,0l0,29.534l-7.32,0l0,-29.534z" fill="#7D4199"/>
  <path d="m45.89216,1.75409l7.322,0l0,29.534l-7.322,0l0,-29.534z" fill="#009DDC"/>
  <path d="m1.80516,1.75409l7.322,0l0,29.534l-7.322,0l0,-29.534z" fill="#FDBB30"/>
</svg></a>
<cfoutput><span class="nowrap">#PageTitle#</span></cfoutput></div>




<div class="opMode">
<cfoutput>

<cfif NOT isDefined('url.fromStop') AND NOT isDefined('url.rid')>
	<span class="selectedMode" href="?">LRT Schedule</span>
<cfelse>
	<a href="?">LRT Schedule</a>
</cfif>

<cfif isDefined('url.fromStop')>
	<span class="selectedMode">Bus Stops</span>	
<cfelse>
	<a href="?fromStop">Bus Stops</a>	
</cfif>

<cfif isDefined('url.rid')>
	<span class="selectedMode">Bus Routes</span>
<cfelse>
	<a href="?rid">Bus Routes</a>
</cfif>

</cfoutput>

</div><!--.opMode-->


<!--- The most basic operation of this app will let you select a source and destination station
	and a Day and Time and it will show you the next times a train will stop there --->

<cfparam name="url.from" default="1">
<cfparam name="url.to" default="15">

<cfquery name="Stations" dbtype="ODBC" datasource="SecureSource">
	SELECT * FROM vsd.EZLRTStations
	ORDER BY CostFromOrigin
</cfquery>


<!--- Choose the active database to use. --->
<cfquery name="activedb" dbtype="ODBC" datasource="SecureSource">
	SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 1
</cfquery>

<cfset dbprefix = activedb.prefix />
<!--- TEMPORARILY SET THIS MANUALLY FOR TESTING. REMOVE THIS LINE FOR PRODUCTION!!! --->
<!--- <cfset dbprefix = 'ETS2' /> --->


<form class="w2Form" id="fromToForm">

<cfif isDefined('url.fromStop')>
<!--- 6500 stops! --->
<cfquery name="Stops" dbtype="ODBC" datasource="SecureSource">
SELECT * FROM vsd.#dbprefix#_stops_all_agencies_unique ORDER BY astop_id
</cfquery>
<!--- This makes for a massive 6500 item select --->
<label for="fromStop" id="fromStopLabel" class="selectizeLabel"><a href="javascript:void(0);" id="busStopLabelText" class="labelText" title="Click to show stops near your location">Bus Stops <!---<svg id="geoIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 960"><path d="M500 258.6l-490 245 9.6 1.2c5.2.5 107 8.2 226 16.8 133 9.8 217.5 16.5 218.8 18 1.2 1.2 8.3 87 18 219.6 8.5 119.7 16.4 221.3 17 226 1.3 7.7 6.3-1.8 246-482 135-269.4 245-490 244.6-489.7l-490 245z" /></svg>---><span class="nearestLink">&#x1f5fa; Select a Nearby Stop </span></a>
	<select name="fromStop" id="fromStop" class="selectizeField" multiple="multiple">
		<cfoutput query="Stops">
			<option value="#astop_id#" <cfloop list="#url.fromStop#" index="i"><cfif i EQ astop_id>selected</cfif></cfloop>>#astop_id# #stop_name#</option>
		</cfoutput>
	</select>
</label>




<!--- If url.rid is specified, we show the interface for selecting a route --->
<cfelseif isDefined('url.rid')>

<cfquery name="Routes" dbtype="ODBC" datasource="SecureSource">
	SELECT * FROM vsd.#dbprefix#_routes_all_agencies ORDER BY route_id
</cfquery>
<!--- This makes for a massive 6500 item select --->
<label for="rid" id="ridLabel" class="selectizeLabel"><a href="javascript:void(0);" id="nearbyRouteText"  class="labelText" title="Click to show nearby routes"><span id="mainBusRouteLabel">Bus Route</span> <svg id="geoIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 960"><path d="M500 258.6l-490 245 9.6 1.2c5.2.5 107 8.2 226 16.8 133 9.8 217.5 16.5 218.8 18 1.2 1.2 8.3 87 18 219.6 8.5 119.7 16.4 221.3 17 226 1.3 7.7 6.3-1.8 246-482 135-269.4 245-490 244.6-489.7l-490 245z" /></svg><span id="nearestRouteLink">Sort by Nearest</span></a>
	<select name="rid" id="rid" class="selectizeField">
		<option></option>
		<cfoutput query="Routes">
			<option value="#route_id#" <cfif url.rid IS route_id>selected</cfif>><cfif len(route_short_name)>#route_short_name#<cfelse>#route_id#</cfif> #route_long_name#</option>
		</cfoutput>
	</select>
</label>

<label for="routeFrom" id="routeFromLabel" class="selectizeLabel"><a href="javascript:void(0);" id="routeFromLabelText" class="labelText" title="Click to select stops on the above route">Departing From <!---<svg id="geoIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 960"><path d="M500 258.6l-490 245 9.6 1.2c5.2.5 107 8.2 226 16.8 133 9.8 217.5 16.5 218.8 18 1.2 1.2 8.3 87 18 219.6 8.5 119.7 16.4 221.3 17 226 1.3 7.7 6.3-1.8 246-482 135-269.4 245-490 244.6-489.7l-490 245z" /></svg>---><span id="nearestLink" class="nearestLink <cfif isDefined('url.rid') AND url.rid EQ "">eplhidden</cfif>">&#x1f5fa; Select Stop From Map </span></a>
	<select name="routeFrom" id="routeFrom" class="selectizeField">
	</select>
</label>

<label for="swapRouteFromTo" id="swapButtonLabel">
	<button type="button" id="swapRouteFromTo">&#8593; swap &#8595;</button>
</label>

<label for="routeTo" id="routeToLabel" class="selectizeLabel"><a href="javascript:void(0);" id="routeToLabelText" class="labelText" title="Click to select stops on the above route">Travelling To <!---<svg id="geoIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 960"><path d="M500 258.6l-490 245 9.6 1.2c5.2.5 107 8.2 226 16.8 133 9.8 217.5 16.5 218.8 18 1.2 1.2 8.3 87 18 219.6 8.5 119.7 16.4 221.3 17 226 1.3 7.7 6.3-1.8 246-482 135-269.4 245-490 244.6-489.7l-490 245z" /></svg>---><span id="selectRouteDestFromMapLink" class="nearestLink" <cfif isDefined('url.rid') AND url.rid EQ "">style="display:none;"</cfif>>&#x1f5fa; Select Stop From Map </span></a>

	<select name="routeTo" id="routeTo" class="selectizeField">
	</select>
</label>


<cfelse>


<label for="from" style="margin-bottom:0;" class="lrtDepart"><a href="javascript:void(0);" id="departLabelText" class="labelText" title="Click to set based on your location">Departing From <svg id="geoIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 960"><path d="M500 258.6l-490 245 9.6 1.2c5.2.5 107 8.2 226 16.8 133 9.8 217.5 16.5 218.8 18 1.2 1.2 8.3 87 18 219.6 8.5 119.7 16.4 221.3 17 226 1.3 7.7 6.3-1.8 246-482 135-269.4 245-490 244.6-489.7l-490 245z" /></svg><span class="nearestLink">Set Nearest</span></a>
	<select name="from" id="from">
		<cfoutput query="Stations">
			<option value="#StationID#" <cfif isDefined('url.from') AND url.from IS StationID>selected</cfif>>#StationName#</option>
		</cfoutput>
	</select>
</label>

<label for="swap" id="swapButtonLabel">
	<button type="button" id="swapFromTo">&#8593; swap &#8595;</button>
</label>

<label for="to" id="toLabel"><a href="javascript:void(0);" id="toLabelText" class="labelText" title="Click to choose station from map">Travelling To &nbsp; &#x1f5fa;<span id="lrtMapTo">Select From Map</span></a>
	<select name="to" id="to">
		<cfoutput query="Stations">
			<option value="#StationID#" <cfif isDefined('url.to') AND url.to IS StationID>selected<cfelseif NOT isDefined('url.to') AND StationID IS 15>selected</cfif>>#StationName#</option>
		</cfoutput>
	</select>
</label>

</cfif><!---if not in bus stop mode --->

<div class="formItem" id="timeLabel"><a href="javascript:void(0);" id="timeLabelText">Time <span id="nowLink">Reset</span></a>
	<span class="formGroup" id="timeGroup">
	<select name="time" id="time" style="width:calc(50% - 15px);margin-right:10px">
		<option value="">Now</option>
		<!--- <option value="1:00" <cfif isDefined('url.time') AND url.time IS "1:00">selected</cfif>>1:00 AM</option> --->
		<cfloop from="1" to="23" index="hour"><cfoutput>
			<option value="#hour#:00" <cfif isDefined('url.time') AND url.time IS "#hour#:00">selected</cfif>>#timeFormat(hour&":00", "h:mm tt")#</option>
		</cfoutput></cfloop>
		<!--- This special option ensures we are using the same day to prevent ambiguity --->
		<option value="23:59" <cfif isDefined('url.time') AND url.time IS "23:59">selected</cfif>>11:59 PM</option>
	</select>

	<select name="dow" id="dow" style="width:50%">
		<option value="">Today</option>
		<cfloop from="1" to="7" index="day"><cfoutput>
			<option value="#Left(DayOfWeekAsString(day),3)#" <cfif isDefined('url.dow') AND url.dow IS Left(DayOfWeekAsString(day),3)>selected</cfif>>#DayOfWeekAsString(day)#</option>
		</cfoutput></cfloop>
	</select>
	</span><!--.formGroup-->

</div><!--timeLabel-->

<label class="formSubmit" style="display:none;">
	<input type="submit" value="Show Departure Times" />
</label>



</form>

<!--- This is where the map showing the stop will go, I suppose... there can be more than one, though --->
<div style="clear:both">&nbsp;</div>
<div id="mapNotice"><!--- &#x2139;  --->Tap times to see details &amp; maps.<!---  &#x1f5fa; ---></div>

<div class="departures" id="departures">
<!--- this is where the tables will go --->
<cfif isDefined('url.fromStop')>
	<cfinclude template="stopTimesGTFS.cfm" />	
<cfelseif isDefined('url.rid')>
	<cfif isDefined('url.RouteFrom')><cfset url.from = url.routeFrom /></cfif>
	<cfif isDefined('url.RouteTo')><cfset url.to = url.routeTo /></cfif>
	<cfinclude template="departureTimesRoutesGTFS.cfm" />
<cfelse>
	<cfinclude template="departureTimesGTFS.cfm" />
</cfif>

</div><!--departures-->

<cfif isDefined('url.fromStop')><a href="javascript:void(0);" id="closestStations" style="text-decoration:none;">&#x1f5fa; <span style="text-decoration:underline;">Show Nearby Stops</span><br /><span class="tinytip">Tap a stop on the map to show times</span></a></cfif>

<p style="font-size:13px;color:#555;"><b>Note:</b> Times may vary by 2 minutes.</p>


<div class="opMode">
<p id="nightModeLink">
	<cfif isDefined('cookie.lrt_dark') AND cookie.lrt_dark IS true>
		<a href="javascript:void(0);"><img src="/Resources/images/sun.svg" /> Light Mode</a>
	<cfelse>
		<a href="javascript:void(0);"><cfinclude template="/Resources/Images/moon.svg" /> Dark Mode</a>
	</cfif>
</p>
</div>

<!-- Page contents go above here -->
</div><!--.page .w2Contents-->
</div><!--.container .clearfix-->


<script src="https://www2.epl.ca/javascript/markerclusterer.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDSa2O8vPJLSS0e4GqO9Fh9COFZt0GP1IU"></script>
<script src="https://www2.epl.ca/javascript/geolocation-marker.js?v2" async defer></script>
<script>


// loads new departure times via ajax
function refreshDepartureTimes() {
	var fromVal = $('#from').val();
	var toVal = $('#to').val();
	var timeVal = $('#time').val();
	var dowVal = $('#dow').val();
	if (dowVal.length > 0 || timeVal.length > 0) $('#nowLink').show();
	else $('#nowLink').hide();

	$.get('departureTimesGTFS.cfm', {from:fromVal, to:toVal, time:timeVal, dow:dowVal<cfif isDefined('url.destTime')>, destTime:true</cfif>}).done(function(data) {
		$('#departures').html(data);
		// update page URL so that you get the same data if you hit refresh
		window.history.pushState("", "LRT Schedule", "?from="+fromVal+"&to="+toVal+"&time="+timeVal+"&dow="+dowVal<cfif isDefined('url.destTime')>+"&destTime"</cfif>);
		// Refresh the arrival times so they don't go blank for a couple seconds
		updateArrivalTimes();
		bindShowArrival();

		//Close the map
		$('#mapModal').hide();
		$('#closeMap').hide();

	});
}

// loads new bus stop times via ajax
function refreshStopTimes() {
	var fromStop = $('#fromStop').val();
	var timeVal = $('#time').val();
	var dowVal = $('#dow').val();
	if (dowVal.length > 0 || timeVal.length > 0) $('#nowLink').show();
	else $('#nowLink').hide();

	$.ajax('stopTimesGTFS.cfm', { data:{fromStop:fromStop, time:timeVal, dow:dowVal}, traditional:true}).done(function(data) {
		$('#departures').html(data);
		// update page URL so that you get the same data if you hit refresh
		window.history.pushState("", "Bus Stop Schedule", "?fromStop="+fromStop+"&time="+timeVal+"&dow="+dowVal);
		// Refresh the arrival times so they don't go blank for a couple seconds
		updateArrivalTimes();
		bindShowArrival();

		// Update the times with GTFS RealTime data
		updateTrips();
	});

}

//signals brand new load... feels like a crappy hack
var newLoad = true;

// Updates the list of routes with new routes based on proximity
async function refreshRoutes() {
	if (navigator.geolocation) {
		var originalRid = $('#rid').val();
		$('#mainBusRouteLabel').html('Loading...');
        getUserPosition().then((position) => {
			$.post('nearbyRoutes.cfm', {lat:position.coords.latitude, lon:position.coords.longitude, dow:$('#dow').val(), time:$('#time').val()}).done(function(data) {
				ridSelectize.clearOptions();
				ridSelectize.addOption(data);
				$('#mainBusRouteLabel').html('Nearby Route');
				//automatically select the first option. This is more to show that stuff is happening.
				$('#rid').addClass('nearestRoutes');
				// Try to set the original RID if it's still available in the new list
				ridSelectize.setValue(originalRid);
			});
        });
    }
}

//Refresh routes when clicking on the "nearest routes" link
$('#nearestRouteLink').click(function() {
	refreshRoutes();
});


// Updates the dropdowns for from/to stops for a route
function refreshRouteStops() {
	var originalFrom = $('#routeFrom').val();
	if (newLoad && originalFrom.length == 0) {
		<cfif isDefined('url.routeFrom') AND len(url.routeFrom)>originalFrom = <cfoutput>"#url.routeFrom#"</cfoutput>;</cfif>
	}
	$.get('routeStops.cfm', {rid:$('#rid').val()}).done(function(data) {
		// remove existing options
		// $('#routeFrom, #routeTo').html('');
		routeFromSelectize.clearOptions();
		// routeToSelectize.clearOptions();

		routeFromSelectize.addOption(data);
		// routeToSelectize.addOption(data);
		// $('#routeFrom, #routeTo').append('<option></option>');
		//Loop through data field and add an option for each
		// $.each(data.DATA, function(i, value) {
		// 	$('#routeFrom, #routeTo').append('<option value="'+data.DATA[i][0]+'">'+data.DATA[i][0]+' '+data.DATA[i][1]+'</option>');
		// });

		//Initializes list of stops for the selected route that can be used for map markers
		stopsByDist = data;

		if (data.length) {
		// Show the "find stop on map" link after a route is selected
			$('#nearestLink').show();
		}

		// $('#routeFrom').selectize({highlight:false});
		if (newLoad) {
		<cfif isDefined('url.routeFrom') AND isNumeric(url.routeFrom)>
			routeFromSelectize.addItem(<cfoutput>"#url.routeFrom#"</cfoutput>,true);
		</cfif>
		<cfif isDefined('url.routeTo') AND isNumeric(url.routeTo)>
			routeToSelectize.addItem(<cfoutput>"#url.routeTo#"</cfoutput>,true);
			// refreshRouteToStops(<cfoutput>#url.routeTo#</cfoutput>);
		<cfelse>
			// refreshRouteToStops();
		</cfif>


		}
		// Replace the old value, if possible. This will trigger change, and thus refreshRouteToStops()
		routeFromSelectize.setValue(originalFrom);

		newLoad=false;

	});
}


var routeToCoords = [];

function refreshRouteToStops(stopId) {
	var originalTo = $('#routeTo').val();
	// console.log('newLoad: '+newLoad);
	if (newLoad && originalTo.length == 0) {
		<cfif isDefined('url.routeTo') AND len(url.routeTo)>originalTo = <cfoutput>"#url.routeTo#"</cfoutput>;</cfif>
	}
	var routeTo = $('#routeTo').val();
	if ($('#routeFrom').val().length) {
		$.get('routeStops.cfm', {rid:$('#rid').val(), routeFrom:$('#routeFrom').val()}).done(function(data) {
			if (data.length) {
			// Show the "find stop on map" link after a route is selected
				$('#selectRouteDestFromMapLink').show();
			}
			routeToSelectize.clearOptions();
			routeToSelectize.addOption(data);

			//Update routeToCoords which the map can use
			routeToCoords = data;

			if (stopId) {
				routeToSelectize.addItem(stopId);
			}

			routeToSelectize.setValue(originalTo);


		});
	}//if routeFrom
}

// loads new route stops into routeFrom/routeTo dropdowns when route is changed
$('#rid').change(function() {
	refreshRouteStops();
});

$('#routeFrom').change(function(){
	refreshRouteToStops();
});

$('#routeFrom, #routeTo').change(function(){
	refreshRouteDepartureTimes();
});


// loads new departure times via ajax
function refreshRouteDepartureTimes() {
	var fromVal = $('#routeFrom').val();
	var toVal = $('#routeTo').val();
	var timeVal = $('#time').val();
	var dowVal = $('#dow').val();
	var rid = $('#rid').val();
	if (dowVal.length > 0 || timeVal.length > 0) $('#nowLink').show();
	else $('#nowLink').hide();

	$.get('departureTimesRoutesGTFS.cfm', {rid:rid, from:fromVal, to:toVal, time:timeVal, dow:dowVal<cfif isDefined('url.destTime')>, destTime:true</cfif>}).done(function(data) {
		$('#departures').html(data);
		// update page URL so that you get the same data if you hit refresh
		window.history.pushState("", "Bus Route Schedule", "?rid="+rid+"&routeFrom="+fromVal+"&routeTo="+toVal+"&time="+timeVal+"&dow="+dowVal<cfif isDefined('url.destTime')>+"&destTime"</cfif>);
		// Refresh the arrival times so they don't go blank for a couple seconds
		updateArrivalTimes();
		bindShowArrival();
		// Update the times with GTFS RealTime data
		updateTrips();
	});
}






$('#from, #to').change(function(){
	refreshDepartureTimes();
});

$('#fromStop').change(function(){
	refreshStopTimes();
});

<cfif isDefined('url.fromStop')>
$('#time, #dow').change(function(){
	refreshStopTimes();
});
<cfelseif isDefined('url.rid')>
$('#time, #dow').change(function(){
	refreshRouteDepartureTimes();
	if ($('#rid').length && $('#rid').hasClass('nearestRoutes')) {
		// This could either be useful or annoying having the selected route disappear when refreshing
		var originalRid = $('#rid').val();

		refreshRoutes();
	}
});
<cfelse>
$('#time, #dow').change(function(){
	refreshDepartureTimes();
});

</cfif>




$('#swapFromTo').click(function(){
	var fromVal = $('#from').val();
	var toVal = $('#to').val();
	$('#to').val(fromVal);
	$('#from').val(toVal);

	refreshDepartureTimes();
});


$('#timeLabelText').click(function(){
	$('#time').val('');
	$('#dow').val('').trigger('change');
});


function updateArrivalTimes() {
	$('tr:not(.skipped) .aT').each(function() {
		var thisTime = $(this).html();
		//Here are a bunch of hacks to get Safari to create a valid date
		var thisDate = $(this).attr('data-datetime').replace('-', '/');
		thisDate = thisDate.replace('-', '/');
		thisDate = thisDate.replace('.0', '');

		var date1 = new Date(thisDate);
		var dateNow = new Date();
		var day = 1;


		var secondsToDeparture = (date1-dateNow)/1000;

		// Now insert the seconds into the other field
		var timeString = Math.floor(secondsToDeparture/60) + " min"
		// if (Math.floor(secondsToDeparture/60) != 1) timeString+="s";

		// Handle time over an hour
		if (secondsToDeparture/60 > 60) {
			var hoursToDeparture = Math.floor(secondsToDeparture/60/60)
			timeString = hoursToDeparture + "hr";
			// if (hoursToDeparture > 1) {
			// 	timeString += "s";
			// }
			timeString += " "+Math.floor((secondsToDeparture%3600)/60) + "min";
		}

		if (secondsToDeparture < 60) timeString = '<span class="due">Arriving</span>';

		if (secondsToDeparture < -60) timeString = '<span class="gone">Departed</span>';
		
		// Don't bother showing the timeString if we're not looking at the current day, since it's pretty irrelevant
		// and likely to just be wrong anyways.
		// if ($('#dow').val().length > 0) timeString = "";
		// $(this).next().html(secondsToDeparture);
		$(this).next().html(timeString);

	});
}

// Show some kind of countdown - minutes and seconds until arrival
updateArrivalTimes();
setInterval(function(){updateArrivalTimes();}, 2000);

<!--- Include a table of bus stop coordinates if relevant --->
<cfif isDefined('url.fromStop')>
	var $fromStopselect;
	var selectize;
	var stopCoords = [
	<cfoutput query="Stops">
	<cfif CurrentRow GT 1>,</cfif>{id:"#astop_id#", lat:#trim(stop_lat)#, lon:#trim(stop_lon)#}
	</cfoutput>];
	var stopsByDist = stopCoords;
	$(document).ready(function() {
		// Turns out that there's a bad bug in highlighting that eats characters as you type, so we disable that
		$fromStopselect = $("#fromStop").selectize({highlight:false});
		selectize = $fromStopselect[0].selectize; // This stores the selectize object to a variable (with name 'selectize')
	});

<cfelseif isDefined('url.rid')>

$('#swapRouteFromTo').click(function(){
	var fromVal = $('#routeFrom').val();
	var toVal = $('#routeTo').val();
	if (toVal.length > 0) {
		routeFromSelectize.clear(true);
		routeToSelectize.clear(true);
		routeFromSelectize.addItem(toVal, true);
		refreshRouteToStops();
		routeToSelectize.addItem(fromVal, true);
		// Not sure what'll happen here, since the stop may not exist... likely will be blank
		refreshRouteDepartureTimes();
	}
});

var $ridselect;
var ridSelectize;
var $routeFromselect;
var routeFromSelectize;
var $routeToselect;
var routeToSelectize;
	$(document).ready(function() {
		// Turns out that there's a bad bug in highlighting that eats characters as you type, so we disable that
		$ridselect = $("#rid").selectize({highlight:false});
		ridSelectize = $ridselect[0].selectize;
		$routeFromselect = $('#routeFrom').selectize({highlight:false});
		routeFromSelectize = $routeFromselect[0].selectize;
		$routeToselect = $('#routeTo').selectize({highlight:false});
		routeToSelectize = $routeToselect[0].selectize;		
		refreshRouteStops();
		//selectize = $ridselect[0].selectize; // This stores the selectize object to a variable (with name 'selectize')
	});

var stopsByDist = [];

<cfelse>
<!--- Stuff specific to the LRT mode can go here --->
// Create JS object of station coords with coldfusion query loop
var stationCoords = [
<cfset c=0><cfoutput query="Stations">
<cfif c>,</cfif>{id:#StationID#<cfloop list="#coordinates#" index="i">, <cfif c++ MOD 2 IS 0>lat<cfelse>lon</cfif>:#trim(i)#</cfloop>, abbr:"#abbr#", name:"#StationName#"}
</cfoutput>];



function setNearestStation() {
    if (navigator.geolocation) {
        getUserPosition().then((position) => {findClosestStation(position);});
    }
}

function findClosestStation(position) {
	// The number of stops to show
	var stopQty = 4;
    var userLat = position.coords.latitude;
    var userLon = position.coords.longitude;

    var closestStation="";


    // Default to about the furthest point on earth in meters 21,000 km
    var closestDistance="21000000";

    // Loop through all stops
    <cfif isDefined('url.fromStop')>
    sortStopsByDist(position);

	var closeStops = new Array();
	for (i=0;i<stopQty;i++) {
		closeStops[i] = stopsByDist[i].id;
	}

	selectize.setValue(closeStops);
	// $('#fromStop').val(closeStops);
	// $('#fromStop').trigger('change');
    <cfelse>

	// Loop through all stations 
	stationCoords.forEach(function(station){
		var dist=geoDistance(userLat, userLon, station.lat, station.lon);
		if (dist < closestDistance) {
			closestDistance=dist;
			closestStation=station.id;
		}
	});

	// If the user's closest station is the one they had set as their destination,
	// I'm going to assume they want to go back to where they came from.
	// This has to be more useful than having from and to be the same
	if ($('#to').val() == closestStation) {
		$('#to').val($('#from').val());
	}
	$('#from').val(closestStation).trigger('change');

	</cfif>
}

$('#departLabelText').click(function(){
	setNearestStation();
});

$('#toLabelText').click(function(){
	initMap('lrt');
});


<!--- Returns coordinates for the most complex shapes for each LRT line --->
<cfquery name="CapitalShape" dbtype="ODBC" datasource="SecureSource">
  SELECT * FROM vsd.#dbprefix#_shapes
  WHERE shape_id=(SELECT TOP 1 shape_id AS ptQty FROM vsd.#dbprefix#_shapes 
  		WHERE shape_id like '501-%' GROUP BY shape_id ORDER BY count(*) DESC
  )
</cfquery>

<cfquery name="MetroShape" dbtype="ODBC" datasource="SecureSource">
  SELECT * FROM vsd.#dbprefix#_shapes
  WHERE shape_id=(SELECT TOP 1 shape_id AS ptQty FROM vsd.#dbprefix#_shapes 
  		WHERE shape_id like '502-%' GROUP BY shape_id ORDER BY count(*) DESC
  )
</cfquery>

<cfoutput>
var capitalShape = [<cfloop query="CapitalShape"><cfif currentRow GT 1>,</cfif>{lng:#shape_pt_lon#,lat:#shape_pt_lat#}</cfloop>];
var metroShape = [<cfloop query="MetroShape"><cfif currentRow GT 1>,</cfif>{lng:#shape_pt_lon#,lat:#shape_pt_lat#}</cfloop>];
</cfoutput>




</cfif><!--- end mode specific JS --->




// Experimental calculation of distance from stations
function geoDistance(lat1, lon1, lat2, lon2) {
    var p1 = new LatLon(Dms.parseDMS(lat1), Dms.parseDMS(lon1));
    var p2 = new LatLon(Dms.parseDMS(lat2), Dms.parseDMS(lon2));
    var dist = parseFloat(p1.distanceTo(p2).toPrecision(4));
    return dist;
}




function sortStopsByDist(position) {
	if (stopsByDist.length) {
		stopsByDist.forEach(function(stop){
			var dist=geoDistance(position.coords.latitude, position.coords.longitude, stop.lat, stop.lon);
			stop.dist=dist;
		});
		// Now we should have distances in stopsByDist
		stopsByDist.sort(function(a, b) {
			return parseFloat(a.dist) - parseFloat(b.dist);
		});
	}
}




$('#closestStations, #busStopLabelText, #routeFromLabelText').click(function(){
	   if (navigator.geolocation) {

		initMap();


       } else {
       	alert("Sorry, your browser does not support geolocation.")
       }
});

$('#routeToLabelText').click(function(){
	initMap('routeDest');
});

// Tapping on a row shows the hidden row beneath and hides all others
function bindShowArrival() {
	$('.departures tr[data-tripid]').click(function(){
		if ($(this).next().is(":visible")) $(this).next().hide()
		else {
			//This localizes the hiding to the current table for multi-leg routes
			$(this).parent().children('.dR').hide();
			$(this).next().show();
			// If the map is visible, update it automatically
			if ($('#mapModal').is(":visible")) {
				$(this).next().find('.mapLink').trigger('click');
			}
		}
	});

	$('.mapLink').click(function(){
		var thisStopID = $(this).parents('table').attr('data-stopid');
		var thisTripID = $(this).attr('data-tripid');
		var thisSequence = $(this).attr('data-sequence');
		// Show the map with this trip on it
		if ($('#routeTo').val()) initMap(thisStopID, thisTripID, thisSequence, $('#routeTo').val());
		else if ($('#to').val()) initMap(thisStopID, thisTripID, thisSequence, $('#to').val());
		else initMap(thisStopID, thisTripID);
	});

}


function toggleDarkMode() {
	$('body').toggleClass('darkMode');
	if (getCookie('LRT_DARK') === "true") {
		setCookie('LRT_DARK', "false");
		$('#nightModeLink a').html('<cfinclude template="/Resources/Images/moon.svg" /> Dark Mode');
	}
	else {
		setCookie('LRT_DARK', "true");
		$('#nightModeLink a').html('<img src="/Resources/images/sun.svg" /> Light Mode');
	}
}

$('#nightModeLink a').click(function(){
	toggleDarkMode();
});


function formatTime(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var seconds = date.getSeconds();
  var ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  hours = hours ? hours : 12; // the hour '0' should be '12'
  minutes = minutes < 10 ? '0'+minutes : minutes;
  var strTime = hours + ':' + minutes + ' ' + ampm;
  //return date.getMonth()+1 + "/" + date.getDate() + "/" + date.getFullYear() + "  " + strTime;
  return strTime;
}

function formatDate(date) {
  var hours = date.getHours();
  var minutes = date.getMinutes();
  var seconds = date.getSeconds();
  // var ampm = hours >= 12 ? 'PM' : 'AM';
  // hours = hours % 12;
  // hours = hours ? hours : 12; // the hour '0' should be '12'
  minutes = minutes < 10 ? '0'+minutes : minutes;
  var strTime = hours + ':' + minutes + ':' + seconds + ".0";
  return date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + strTime;
 
}


// GTFS TripUpdates
function updateTrips() {
	$('table[data-stopid]').each(function(index) {
		var stopid = $(this).attr('data-stopid');
		var trips = [];
		$('tr[data-tripid]').each(function(index) {
			trips.push($(this).attr('data-tripid'));
		});
		if (trips.length > 0)
		$.post('tripUpdateDB.cfm', {"tid":trips.join(", "), "stopid":stopid}).done(function(data) {

			//Now inject this data into the page somehow or another
			$.each(data.message.entity, function(index, value) {
				// console.log(value.trip_update);
				$.each(value.trip_update.stop_time_update, function(stindex, stvalue) {
					if (stvalue.departure) {
						// Removed the "skipped" class in case this changes
						$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"]').removeClass('skipped');
						// either departure or arrival might be defined. I think we usually use departure here
						var schedRel = stvalue.schedule_relationship;
						var utcSeconds = stvalue.departure.time;
						var d = new Date(0); // The 0 here sets the date to the epoch
						d.setUTCSeconds(utcSeconds);
						//Update the datetime attribute with the estimated actual time
						$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').attr('data-datetime', formatDate(d));
						//Update the display time
						$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').html(formatTime(d));

						//Calculate how late/early the bus is
						var estTime = $('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').attr('data-datetime');

						var schTime = $('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').attr('data-scheduled');

						if (estTime && schTime) {
							//Here are a bunch of hacks to get Safari to create a valid date
							estTime = estTime.replace('-', '/');
							estTime = estTime.replace('-', '/');
							estTime = estTime.replace('.0', '');

							schTime = schTime.replace('-', '/');
							schTime = schTime.replace('-', '/');
							schTime = schTime.replace('.0', '');

							var estDate = new Date(estTime);
							var schDate = new Date(schTime);

							var secondsLate = (estDate-schDate)/1000;

							// Now insert the seconds into the other field
							var timeString = Math.abs(Math.floor(secondsLate/60)) + " min";
							if (Math.abs(secondsLate) < 100 ) timeString = Math.abs(secondsLate) + " sec";
							if (secondsLate < 0) timeString += " early";
							else if (secondsLate > 0) timeString += " late";
							// Don't bother updating unless the time difference is bigger than 20 seconds but NOT greater than 8 hours
							if ( (secondsLate < -20 || secondsLate > 20) && secondsLate < 28800 && secondsLate > -28800 ) {
								$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"]+tr.dR .lateness').html(timeString);

								$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').removeClass('rtLate rtEarly');
								if (secondsLate < 0) {
									$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').addClass('rtEarly');
								}
								if (secondsLate > 0) {
									$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .aT').addClass('rtLate');
								}						
							}

							// Now if the schedule relationship is "SKIPPED" we show that here
							if (schedRel == "SKIPPED") {
								$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"]+tr.dR .lateness').html('Stop will be skipped');
								$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"]').addClass('skipped');
								$('table[data-stopid="'+stvalue.stop_id+'"] tr[data-tripid="'+value.id+'"] .cD').html('Skipped');
								
							}
						}//end if estTime && schTime

					}//end if stvalue.departure
				});//each stop_time_update
			});

		});
	});
}//updateTrips()


//Initialization tasks
$(document).ready(function() {
	bindShowArrival();
	// Update using realtime data after this page is loaded.
	updateTrips();
	//Update Trip schedule every 90 seconds
	setInterval(function(){updateTrips();}, 90000);

	// Hide the "Select stop from map" link on Routes page if there's no route selected
	<cfif isDefined('url.rid') AND url.rid EQ "">
	$('#nearestLink').hide();
	</cfif>
	// Hide the Reset time link if there's no time specified
	<cfif NOT isDefined('url.time') OR (isDefined('url.time') AND url.time EQ "")>
	$('#nowLink').hide();
	</cfif>
	// Originally a function was run here to auto-switch to night mode based on the media query for
	// prefers-color-scheme. Unfortunately this causes a white flash until the whole page is loaded,
	// So instead I have almost all this evaluate as soon as the body element exists.
	// This will result in the toggle link being wrong, though. This should fix it after the DOM is ready.
	// This just makes sure the 
	if (getCookie('LRT_DARK') === "true") {
		$('#nightModeLink a').html('<img src="/Resources/images/sun.svg" /> Light Mode');
	}
});



//Google maps
var map;

var iconBase = 'https://www2.epl.ca/images/map/';


// Do not directly access these variables - they are used as a placeholder by the getUserPosition and getUserPos functions
// When defined, this stores the geolocation information
var userPosition;

// This is the simpler lat/lng used by Google maps
var userPos;

//Updates the userPosition variable whenever the position changes
function setUserPosition(position) {
	//console.log('setting UserPosition...');
	userPosition = position;
	userPos = {lat: position.coords.latitude, lng: position.coords.longitude}
}

//Returns the user position using geolocation in a way that shouldn't break maps and stuff.
//If geolocation isn't supported we default to Alberta Legislature building.
var getUserPosition = function() {
	return new Promise(function (resolve, reject) {
		var defaultPos = {coords: {latitude: 53.534242, longitude: -113.506374}};
		// Central Sherwood Park, for testing
		// defaultPos = {coords: {latitude: 53.541127, longitude: -113.295562}};
		if (navigator.geolocation) {
			if (typeof userPosition !== "undefined") {
				resolve(userPosition);
			} else {
				// We rely on GeoMarker to do this now
				// Registers handler to keep userPosition updated
				//navigator.geolocation.watchPosition(setUserPosition);
				// Tells the browser to submit the current position for now
				// after this we use userPosition
				navigator.geolocation.getCurrentPosition(resolve, reject);
			}
		} else {
			console.log('Your browser does not support geolocation. Ensure it is enabled in the settings.');
			resolve(defaultPos);
		}
	});
}//end getUserPosition

var getUserPos = function() {
	return new Promise(function (resolve, reject) {
		getUserPosition().then(function(position) {
			resolve({lat: position.coords.latitude, lng: position.coords.longitude});
		});
	});
}


var geomarkerCreated = false;
var GeoMarker;

// Polyline that shows the busroute on the map
var busRoute;

// An array of all markers to show on Google Map
var markers = [];
var markerCluster;


//Attempting to fix .getCurrentPosition callback only firing once with multiple calls

// Initializes the google map - stop is required
// trip is optional and will show a route if a valid trip is specified.
// Filling in the seq and dest will allow subsequent stops on the trip to be shown
function initMap(stop, trip, seq, dest) {

var needsRefresh = false;
//Universal stuff for all types of calls
var icons = {
  stopBlue: {
    icon: {
        url: iconBase + 'Stop_Icon_Blue_Narrow.svg',
        scaledSize: new google.maps.Size(20, 41),
        origin: new google.maps.Point(0,0)
    }
  },
  stopRed: {
    icon: {
        url: iconBase + 'stop_icon_red.svg',
        scaledSize: new google.maps.Size(55, 55),
        origin: new google.maps.Point(0,0)
    }
  },
  stopGreen: {
    icon: {
        url: iconBase + 'stop_icon_green.svg',
        scaledSize: new google.maps.Size(60, 55),
        origin: new google.maps.Point(0,0)
    }
  }
  //,library: {icon: iconBase + 'library_icon.png'}
};//end icons

//Initialize basic map
//Defaults to location of Alberta Legislature
var defaultPos = {lat: 53.534242, lng: -113.506374};
if (!map) {
	map = new google.maps.Map(document.getElementById('mapCanvas'), {
		center: defaultPos,
		gestureHandling: 'greedy',
		zoom: 15
	});
} else {
	needsRefresh = true;
	if (typeof busRoute !== "undefined") busRoute.setMap(null);
	if (typeof capitalLine !== "undefined") capitalLine.setMap(null);
	// Remove markers
	for(i=0; i<markers.length; i++){
        markers[i].setMap(null);
    }
    markers = [];
    if (markerCluster) markerCluster.clearMarkers();
}

if (navigator.geolocation) {
	if (!geomarkerCreated) {
		GeoMarker = new GeolocationMarker(map);
		geomarkerCreated = true;
		// console.log('created geoMarker');
	}
}


if (stop=="lrt") {
	// Center on Churchill station
	map.setCenter({lat: 53.544309, lng: -113.48917});
	map.setZoom(13);

	stationCoords.forEach(function(station){
		if (typeof station === "undefined" || typeof station.lat === "undefined" || typeof station.lon === "undefined" || typeof station.id === "undefined") {
			//Bad station? Handle error here if necessary				
		} else {
		    var marker = new google.maps.Marker({
			    position: {lat:station.lat, lng:station.lon},
			    label: ""+station.abbr,
				title: station.name,
				icon: icons["stopGreen"].icon
		    });

		    marker.addListener('click', function() {
	          $('#to').val(station.id);
	          $('#to').trigger('change');
	          closeMap();

	        });
		    markers.push(marker);
		}
	});
	markerCluster = new MarkerClusterer(map, markers, {imagePath:iconBase+"m",gridSize:30,maxZoom:16,minimumClusterSize:2});

	// The above is fabulous, but I want to draw both of the lines on the map. How can I do that?
		busRoute = new google.maps.Polyline({
	      path: metroShape,
	      geodesic: true,
	      strokeColor: '#FF3333',
	      strokeOpacity: .4,
	      strokeWeight: 6
	    });

		capitalLine = new google.maps.Polyline({
	      path: capitalShape,
	      geodesic: true,
	      strokeColor: '#3333FF',
	      strokeOpacity: .4,
	      strokeWeight: 6
	    });

    	busRoute.setMap(map);
    	capitalLine.setMap(map);

} else if (stop=="routeDest") {
	// Handle selecting a route destination.
	map.setZoom(15);
	if (routeToCoords.length) {
		// This picks a stop in the middle of the list, but they aren't sorted by stop_sequence anyways (which is tricky to do)
		var midStop = routeToCoords[Math.floor(routeToCoords.length/2)];

		map.setCenter({lat: midStop.lat, lng: midStop.lon});

		//Draw the bus route
		$.get("routeShape.cfm", {rid:$('#rid').val()}).done(function(data){
			busRoute = new google.maps.Polyline({
			path: data.shape,
			geodesic: true,
			strokeColor: '#FF3333',
			strokeOpacity: .4,
			strokeWeight: 6
			});
			busRoute.setMap(map);
		});

	}


	//Get the route stops so I can plot all the points
	// Where should the center be? The median stop



	routeToCoords.forEach(function(stop){
		if (typeof stop === "undefined" || typeof stop.lat === "undefined" || typeof stop.lon === "undefined" || typeof stop.id === "undefined") {
			//Bad stop? Handle error here if necessary				
		} else {
		    var marker = new google.maps.Marker({
			    position: {lat:stop.lat, lng:stop.lon},
			    label: ""+stop.id,
				icon: icons["stopGreen"].icon,
				map: map
		    });

		    marker.addListener('click', function() {
	          routeToSelectize.setValue(stop.id);
	          closeMap();

	        });
		    markers.push(marker);
		}
	});
	markerCluster = new MarkerClusterer(map, markers, {imagePath:iconBase+"m",gridSize:30,maxZoom:16,minimumClusterSize:2});



} else if (stop) {
// else if a stop is truthy, make ajax call to get stop coordinates and name from the stop parameter
$.get('stopInfo.cfm?stopid='+stop+'&trip='+trip+'&seq='+seq+'&dest='+dest).done(function(data){

	var stopPos = {lat: data.stop.stop_lat, lng: data.stop.stop_lon};
	map.setCenter(stopPos);

	//Add labels to the map
	stopLabel = data.stop.stop_id;
	if (data.stop.sc.length) {
		stopLabel = data.stop.sc;
	}
	var marker = new google.maps.Marker({
	  position: stopPos,
	  label: ""+stopLabel,
	  title: data.stop.stop_name,
	  icon: icons["stopGreen"].icon,
	  map: map
	});
	markers.push(marker);

	if (typeof trip !== "undefined") {
		busRoute = new google.maps.Polyline({
	      path: data.trip,
	      geodesic: true,
	      strokeColor: '#FF3333',
	      strokeOpacity: .4,
	      strokeWeight: 6
	    });

    	busRoute.setMap(map);

    	var lastStop;
		var thisStopSeq=0;
		// Add markers for subsequent stops
		for (i=0;i<data.next.length;i++) {
			if (lastStop == data.next[i].stop_id) continue;
			thisStopSeq++;
			stopLabel = data.next[i].stop_id;
			if (data.next[i].sc.length) {
				stopLabel = data.next[i].sc;
			}
			if (i+1 == data.next.length) {
				nextStopMarker = new google.maps.Marker({
					position: {lat: data.next[i].stop_lat, lng: data.next[i].stop_lon},
					label: ""+stopLabel,
					title: data.next[i].stop_name,
					icon: icons["stopRed"].icon,
					map:map
				});
				markers.push(nextStopMarker);				
			} else {
				nextStopMarker = new google.maps.Marker({
					position: {lat: data.next[i].stop_lat, lng: data.next[i].stop_lon},
					label: ""+thisStopSeq,
					title: data.next[i].stop_name,
					icon: icons["stopBlue"].icon,
					map:map
				});
				markers.push(nextStopMarker);
			}
			lastStop = data.next[i].stop_id;
		}

	}
});//.get().done
}//end if stop
//else we show the closest stops, or the stops for the selected route


//This stuff is specific to showing nearby stops
if (!stop) {
	getUserPosition().then((position) => {
		sortStopsByDist(position);

		var maxStops = <cfif isDefined('url.rid')>200<cfelse>50</cfif>;
	   	//Set the closest stops
	   	if (stopsByDist.length < maxStops) maxStops = stopsByDist.length;
	   	var closeStops = new Array();
	   	for (i=0;i<maxStops;i++) {
			closeStops[i] = stopsByDist[i];
		}

		//if we're looking at a route's stops, center the map on the closest stop.
		// But what if we're not using location?
		if ($('#rid').length && $('#rid').val().length) {
			map.setCenter({lat: closeStops[0].lat, lng: closeStops[0].lon});
			// Here I could draw the route on the map the way I do with LRT routes
			$.get("routeShape.cfm", {rid:$('#rid').val()}).done(function(data){
				busRoute = new google.maps.Polyline({
				path: data.shape,
				geodesic: true,
				strokeColor: '#FF3333',
				strokeOpacity: .4,
				strokeWeight: 6
	    		});
				busRoute.setMap(map);
			});
		} else {
			map.setCenter({lat: position.coords.latitude, lng: position.coords.longitude});
		}
		map.setZoom(17);



		// Loop through the stops array and add all the markers.
		// I don't know why, but using a for loop doesn't seem to work
		closeStops.forEach(function(stop){
			// console.log(stop);
			if (typeof stop === "undefined" || typeof stop.lat === "undefined" || typeof stop.lon === "undefined" || typeof stop.id === "undefined") {
				//Bad stop? Handle error here if necessary				
			} else {
			    var marker = new google.maps.Marker({
				    position: {lat:stop.lat, lng:stop.lon},
				    label: ""+stop.id,
					//title: data.stop.stop_name,
					icon: icons["stopGreen"].icon
			    });

			    marker.addListener('click', function() {
		          <cfif isDefined('url.rid')>routeFromSelectize<cfelse>selectize</cfif>.setValue(marker.getLabel());
		          closeMap();

		        });
			    markers.push(marker);
			}
		});

		// This seems redundant. They are already on the map
	    // for (var i = 0; i < markers.length; i++) {
	    //   markers[i].setMap(map);
	    // }
markerCluster = new MarkerClusterer(map, markers, {imagePath:iconBase+"m",gridSize:30,maxZoom:16,minimumClusterSize:2});
	});
}//end if !stop


//Show the actual map
$('#mapModal, #closeMap').removeClass('fadeOut');
$('#mapModal').css('display', 'block').css('position', 'fixed');
$('#mapModal, #closeMap').addClass('fadeIn');
$('#closeMap').css('display', 'block').css('position', 'fixed');
// $('#mapNotice').hide();

if (needsRefresh) {
	//Stupid... seems like this won't work if I do it right away.
	//This is probably not the ideal way to do this...
	setTimeout(function(){
		google.maps.event.trigger(map, 'zoom_changed');
	},400);
}


history.pushState(null, null, document.URL);
window.addEventListener('popstate', backAction);


};//endinitmap

/**
* Triggers the clusterclick event and zoom's if the option is set.
*/
ClusterIcon.prototype.triggerClusterClick = function() {
var markerClusterer = this.cluster_.getMarkerClusterer();

// Trigger the clusterclick event.
google.maps.event.trigger(markerClusterer, 'clusterclick', this.cluster_);

if (markerClusterer.isZoomOnClick()) {
// Zoom into the cluster.
// this.map_.fitBounds(this.cluster_.getBounds());

// modified zoom in function
this.map_.setZoom(markerClusterer.getMaxZoom()+1);
this.map_.setCenter(this.cluster_.getCenter()); // zoom to the cluster center

 }
};



//Prevent user from going back while in the map - close map instead
function backAction(event) {
    closeMap();
    window.removeEventListener('popstate', backAction);
}

$('#closeMap a').click(function(){
	window.removeEventListener('popstate', backAction);
	closeMap();
	window.history.back();
});

function closeMap() {
	$('#mapModal, #closeMap').removeClass('fadeIn');
	$('#mapModal').addClass('fadeOut');
	setTimeout(function(){
		$('#mapModal').removeClass('fadeOut');
		$('#mapModal').hide();
	},300);
	$('#closeMap').hide();
	//Remove the GeoMarker - see if this clears up location bugs
	// GeoMarker.setMap(null);
	// geomarkerCreated = false;
	// $('#mapNotice').show();	
}

$('#mapNotice').on('click', function(){
	$('tr[data-tripid]:first').addClass('pulse');
	setTimeout(function(){
		$('tr[data-tripid]:first').removeClass('pulse');
	},400);
});

</script>







<!--- Only include Google Analytics for pages that exist. --->
<cfif NOT isDefined('error404')>

	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

	  ga('create', 'UA-20121585-1', 'auto', {'allowLinker': true});
	  ga('require', 'linker');
	  ga('linker:autoLink', ['epl.bibliocommons.com', 'www.epl.ca'] );
	  ga('send', 'pageview');

	</script>

</cfif>


<!--- Footer from Bibliocommons Site --->
<div class="bc_core_external">
    <div class="footer_wrapper">
        <div id="cms_external_footer">
            <link rel="stylesheet" href="https://www.epl.ca/wp-content/themes/epl/css/footer_all.css">
            <!--- Add my support for night mode --->

            <div id="bccms_footer" class="footer-wrapper">
                <div id="footer_container" style="padding:0px;box-shadow:none;">
    		<!---
                    <h2 class="a11y-visually-hidden">Footer Menu</h2>
                    <div class="footer_container_12">
                        <div class="footer_grid">
                            <div class="footer-menus clearfix">
                                <!--- Social sharing bar
                                <div class="social-links-wrapper">
                                    <ul>
                                        <li>
                                            <a href="https://www.facebook.com/EPLdotCA" class="facebook_link">
                                            <img src="https://d34rompce3lx70.cloudfront.net/wp-content/themes/bibliocommons/images/facebook-icon.png" alt="Edmonton Public Library on Facebook"></a>
                                        </li>
                                        <li>
                                            <a href="https://twitter.com/EPLdotCA" class="twitter_link">
                                            <img src="https://d34rompce3lx70.cloudfront.net/wp-content/themes/bibliocommons/images/twitter-icon.png" alt="Edmonton Public Library on Twitter"></a>
                                        </li>
                                        <li>
                                            <a href="https://www.youtube.com/user/edmontonpl" class="youtube_link">
                                            <img src="https://d34rompce3lx70.cloudfront.net/wp-content/themes/bibliocommons/images/youtube-icon.png" alt="Edmonton Public Library on Youtube"></a>
                                        </li>
                                        <li>
                                            <a href="https://www.pinterest.com/EPLdotCA/" class="pinterest_link">
                                            <img src="https://d34rompce3lx70.cloudfront.net/wp-content/themes/bibliocommons/images/pinterest-icon.png" alt="Edmonton Public Library on Pinterest"></a>
                                        </li>
                                        <li>
                                            <a href="https://secure.campaigner.com/CSB/Public/Form.aspx?fid=1397500" class="newsletter_link">
                                            <img src="https://d34rompce3lx70.cloudfront.net/wp-content/themes/bibliocommons/images/newsletter-icon.png" alt="Edmonton Public Library Newsletter"></a>
                                        </li>
                                    </ul>
                                </div>--->
                                <div class="footer-all-menu-columns">
                                	<!--- Lots and lots of links --->
                                    <div class="footer-1-container footer-menu-column">
                                        <h3 class="bccms-footer-heading">About</h3>
                                        <div class="menu-about-container">
                                            <ul id="menu-about" class="menu">
                                                <li id="menu-item-9096" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-9096"><a href="https://www.epl.ca/executive-team/">Leadership</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-3404" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-3404"><a href="https://www.epl.ca/executive-team/">Executive Team</a></li>
                                                        <li id="menu-item-576" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-576"><a href="https://www.epl.ca/trustees/">Meet the EPL Board</a>
                                                            <ul class="sub-menu">
                                                                <li id="menu-item-6888" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-6888"><a href="https://www.epl.ca/board-meetings/">Board Meetings</a></li>
                                                                <li id="menu-item-626" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-626"><a href="https://www.epl.ca/committees/">Our Committees</a></li>
                                                                <li id="menu-item-6922" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-6922"><a href="https://www.epl.ca/board-responsibilities/">Board Responsibilities</a></li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li id="menu-item-566" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-566"><a href="https://www.epl.ca/vision-mission-values/">Vision, Mission &amp; Values</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-1434" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1434"><a href="https://www.epl.ca/community-led/">Community-Led Service Philosophy</a></li>
                                                        <li id="menu-item-7642" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-7642"><a href="https://www.epl.ca/ourbrand/">Our EPL Brand</a></li>
                                                        <li id="menu-item-7884" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-7884"><a href="https://www.epl.ca/awards/">Awards</a></li>
                                                    </ul>
                                                </li>
                                                <li id="menu-item-4084" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-4084"><a href="https://www.epl.ca/news">News from EPL</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-9168" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-9168"><a href="https://www.epl.ca/enewsletter/">EPL eNewsletter</a></li>
                                                    </ul>
                                                </li>
                                                <li id="menu-item-6908" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-6908"><a href="https://www.epl.ca/browse_program/imaginemilner/">Imagine Milner</a></li>
                                                <li id="menu-item-14126" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-14126"><a href="https://www.epl.ca/browse_program/buildingprojects/">Building Projects</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-1346" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1346"><a href="https://www.epl.ca/sustainability/">Sustainability at EPL</a></li>
                                                    </ul>
                                                </li>
                                                <li id="menu-item-1880" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1880"><a href="https://www.epl.ca/policies/">Policies</a></li>
                                                <li id="menu-item-2572" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-2572"><a href="https://www.epl.ca/publications/">Reports and Publications</a></li>
                                                <li id="menu-item-15980" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-15980"><a href="https://www.epl.ca/procurement/">Doing Business with EPL</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="footer-2-container footer-menu-column">
                                        <h3 class="bccms-footer-heading">Membership</h3>
                                        <div class="menu-membership-container">
                                            <ul id="menu-membership" class="menu">
                                                <li id="menu-item-2652" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-2652"><a href="https://www2.epl.ca/signup">Sign up online</a></li>
                                                <li id="menu-item-8964" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-8964"><a href="https://www.epl.ca/membership-benefits/">Membership Benefits</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-8310" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-8310"><a href="https://www.epl.ca/epl-mobile/">EPL Mobile</a></li>
                                                        <li id="menu-item-8300" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-8300"><a href="https://www.epl.ca/libraryelf/">Library Elf</a></li>
                                                        <li id="menu-item-8434" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-has-children menu-item-8434"><a href="https://www.epl.ca/library-card-options/">Library Card Options</a>
                                                            <ul class="sub-menu">
                                                                <li id="menu-item-25304" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-25304"><a href="https://www.epl.ca/indigenous-card/">Indigenous</a></li>
                                                            </ul>
                                                        </li>
                                                    </ul>
                                                </li>
                                                <li id="menu-item-11854" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-11854"><a href="https://www.epl.ca/myeplaccount/">My EPL Account</a></li>
                                                <li id="menu-item-8966" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-8966"><a href="https://www.epl.ca/borrowing-guide/">Borrowing Basics</a>
                                                    <ul class="sub-menu">
                                                        <li id="menu-item-6578" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-6578"><a href="https://www.epl.ca/holds-and-late-fees/">Holds and Late Fees</a></li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="footer-3-container footer-menu-column">
                                        <h3 class="bccms-footer-heading">Support EPL</h3>
                                        <div class="menu-support-epl-container">
                                            <ul id="menu-support-epl" class="menu">
                                                <li id="menu-item-21886" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-21886"><a href="https://www.epl.ca/give/">Give</a></li>
                                                <li id="menu-item-1092" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1092"><a href="https://www.epl.ca/anthology/">Anthology</a></li>
                                                <li id="menu-item-13166" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-13166"><a href="https://www.epl.ca/volunteer/">Volunteer</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                    <div class="footer-menu-column footer-multi-row-column">
                                        <div class="footer-4-container footer-menu-row">
                                            <h3 class="bccms-footer-heading">Careers</h3>
                                            <div class="menu-careers-container">
                                                <ul id="menu-careers" class="menu">
                                                    <li id="menu-item-1306" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1306"><a href="https://www.epl.ca/careers-at-epl/">Careers at EPL</a></li>
                                                    <li id="menu-item-1304" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1304"><a href="https://www.epl.ca/current-postings/">Current Postings</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="footer-5-container footer-menu-row"></div>
                                    </div>
                                	<!--- end Lots and lots of links --->
                                    <div class="footer-menu-column">
                                        <div class="footer-contact-info  large-footer">
                                            <h3 class="bccms-footer-heading"><a href="https://www2.epl.ca/ContactEPL/" class="contact_us_url">Contact Us</a></h3>
                                            <ul>
                                                <li>Edmonton Public Library</li>
                                                <li>MNP Tower, 7th Floor, 10235 101 Street NW<span class="clear"></span> Edmonton, AB<span class="clear"></span> T5J 3G1<span class="clear"></span> </li>
                                                <li>
                                                    780-496-7000 </li>
                                            </ul>
                                        </div>
                                        <div class="clear"></div>
                                        <a href="https://www2.epl.ca/ContactEPL/" class="feedback-btn"><span>Contact EPL</span></a>
                                    </div>
                                </div><!---footer-all-menu-columns--->
                            </div>
                        </div>
                    </div>
                    <div class="footer-contact-info small-footer">
                        <div class="small-footer-content">
                            <!-- Footer to be shown on small screen sizes. -->
                            <h3 class="bccms-footer-heading"><a href="https://www2.epl.ca/ContactEPL/" class="contact_us_url">Contact Us</a></h3>
                            <ul>
                                <li>Edmonton Public Library</li>
                                <li>MNP Tower, 7th Floor, 10235 101 Street NW<span class="clear"></span> Edmonton, AB<span class="clear"></span> T5J 3G1<span class="clear"></span></li>
                                <li>
                                    780-496-7000 </li>
                            </ul>
                        </div>
                    </div>
           	--->
                </div><!-- footer_container -->
                <div class="clear"></div>
                <div class="footer-bottom clearfix">
                    <a href="https://www2.epl.ca/ContactEPL/" class="feedback-btn-small">Contact EPL</a>
                    <div class="clear"></div>
                    <div class="support-cpl">
                        <a href="https://www.canadahelps.org/dn/2773" class="support-cpl-link">
                                            <img alt="Donate Now" src="https://epl.bibliocms.com/wp-content/uploads/sites/18/2015/11/DonateNowButton_130x60px_Nov2015.png?v=1501597825150159683415015965403">
                                            <span class="a11y-visually-hidden">, opens a new window</span>
                </a>
                    </div>
                    <div class="footer-col-2">
                        <!---<div id="green-links-wrapper">
                            <a href="http://www.edmonton.ca/" class="footer-green-link">City of Edmonton Website</a>
                        </div>--->
                        <div class="clear"></div>
                        <div class="footer-bottom-copyright">
                            <a href="https://epl.bibliocommons.com/info/terms" target="_blank">
                    Terms of Use<span class="a11y-visually-hidden">, opens a new window</span><!--
                --></a>
                            <a href="https://epl.bibliocommons.com/info/privacy" target="_blank">
                    Privacy Statement<span class="a11y-visually-hidden">, opens a new window</span><!--
                --></a>
                            <span class="copyright-statement">
                    &copy; <cfoutput>#Year(now())# Edmonton Public Library                </span>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>


</body>
</html>