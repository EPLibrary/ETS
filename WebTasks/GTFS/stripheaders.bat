@echo off
C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\stop_times.txt > D:\inetpub\temp\gtfs\stop_times_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\shapes.txt > D:\inetpub\temp\gtfs\shapes_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\trips.txt > D:\inetpub\temp\gtfs\trips_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\calendar_dates.txt > D:\inetpub\temp\gtfs\calendar_dates_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\stops.txt > D:\inetpub\temp\gtfs\stops_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\transfers.txt > D:\inetpub\temp\gtfs\transfers_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\routes.txt > D:\inetpub\temp\gtfs\routes_noheader.txt

C:\Windows\System32\findstr.exe /V /R "^[a-z].*[a-z]$" D:\inetpub\temp\gtfs\agency.txt > D:\inetpub\temp\gtfs\agency_noheader.txt