<!--- <cfsetting enablecfoutputonly="true" /> --->
<cfsetting requesttimeout="60" />
<cfsetting showdebugoutput="false" />

<!--- Log update --->
<cfquery name="LogUpdate" dbtype="ODBC" datasource="ReadWriteSource">
	INSERT INTO vsd.ETSRT_update_log (StartTime) VALUES(GETDATE())
	SELECT scope_identity() AS UPID;
</cfquery>
<cfset upid=LogUpdate.UPID />

<html>
<body>



<!--- TripUpdate.cfm allows a page to request a trip update for a list of tripIDs and a stop.
This is queried from ETSRealTime.exe, which is a Windows command line app made with .NET in C# --->
<cfobject name="gtfsRealtime" component="gtfsRealtime">
<!--- <cfdump var="#server.gtfsrealtime#"> --->

<!--- <cfif isDefined('form.tid') AND isDefined('form.stopID')> --->

	<!--- Get the filename for the TripUpdates.PB and invoke refresh via caching system --->
	<!--- <cfset gtfsRTResp=gtfsRealtime.getPB() /> --->

	<cfset TripUpdateURL = "http://gtfs.edmonton.ca/TMGTFSRealTimeWebService/TripUpdate/TripUpdates.pb" />

	<!--- Remove for production --->
	<!--- <cfoutput>Updating TripUpdates.pb...</cfoutput> --->
	<cfset PBFile = "D:\inetpub\CustomTags\TripUpdates.pb" />
	<cfx_http5 url="#TripUpdateURL#" ssl="5" async="n" out="#PBFile#" file="y">

	<CFIF STATUS EQ "ER">
	   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
	   <p><b>Failure to download GTFS Realtime Data</b></p>
	   <!--- Could do some fancier error handling here  --->
	   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfquery name="LogUpdate" dbtype="ODBC" datasource="ReadWriteSource">
			UPDATE vsd.ETSRT_update_log SET Comment='Failure to download: #MSG#', Success=0 WHERE upid=#upid#
		</cfquery>	   
	   <CFABORT>
	</CFIF>


	<cfset args = "-f #PBFile#" />

	<cfexecute name="D:\inetpub\CustomTags\lib\ETSRealTime\ETSRealTime.exe"
		arguments = "#args#"
		variable="json"
		errorvariable="error"
		timeout="20" />

	<cfif len(error)>
		<cfquery name="LogUpdate" dbtype="ODBC" datasource="ReadWriteSource">
			UPDATE vsd.ETSRT_update_log SET Comment='#error#', Success=0  WHERE upid=#upid#
		</cfquery>
		ERROR: <cfdump var="#error#">
	</cfif>

	<cfset RealTimeData = DeserializeJSON(json) />

<!--- Structure of RealTimeData
message
	entity[1-700]
		id
		trip_update
			route_id
			schedule_relationship
			start_date
			start_time
			trip_id
			stop_time_update[1-30]
				departure
					delay
					departure.uncertainty
					time
				schedule_relationship
				stop_id
				stop_sequence				
--->

	<!--- INSERT everything into one bigass query --->
	<cfquery name="InsertTRIPS" dbtype="ODBC" datasource="ReadWriteSource">
		DELETE FROM ETSRT1_stop_time_update;
		<!--- Don't really need the trip_update table
		DELETE FROM ETSRT1_trip_update;
		<cfloop array="#RealTimeData.message.entity#" item="e" index="i">
		<cfif i MOD 700 EQ 1>INSERT INTO vsd.ETSRT1_trip_update (id, route_id, schedule_relationship, start_datetime) VALUES</cfif>
		<cfif i MOD 700 NEQ 1>,</cfif>('#e.id#', '#e.trip_update.route_id#', '#e.trip_update.schedule_relationship#', '#e.trip_update.start_date# #e.trip_update.start_time#')
		</cfloop>
		--->
		<cfloop array="#RealTimeData.message.entity#" item="e" index="oi">
			<cfloop array="#e.trip_update.stop_time_update#" item="stu" index="i">
				<cfif i EQ 1>
					INSERT INTO vsd.ETSRT1_stop_time_update (trip_id, delay, departure_uncertainty, time, schedule_relationship, stop_id, stop_sequence) VALUES
				</cfif>
				<cfif i NEQ 1>,</cfif>('#e.trip_update.trip_id#',
					<cfif isDefined('stu.departure')>
						#stu.departure.delay#, #stu.departure["departure.uncertainty"]#, #stu.departure.time#
					<cfelse>
						NULL, NULL, NULL
					</cfif>,
					'#stu.schedule_relationship#', '#stu.stop_id#', #stu.stop_sequence#)
			</cfloop>
		</cfloop>

	</cfquery>

	<!--- <cfdump var="#RealTimeData#"> --->

	<!--- <cfoutput>#json#</cfoutput> --->

<cfset intRunTimeInSeconds = DateDiff(
    "s",
    GetPageContext().GetFusionContext().GetStartTime(),
    Now()
    ) />
<p>Realtime data has been updated in <cfoutput>#intRunTimeInSeconds# second(s)</cfoutput>.</p>
<cfquery name="LogUpdate" dbtype="ODBC" datasource="ReadWriteSource">
	UPDATE vsd.ETSRT_update_log SET EndTime=GETDATE(), Success=1 WHERE upid=#upid#
</cfquery>
</body>
</html>