<cfsetting requesttimeout="600" /><!--- 600 seconds = ten minutes--->
<!--- First, I'm going to see if I can get all this GTFS data to download --->


<!--- Link Provided by City of Edmonton--->
<!--- <cfset gtfsUrl = "https://data.edmonton.ca/download/gzhc-5ss6/application%2Fzip" /> --->
<!--- New link is on Google Drive --->
<!--- <cfset gtfsUrl = "https://drive.google.com/uc?id=1KcQixzJcucT5PDOwFJBXhDg-Alh0SVP6&export=download" /> --->

<!--- 2019-08-26: brian.korthuis@edmonton.ca says GTFS files have moved here --->
<cfset gtfsUrl = "https://gtfs.edmonton.ca/TMGTFSRealTimeWebService/GTFS/GTFS.zip" />
<!--- Actual filename --->
<!--- <cfset gtfsActual = "https://data.edmonton.ca/api/views/gzhc-5ss6/files/d646faa2-b520-418a-95e8-8ba53a989daf?filename=gtfs.zip" /> --->
<!--- 💩 <cfhttp method="get" url="#gtfsUrl#" path="D:\inetpub\temp\gtfs" file="gtfs.zip" timeout="1000" getasbinary="auto"> --->

<!--- Download COE zip file --->


<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\Edmonton\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from City of Edmonton failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <cfabort />
</CFIF>


<!--- Download Strathcona County zip file --->
<cfset gtfsUrl = "http://webpub2.strathcona.ab.ca/GTFS/Google_Transit.zip" />
<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\Strathcona\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from Strathcona County failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <cfabort />
</CFIF>

<!--- Download St. Albert zip file --->
<cfset gtfsUrl = "https://stalbert.ca/site/assets/files/3840/google_transit.zip" />
<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\StAlbert\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from St. Albert failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <cfabort />
</CFIF>

<!--- Unzip all gtfs packages --->
<cftry>
	<!--- Extract zip into gtfs directory --->
	<cfzip action="unzip" file="D:\inetpub\temp\gtfs\Edmonton\gtfs.zip" overwrite="true" destination="D:\inetpub\temp\gtfs\Edmonton\" />

	<!--- Delete the original zip as we do not need it anymore --->
	<cffile action="delete" file="D:\inetpub\temp\gtfs\Edmonton\gtfs.zip" />

	<!--- Extract zip into gtfs directory --->
	<cfzip action="unzip" file="D:\inetpub\temp\gtfs\Strathcona\gtfs.zip" overwrite="true" destination="D:\inetpub\temp\gtfs\Strathcona\" />

	<!--- Delete the original zip as we do not need it anymore --->
	<cffile action="delete" file="D:\inetpub\temp\gtfs\Strathcona\gtfs.zip" />

	<!--- Extract zip into gtfs directory --->
	<cfzip action="unzip" file="D:\inetpub\temp\gtfs\StAlbert\gtfs.zip" overwrite="true" destination="D:\inetpub\temp\gtfs\StAlbert\" />

	<!--- Delete the original zip as we do not need it anymore --->
	<cffile action="delete" file="D:\inetpub\temp\gtfs\StAlbert\gtfs.zip" />

	<cfcatch type="any">

		<h1>ERROR: Update Failed</h1>		
				<cfdump var="#cfcatch#">
				<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Updating ETS Database" from="noreply@epl.ca">
An attempt to update GTFS transit data failed.

There was an issue unzipping one of the gtfs packages from an agency. This could be caused because a link has moved, and an error page was downloaded instead of an actual zip file.

<cfoutput>
#cfcatch.message#
#cfcatch.detail#
</cfoutput>
		</cfmail>
		<cfabort />

	</cfcatch>
</cftry>

<!--- List of files. First in reverse order for deleting without violating constraints --->

<!--- Remove annoying headers from GTFS files so we can import them easily --->
<!--- They use the command findstr /V /R "^[a-z].*[a-z]$" stop_times.txt > stop_times_noheader.txt --->
<!--- <cfexecute name='D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.bat' timeout="10" /> --->
<!--- This new powershell script should work on other cities, but it's pretty slow --->
<cfexecute name="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" arguments="D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.ps1" timeout="20" />



<cfset gtfsFilesRev="stop_times,transfers,trips,stops,shapes,routes,calendar_dates,calendar,agency" />
<cfset gtfsFiles="agency,calendar,calendar_dates,routes,shapes,stops,trips,transfers,stop_times" />

