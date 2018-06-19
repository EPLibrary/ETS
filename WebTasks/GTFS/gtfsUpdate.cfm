<cfsetting requesttimeout="600" /><!--- 600 seconds = ten minutes--->
<!--- First, I'm going to see if I can get all this GTFS data to download --->


<!--- Link Provided by City of Edmonton--->
<cfset gtfsUrl = "https://data.edmonton.ca/download/gzhc-5ss6/application%2Fzip" />

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
		<cfmail to="jlien@epl.ca, vflores@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from City of Edmonton failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <CFABORT>
</CFIF>


<!--- Download Strathcona County zip file --->
<cfset gtfsUrl = "http://webpub2.strathcona.ab.ca/GTFS/Google_Transit.zip" />
<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\Strathcona\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfmail to="jlien@epl.ca, vflores@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from Strathcona County failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <CFABORT>
</CFIF>

<!--- Download St. Albert zip file --->
<cfset gtfsUrl = "https://stalbert.ca/uploads/files-zip/google_transit.zip" />
<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\StAlbert\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
		<cfmail to="jlien@epl.ca, vflores@epl.ca" subject="Error Downloading GTFS data for ETS Database" from="noreply@epl.ca">
An attempt to download GTFS transit data from St. Albert failed.
Please check that the relevant URL is functional and investigate this problem.<br />
<cfoutput>#gtfsUrl#</cfoutput>

The following message was returned from the server:

<cfoutput>#MSG#</cfoutput>
</cfmail>   
   <CFABORT>
</CFIF>


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

<!--- List of files. First in reverse order for deleting without violating constraints --->

<!--- Remove annoying headers from GTFS files so we can import them easily --->
<!--- They use the command findstr /V /R "^[a-z].*[a-z]$" stop_times.txt > stop_times_noheader.txt --->
<!--- <cfexecute name='D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.bat' timeout="10" /> --->
<!--- This new powershell script should work on other cities, but it's pretty slow --->
<cfexecute name="C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" arguments="D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.ps1" timeout="20" />



<cfset gtfsFilesRev="stop_times,transfers,trips,stops,shapes,routes,calendar_dates,agency" />
<cfset gtfsFiles="agency,calendar_dates,routes,shapes,stops,trips,transfers,stop_times" />

<!--- <cfset gtfsFilesRev="agency" />
<cfset gtfsFiles="agency" /> --->

<cftry>
	<!--- Choose the inactive database to be updated. --->
	<cfquery name="updatedb" dbtype="ODBC" datasource="SecureSource">
		SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 0
	</cfquery>

	<cfset dbprefix = updatedb.prefix />


	<cfquery name="BulkInsert" dbtype="ODBC" datasource="ReadWriteSource">

	<cfloop list="#gtfsFilesRev#" index="fileBase">
	DELETE FROM vsd.#dbprefix#_#fileBase#
	DELETE FROM vsd.#dbprefix#_#fileBase#_StAlbert
	DELETE FROM vsd.#dbprefix#_#fileBase#_Strathcona
	</cfloop>
	<cfloop list="#gtfsFiles#" index="fileBase">
		BULK INSERT vsd.#dbprefix#_#fileBase# FROM '\\epl-cf\gtfs$\Edmonton\#fileBase#_noheader.txt'
		WITH (
		FIRSTROW=1,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FORMATFILE = '\\epl-cf\gtfs$\Edmonton\#fileBase#.fmt'
		);

	<cfif FileExists('\\epl-cf\gtfs$\StAlbert\#fileBase#_noheader.txt')>
		BULK INSERT vsd.#dbprefix#_#fileBase#_StAlbert FROM '\\epl-cf\gtfs$\StAlbert\#fileBase#_noheader.txt'
		WITH (
		FIRSTROW=1,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FORMATFILE = '\\epl-cf\gtfs$\StAlbert\#fileBase#.fmt'
		);
	</cfif>	
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
		<cfmail to="jlien@epl.ca, vflores@epl.ca" subject="Error Updating ETS Database" from="noreply@epl.ca">
An attempt to update GTFS transit data from City of Edmonton failed.
Please check that the vsd.ETS databases are functional and investigate this problem.

Typically this type of error occurs because the data provided by ETS has been changed in format such that it is no longer compatible with the existing database structure. Fixing his requires rebuilding the database with new field types.

The following messages have been returned from the server:

<cfoutput>#cfcatch.message#
#cfcatch.detail#</cfoutput>
</cfmail>
	<cfabort>
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

<!--- If everything seems to be working, now let's switch the active database to the newly updated one. --->

<cfquery name="SwapDBs" dbtype="ODBC" datasource="ReadWriteSource">
	UPDATE vsd.ETS_activeDB SET active=1, updated=GETDATE() WHERE dbid=#updatedb.dbid#
	UPDATE vsd.ETS_activeDB SET active=0 WHERE dbid!=#updatedb.dbid#
</cfquery>


<p>GTFS Data has been updated successfully in <cfoutput>#dbprefix#</cfoutput>.</p>