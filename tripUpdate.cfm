<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />

<cfheader name="Content-Type" value="application/json" />

<!--- TripUpdate.cfm allows a page to request a trip update for a list of tripIDs and a stop.
This is queried from ETSRealTime.exe, which is a Windows command line app made with .NET in C# --->
<cfobject name="gtfsRealtime" component="gtfsRealtime">
<!--- <cfdump var="#server.gtfsrealtime#"> --->

<cfif isDefined('form.tid') AND isDefined('form.stopID')>

	<!--- Get the filename for the TripUpdates.PB --->
	<cfset gtfsRTResp=gtfsRealtime.getPB() />
	
	<cfif isDefined('gtfsRTResp') AND len(gtfsRTResp)>
		<cfset args = "-f #gtfsRTResp#" />
		<cfloop list="#form.tid#" index="tripid">
			<cfset args &= " -t #tripid#" />
		</cfloop>
		<cfset args &= " -s #stopid#" />	


		<!--- <cfdump var="#args#"> --->

		<cfexecute name="C:\inetpub\CustomTags\lib\ETSRealTime\ETSRealTime.exe"
			arguments = "#args#"
			variable="json"
			errorvariable="error"
			timeout="15" />

		<!--- <cfdump var="#error#"> --->

		<!--- <cfdump var="#DeserializeJSON(json)#"> --->


		<cfoutput>#json#</cfoutput>
	<cfelse><cfoutput>
{
		"error": true,
		"message": "There was a problem getting gtfsRealtime data."
}</cfoutput>
	</cfif>


<cfelse><cfoutput>
{
	"error": true,
	"message": "tid (tripid) or stopID is not defined."
}</cfoutput>

</cfif>