<!--- <cfset gtfsFilesRev="agency" />
<cfset gtfsFiles="agency" /> --->

<!--- Choose the inactive database to be updated. --->
<cfquery name="updatedb" dbtype="ODBC" datasource="SecureSource">
	SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 0
</cfquery>

<cfset dbprefix = updatedb.prefix />

<!--- Edmonton --->
<cftry>
	<cfquery name="BulkInsert" dbtype="ODBC" datasource="ReadWriteSource">

	<cfloop list="#gtfsFilesRev#" index="fileBase">
	DELETE FROM vsd.#dbprefix#_#fileBase#

	</cfloop>
	<cfloop list="#gtfsFiles#" index="fileBase">
		<cfif FileExists('\\epl-cf\gtfs$\Edmonton\#fileBase#_noheader.txt')>
			BULK INSERT vsd.#dbprefix#_#fileBase# FROM '\\epl-cf\gtfs$\Edmonton\#fileBase#_noheader.txt'
			WITH (
			FIRSTROW=1,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FORMATFILE = '\\epl-cf\gtfs$\Edmonton\#fileBase#.fmt'
			);
		</cfif>
	</cfloop>
	</cfquery>

	<cfcatch type="any">
<h1>ERROR: Update Failed</h1>		
		<cfdump var="#cfcatch#">
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Updating ETS Database" from="noreply@epl.ca">
An attempt to update GTFS transit data from City of Edmonton failed.
Please check that the vsd.ETS databases are functional and use
https://apps.epl.ca/web/gtfsDebug.cfm to test the import process.

Typically this type of error occurs because the data provided by ETS has been changed in format such that it is no longer compatible with the existing database structure. Fixing his requires rebuilding the database with new field types.

The following messages have been returned from the server:

<cfoutput>#cfcatch.message#
#cfcatch.detail#</cfoutput>
</cfmail>
	<cfabort />
	</cfcatch>
</cftry>

<!--- St. Albert --->
<cftry>
	<cfquery name="BulkInsert" dbtype="ODBC" datasource="ReadWriteSource">

	<cfloop list="#gtfsFilesRev#" index="fileBase">
	DELETE FROM vsd.#dbprefix#_#fileBase#_StAlbert
	</cfloop>
	<cfloop list="#gtfsFiles#" index="fileBase">
		<cfif FileExists('\\epl-cf\gtfs$\StAlbert\#fileBase#_noheader.txt')>
			BULK INSERT vsd.#dbprefix#_#fileBase#_StAlbert FROM '\\epl-cf\gtfs$\StAlbert\#fileBase#_noheader.txt'
			WITH (
			FIRSTROW=1,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FORMATFILE = '\\epl-cf\gtfs$\StAlbert\#fileBase#.fmt'
			);
		</cfif>	
	</cfloop>
	</cfquery>

	<cfcatch type="any">
<h1>ERROR: Update Failed</h1>		
		<cfdump var="#cfcatch#">
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Updating ETS Database" from="noreply@epl.ca">
An attempt to update GTFS transit data from St. Albert failed.
Please check that the vsd.ETS databases are functional and use
https://apps.epl.ca/web/gtfsDebug.cfm to test the import process.

Typically this type of error occurs because the data provided by StAT has been changed in format such that it is no longer compatible with the existing database structure. Fixing his requires rebuilding the database with new field types.

The following messages have been returned from the server:

<cfoutput>#cfcatch.message#
#cfcatch.detail#</cfoutput>
</cfmail>
	<cfabort />
	</cfcatch>
</cftry>


<!--- Strathcona County --->
<cftry>
	<cfquery name="BulkInsert" dbtype="ODBC" datasource="ReadWriteSource">

	<cfloop list="#gtfsFilesRev#" index="fileBase">
	DELETE FROM vsd.#dbprefix#_#fileBase#_Strathcona
	</cfloop>
	<cfloop list="#gtfsFiles#" index="fileBase">
		<cfif FileExists('\\epl-cf\gtfs$\Strathcona\#fileBase#_noheader.txt')>
			BULK INSERT vsd.#dbprefix#_#fileBase#_Strathcona FROM '\\epl-cf\gtfs$\Strathcona\#fileBase#_noheader.txt'
			WITH (
			FIRSTROW=1,
			FIELDTERMINATOR = ',',
			ROWTERMINATOR = '\n',
			FORMATFILE = '\\epl-cf\gtfs$\Strathcona\#fileBase#.fmt'
			);
		</cfif>
	</cfloop>
	</cfquery>

	<cfcatch type="any">
