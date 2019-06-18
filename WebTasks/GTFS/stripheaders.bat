@echo off
rem This file only gets part of the job done, removing headers from Edmonton GTFS files only.
rem To strip headers for all cities, execute the stripheaders.ps1 powershell script which will execute this code bat file.
rem City of Edmonton
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\stop_times.txt > D:\inetpub\temp\gtfs\Edmonton\stop_times_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\shapes.txt > D:\inetpub\temp\gtfs\Edmonton\shapes_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\trips.txt > D:\inetpub\temp\gtfs\Edmonton\trips_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\calendar.txt > D:\inetpub\temp\gtfs\Edmonton\calendar_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\calendar_dates.txt > D:\inetpub\temp\gtfs\Edmonton\calendar_dates_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\stops.txt > D:\inetpub\temp\gtfs\Edmonton\stops_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\transfers.txt > D:\inetpub\temp\gtfs\Edmonton\transfers_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\routes.txt > D:\inetpub\temp\gtfs\Edmonton\routes_noheader.txt
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\Edmonton\agency.txt > D:\inetpub\temp\gtfs\Edmonton\agency_noheader.txt

rem This removes blank lines from the files, which would break the import
rem Strathcona County
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\stop_times.txt > D:\inetpub\temp\gtfs\Strathcona\stop_times_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\shapes.txt > D:\inetpub\temp\gtfs\Strathcona\shapes_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\trips.txt > D:\inetpub\temp\gtfs\Strathcona\trips_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\calendar.txt > D:\inetpub\temp\gtfs\Strathcona\calendar_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\calendar_dates.txt > D:\inetpub\temp\gtfs\Strathcona\calendar_dates_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\stops.txt > D:\inetpub\temp\gtfs\Strathcona\stops_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\transfers.txt > D:\inetpub\temp\gtfs\Strathcona\transfers_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\routes.txt > D:\inetpub\temp\gtfs\Strathcona\routes_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\Strathcona\agency.txt > D:\inetpub\temp\gtfs\Strathcona\agency_noblank.txt
rem Remove "Virtual Stops" starting with an S. To support these I need to change stops to numbers, which would be terrible for performance.
C:\Windows\System32\findstr.exe /V /R "^S999[0-9].*" D:\inetpub\temp\gtfs\Strathcona\stops_noblank.txt > D:\inetpub\temp\gtfs\Strathcona\stops_noblank_novirtual.txt
copy D:\inetpub\temp\gtfs\Strathcona\stops_noblank_novirtual.txt D:\inetpub\temp\gtfs\Strathcona\stops_noblank.txt

rem St. Albert
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\stop_times.txt > D:\inetpub\temp\gtfs\StAlbert\stop_times_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\shapes.txt > D:\inetpub\temp\gtfs\StAlbert\shapes_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\trips.txt > D:\inetpub\temp\gtfs\StAlbert\trips_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\calendar.txt > D:\inetpub\temp\gtfs\StAlbert\calendar_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\calendar_dates.txt > D:\inetpub\temp\gtfs\StAlbert\calendar_dates_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\stops.txt > D:\inetpub\temp\gtfs\StAlbert\stops_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\transfers.txt > D:\inetpub\temp\gtfs\StAlbert\transfers_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\routes.txt > D:\inetpub\temp\gtfs\StAlbert\routes_noblank.txt
C:\Windows\System32\findstr.exe /V /R "^$" D:\inetpub\temp\gtfs\StAlbert\agency.txt > D:\inetpub\temp\gtfs\StAlbert\agency_noblank.txt