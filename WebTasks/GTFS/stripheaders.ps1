#Removes the first line of all the GTFS files
#City of Edmonton
# (gc  D:\inetpub\temp\gtfs\Edmonton\stop_times.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\stop_times_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\shapes.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\shapes_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\trips.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\trips_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\calendar_dates.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\calendar_dates_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\stops.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\stops_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\transfers.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\transfers_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\routes.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\routes_noheader.txt
# (gc  D:\inetpub\temp\gtfs\Edmonton\agency.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Edmonton\agency_noheader.txt

# Doing these with this powershell script is extremely slow. I'll use the old way for them, but that approach doesn't work well on the other cities.
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\stop_times.txt > D:\inetpub\temp\gtfs\Edmonton\stop_times_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\shapes.txt > D:\inetpub\temp\gtfs\Edmonton\shapes_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\trips.txt > D:\inetpub\temp\gtfs\Edmonton\trips_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\calendar_dates.txt > D:\inetpub\temp\gtfs\Edmonton\calendar_dates_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\stops.txt > D:\inetpub\temp\gtfs\Edmonton\stops_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\transfers.txt > D:\inetpub\temp\gtfs\Edmonton\transfers_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\routes.txt > D:\inetpub\temp\gtfs\Edmonton\routes_noheader.txt
# C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\agency.txt > D:\inetpub\temp\gtfs\Edmonton\agency_noheader.txt

# Maybe this batch file will be quick?? Anything directly in powershell seems to suck
& "D:\inetpub\www2.epl.ca\WebTasks\GTFS\stripheaders.bat"

# #Strathcona County
(gc  D:\inetpub\temp\gtfs\Strathcona\stop_times_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\stop_times_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\shapes_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\shapes_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\trips_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\trips_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\calendar_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\calendar_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\calendar_dates_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\calendar_dates_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\stops_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\stops_noheader.txt
#(gc  D:\inetpub\temp\gtfs\Strathcona\transfers_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\transfers_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\routes_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\routes_noheader.txt
(gc  D:\inetpub\temp\gtfs\Strathcona\agency_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\Strathcona\agency_noheader.txt

#St. Albert
(gc  D:\inetpub\temp\gtfs\StAlbert\stop_times_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\stop_times_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\shapes_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\shapes_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\trips_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\trips_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\calendar_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\calendar_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\calendar_dates_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\calendar_dates_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\stops_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\stops_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\transfers_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\transfers_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\routes_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\routes_noheader.txt
(gc  D:\inetpub\temp\gtfs\StAlbert\agency_noblank.txt | select -Skip 1) | sc D:\inetpub\temp\gtfs\StAlbert\agency_noheader.txt