<h1>ERROR: Update Failed</h1>		
		<cfdump var="#cfcatch#">
		<cfmail to="jlien@epl.ca, weblogs@epl.ca" subject="Error Updating ETS Database" from="noreply@epl.ca">
An attempt to update GTFS transit data from Strathcona County failed.
Please check that the vsd.ETS databases are functional and use
https://apps.epl.ca/web/gtfsDebug.cfm to test the import process.

Typically this type of error occurs because the data provided by Strathcona County Transit has been changed in format such that it is no longer compatible with the existing database structure. Fixing his requires rebuilding the database with new field types.

The following messages have been returned from the server:

<cfoutput>#cfcatch.message#
#cfcatch.detail#</cfoutput>
</cfmail>
	<cfabort />
	</cfcatch>
</cftry>


<!--- There are a few stray double-quotes that I want to get rid of --->
<cfquery name="CleanUp" dbtype="ODBC" datasource="ReadWriteSource">
	<!--- only LRT route short names have double quotes ("Capital", "Metro"). Remove them. --->
	UPDATE vsd.#dbprefix#_routes SET route_short_name=REPLACE(route_short_name, '"', '')
	--run this after the update process runs to set a bit indicating which stops are LRT stations
	UPDATE vsd.#dbprefix#_stops SET is_lrt=1
	WHERE stop_id IN (
		SELECT s.stop_id
		FROM vsd.#dbprefix#_stop_times stime
		JOIN vsd.#dbprefix#_trips t ON t.trip_id=stime.trip_id
		JOIN vsd.#dbprefix#_calendar_dates c ON c.service_id=t.service_id
		JOIN vsd.#dbprefix#_stops s ON stime.stop_id=s.stop_id
		JOIN vsd.#dbprefix#_routes r ON r.route_id=t.route_id
		WHERE r.route_type=0
		GROUP BY s.stop_id
	)	
</cfquery>

<!--- Clean up Strathcona Stops and flag stops that are exclusively Strathcona and not ETS --->
<cfquery name="CleanOutsideStops" dbtype="ODBC" datasource="ReadWriteSource">
--This will ensure that the stop_name of stops with same ID and similar coordinates (within about ten metres) match exactly
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = (SELECT stop_name FROM vsd.#dbprefix#_stops WHERE stop_id=vsd.#dbprefix#_stops_Strathcona.stop_id)
WHERE vsd.#dbprefix#_stops_Strathcona.stop_id IN (SELECT stop_id FROM vsd.#dbprefix#_stops)
AND vsd.#dbprefix#_stops_Strathcona.stop_lat-.0001 < (SELECT s.stop_lat FROM vsd.#dbprefix#_stops s WHERE stop_id=vsd.#dbprefix#_stops_Strathcona.stop_id)
AND vsd.#dbprefix#_stops_Strathcona.stop_lat+.0001 > (SELECT s.stop_lat FROM vsd.#dbprefix#_stops s WHERE stop_id=vsd.#dbprefix#_stops_Strathcona.stop_id)
AND vsd.#dbprefix#_stops_Strathcona.stop_lon-.0001 < (SELECT s.stop_lon FROM vsd.#dbprefix#_stops s WHERE stop_id=vsd.#dbprefix#_stops_Strathcona.stop_id)
AND vsd.#dbprefix#_stops_Strathcona.stop_lon+.0001 > (SELECT s.stop_lon FROM vsd.#dbprefix#_stops s WHERE stop_id=vsd.#dbprefix#_stops_Strathcona.stop_id)

--This misses about 12. I need to refine this to match stops with the same ID but are within ~3 10,000ths of a degree on each axis
--Should have 37 matches.

--Clean up strathcona street and avenue abbreviations
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St', ' Street') WHERE stop_name like '% St'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St ', ' Street ') WHERE stop_name like '% St %'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St. ', ' Street ') WHERE stop_name like '% St. %'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' St.', ' Street') WHERE stop_name like '% St.'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Av', ' Avenue') WHERE stop_name like '% Av'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Av ', ' Avenue ') WHERE stop_name like '% Av %'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave', ' Avenue') WHERE stop_name like '% Ave'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave ', ' Avenue ') WHERE stop_name like '% Ave %'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave. ', ' Avenue ') WHERE stop_name like '% Ave. %'
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' Ave.', ' Avenue') WHERE stop_name like '% Ave.'
-- Replace and with ampersand to be consistent with 99.5% of other records
UPDATE vsd.#dbprefix#_stops_Strathcona SET stop_name = REPLACE(stop_name, ' and ', ' & ') WHERE stop_name like '% and %'

