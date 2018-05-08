<cfsetting requesttimeout="600" /><!--- 600 seconds = ten minutes--->
<!--- First, I'm going to see if I can get all this GTFS data to download --->


<!--- Link Provided by City of Edmonton--->
<cfset gtfsUrl = "https://data.edmonton.ca/download/gzhc-5ss6/application%2Fzip" />

<!--- Actual filename --->
<!--- <cfset gtfsActual = "https://data.edmonton.ca/api/views/gzhc-5ss6/files/d646faa2-b520-418a-95e8-8ba53a989daf?filename=gtfs.zip" /> --->
<!--- 💩 <cfhttp method="get" url="#gtfsUrl#" path="D:\inetpub\temp\gtfs" file="gtfs.zip" timeout="1000" getasbinary="auto"> --->

<!--- Download COE zip file --->


<cfx_http5 url="#gtfsUrl#" ssl="5" async="n" out="D:\inetpub\temp\gtfs\gtfs.zip" file="y">

<CFIF STATUS EQ "ER">
   <h2>Server returned error: <CFOUTPUT>#ERRN#</CFOUTPUT></h2>
   <p><b>Failure to update GTFS Data</b></p>
   <!--- Could email JD here --->
   <CFOUTPUT>#MSG#</CFOUTPUT>
   <CFABORT>
</CFIF>
<!--- Extract zip into gtfs directory --->
<cfzip action="unzip" file="D:\inetpub\temp\gtfs\gtfs.zip" overwrite="true" destination="D:\inetpub\temp\gtfs\" />

<!--- Delete the original zip as we do not need it anymore --->
<cffile action="delete" file="D:\inetpub\temp\gtfs\gtfs.zip" />



<!--- List of files. First in reverse order for deleting without violating constraints --->

<!--- Remove annoying headers from GTFS files so we can import them easily --->
<!--- They use the command findstr /V /R "^[a-z].*[a-z]$" stop_times.txt > stop_times_noheader.txt --->
<cfexecute name='D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.bat' timeout="10" />



<cfset gtfsFilesRev="stop_times,transfers,trips,stops,shapes,routes,calendar_dates,agency" />
<!--- DO NOT include stop_times at the end of this list. We handle it separately --->
<cfset gtfsFiles="agency,calendar_dates,routes,shapes,stops,trips,transfers,stop_times" />

<cftry>
	<!--- Choose the inactive database to be updated. --->
	<cfquery name="updatedb" dbtype="ODBC" datasource="SecureSource">
		SELECT TOP 1 * FROM vsd.ETS_activeDB WHERE active = 0
	</cfquery>


	<cfset dbprefix = updatedb.prefix />


	<cfquery name="BulkInsert" dbtype="ODBC" datasource="ReadWriteSource">

	<cfloop list="#gtfsFilesRev#" index="fileBase">
	DELETE FROM vsd.#dbprefix#_#fileBase#
	</cfloop>
	<cfloop list="#gtfsFiles#" index="fileBase">
		BULK INSERT vsd.#dbprefix#_#fileBase# FROM '\\web6\gtfs$\#fileBase#_noheader.txt'
		WITH (
		FIRSTROW=1,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FORMATFILE = '\\web6\gtfs$\#fileBase#.fmt'
		);
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


<!--- If everything seems to be working, now let's switch the active database to the newly updated one. --->

<cfquery name="SwapDBs" dbtype="ODBC" datasource="ReadWriteSource">
	UPDATE vsd.ETS_activeDB SET active=1, updated=GETDATE() WHERE dbid=#updatedb.dbid#
	UPDATE vsd.ETS_activeDB SET active=0 WHERE dbid!=#updatedb.dbid#
</cfquery>


<p>GTFS Data has been updated successfully in <cfoutput>#dbprefix#</cfoutput>.</p>