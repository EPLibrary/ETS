<cfsetting enablecfoutputonly="true" />
<cfsetting showdebugoutput="false" />

<cfheader name="Content-Type" value="application/json" />

<!--- TripUpdate.cfm allows a page to request a trip update for a list of tripIDs and a stop.
This NEW version requests from the database which is populated approximately every two minutes with ETSRealtime.exe --->

<cfif isDefined('url.tid')><cfset form.tid=url.tid /></cfif>
<cfif isDefined('url.stopid')><cfset form.stopid=url.stopid /></cfif>

<cfif isDefined('form.tid') AND isDefined('form.stopID')>

	<cfset i=0 />
	<cfquery name="TripUpdate" dbtype="ODBC" datasource="SecureSource">
			SELECT * FROM ETSRT1_stop_time_update WHERE
			(<cfloop list="#form.tid#" item="tripid">
				<cfif IsNumeric(tripid)>
				<cfif i++ NEQ 0> OR </cfif>trip_id='#tripid#'
				</cfif>
			</cfloop>)
			AND stop_id='#form.stopid#'
	</cfquery>

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
	<!--- Now I need to convert this query back into the data structure of the PB --->
	<cfset data = StructNew() />
	<cfset data.message.entity = arrayNew(1) />
	<cfloop query="TripUpdate">
		<cfset newEntity = StructNew() />
		<cfset newEntity.id = trip_id />
		<cfset newEntity.trip_update = StructNew() />
		<!--- To get these empty ones, I need to join trip_update which is probably unnecesary --->
		<cfset newEntity.trip_update.schedule_relationship = "" />
		<cfset newEntity.trip_update.start_date = "" />
		<cfset newEntity.trip_update.start_time = "" />
		<cfset newEntity.trip_update.trip_id = trip_id />
		<cfset newEntity.trip_update.stop_time_update = arrayNew(1) />
		<cfset newStu = structNew() />
		<cfset newStu.departure = structNew() />
		<cfset newStu.departure.delay = delay />
		<cfset newStu.departure["departure.uncertainty"] = departure_uncertainty />
		<cfset newStu.departure.time = time />
		<cfset newStu.schedule_relationship = schedule_relationship />
		<cfset newStu.stop_id = stop_id />
		<cfset newStu.stop_sequence = stop_sequence />
		<cfset ArrayAppend(newEntity.trip_update.stop_time_update, newStu) />
		<cfset ArrayAppend(data.message.entity, newEntity) />
	</cfloop>

		<cfoutput>#SerializeJSON(data)#</cfoutput>
<cfelse><cfoutput>
{
	"error": true,
	"message": "tid (tripid) or stopID is not defined."
}</cfoutput>

</cfif>