UPDATE vsd.#dbprefix#_stops_Strathcona SET exclusive=1

--Set the exclusive flag to 0 for strathcona stops that are actually ETS stops
UPDATE vsd.#dbprefix#_stops_Strathcona SET exclusive=0
WHERE stop_id IN (SELECT stop_id FROM vsd.#dbprefix#_stops)
AND vsd.#dbprefix#_stops_Strathcona.stop_name=(SELECT stop_name FROM vsd.#dbprefix#_stops WHERE stop_id = vsd.#dbprefix#_stops_Strathcona.stop_id)

--Looks like St. Albert is a lot better about using their own stop IDs, so this is way easier...
UPDATE vsd.#dbprefix#_stops_StAlbert SET exclusive=1
UPDATE vsd.#dbprefix#_stops_StAlbert SET exclusive=0
WHERE stop_id IN (SELECT stop_id FROM vsd.#dbprefix#_stops)
AND vsd.#dbprefix#_stops_StAlbert.stop_name=(SELECT stop_name FROM vsd.#dbprefix#_stops WHERE stop_id = vsd.#dbprefix#_stops_StAlbert.stop_id)

--For now, we consider all ETS stops exclusive - we want to show them all in the view of all stops
UPDATE vsd.#dbprefix#_stops SET exclusive=1
</cfquery>



<cfquery name="UpdateRouteStops" dbtype="ODBC" datasource="ReadWriteSource">
	DELETE FROM vsd.#dbprefix#_stop_routes_all_agencies

	INSERT INTO vsd.#dbprefix#_stop_routes_all_agencies (stop_id, route_id, agency_id)
	SELECT st.stop_id, t.route_id, t.agency_id FROM vsd.#dbprefix#_routes_all_agencies r
	JOIN vsd.#dbprefix#_trips_all_agencies t ON r.route_id=t.route_id
	JOIN vsd.#dbprefix#_stop_times_all_agencies st ON st.trip_id=t.trip_id
	GROUP BY st.stop_id, t.route_id, t.agency_id
</cfquery>



<!--- 
	Loops through every entry of a "calendar" table, and inserts each date from the range into the calendar_dates_complete
	table for StAlbert and Strathcona, accounting for any exceptions in the calendar_dates table.
 --->
<cfquery name="calendarStA" dbtype="ODBC" datasource="SecureSource">
	SELECT * FROM vsd.#dbprefix#_calendar_StAlbert
</cfquery>

<!--- Clean out previous entries in calendar_dates_complete --->
<cfquery name="DeleteCalendarDatesComplete" dbtype="ODBC" datasource="ReadWriteSource">
	DELETE FROM vsd.#dbprefix#_calendar_dates_complete_StAlbert
</cfquery>

<cfloop query="calendarStA">
	<!--- Now loop through the date range --->
	<cfset fromDate = start_date> 
	<cfset toDate = end_date> 
	<cfloop from="#start_date#" to="#end_date#" index="day" step="#CreateTimeSpan(1,0,0,0)#"> 
		<!--- <cfoutput>#dateformat(day, "mm/dd/yyyy")# - #LCase(DayOfWeekAsString(DayOfWeek(day)))#<br /></cfoutput> --->
		<!--- Now query for the service_ids for this date --->
		<cfquery name="DayServiceIds" dbtype="ODBC" datasource="SecureSource">
			SELECT ISNULL(cdserviceid, cserviceid) AS service_id FROM (
			SELECT c.service_id AS cserviceid, cd.service_id AS cdserviceid, exception_type FROM vsd.#dbprefix#_calendar_StAlbert c
			LEFT OUTER JOIN vsd.#dbprefix#_calendar_dates_StAlbert cd ON cd.date='#DateFormat(day, "YYYY-MM-DD")#'
			WHERE start_date <= '#DateFormat(day, "YYYY-MM-DD")#' AND end_date >= '#DateFormat(day, "YYYY-MM-DD")#' AND #LCase(DayOfWeekAsString(DayOfWeek(day)))#=1
			) AS subq WHERE exception_type = 1 OR exception_type IS NULL
		</cfquery>
		<!--- Now insert the service Ids into the calendar_dates_complete table --->
		<cfif DayServiceIds.RecordCount GT 0 AND isDefined('DayServiceIds.service_id') AND len(DayServiceIDs.service_id)>
			<cfquery name="InsertComplete" dbtype="ODBC" datasource="ReadWriteSource">
				<cfloop query="DayServiceIds">
					<!--- Check that there is no unique key violation. This must be horribly inefficient --->
					BEGIN TRY
					INSERT INTO vsd.#dbprefix#_calendar_dates_complete_StAlbert (service_id, date, exception_type)
					VALUES('#DayServiceIds.service_id#', '#DateFormat(day, "YYYYMMDD")#', 1)
					END TRY BEGIN CATCH END CATCH
				</cfloop>
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>


<!--- Now do the Strathcona Calendar --->

<cfquery name="calendarStr" dbtype="ODBC" datasource="SecureSource">
	SELECT * FROM vsd.#dbprefix#_calendar_Strathcona
</cfquery>

<!--- Clean out previous entries in calendar_dates_complete --->
<cfquery name="DeleteCalendarDatesComplete" dbtype="ODBC" datasource="ReadWriteSource">
	DELETE FROM vsd.#dbprefix#_calendar_dates_complete_Strathcona
</cfquery>

<cfloop query="calendarStr">
	<!--- Now loop through the date range --->
	<cfset fromDate = start_date> 
	<cfset toDate = end_date> 
	<cfloop from="#start_date#" to="#end_date#" index="day" step="#CreateTimeSpan(1,0,0,0)#"> 
		<!--- <cfoutput>#dateformat(day, "mm/dd/yyyy")# - #LCase(DayOfWeekAsString(DayOfWeek(day)))#<br /></cfoutput> --->
		<!--- Now query for the service_ids for this date --->
		<cfquery name="DayServiceIds" dbtype="ODBC" datasource="SecureSource">
			SELECT ISNULL(cdserviceid, cserviceid) AS service_id FROM (
			SELECT c.service_id AS cserviceid, cd.service_id AS cdserviceid, exception_type FROM vsd.#dbprefix#_calendar_Strathcona c
			LEFT OUTER JOIN vsd.#dbprefix#_calendar_dates_Strathcona cd ON cd.date='#DateFormat(day, "YYYY-MM-DD")#'
			WHERE start_date <= '#DateFormat(day, "YYYY-MM-DD")#' AND end_date >= '#DateFormat(day, "YYYY-MM-DD")#' AND #LCase(DayOfWeekAsString(DayOfWeek(day)))#=1
			) AS subq WHERE exception_type = 1 OR exception_type IS NULL
		</cfquery>
		<!--- Now insert the service Ids into the calendar_dates_complete table --->
		<cfif DayServiceIds.RecordCount GT 0 AND isDefined('DayServiceIds.service_id') AND len(DayServiceIDs.service_id)>
			<cfquery name="InsertComplete" dbtype="ODBC" datasource="ReadWriteSource">
				<cfloop query="DayServiceIds">
					<!--- Check that there is no unique key violation. This must be horribly inefficient --->
					BEGIN TRY
					INSERT INTO vsd.#dbprefix#_calendar_dates_complete_Strathcona (service_id, date, exception_type)
					VALUES('#DayServiceIds.service_id#', '#DateFormat(day, "YYYYMMDD")#', 1)
					END TRY BEGIN CATCH END CATCH
				</cfloop>
			</cfquery>
		</cfif>
	</cfloop>
</cfloop>




<!--- If everything seems to be working, now let's switch the active database to the newly updated one. --->

<cfquery name="SwapDBs" dbtype="ODBC" datasource="ReadWriteSource">
	UPDATE vsd.ETS_activeDB SET active=1, updated=GETDATE() WHERE dbid=#updatedb.dbid#
	UPDATE vsd.ETS_activeDB SET active=0 WHERE dbid!=#updatedb.dbid#
</cfquery>


<p>GTFS Data has been updated successfully in <cfoutput>#dbprefix#</cfoutput>.</p>