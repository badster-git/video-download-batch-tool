@ECHO OFF
cls
echo *------------------------ MPV Tool ------------------------*
set /p url="Enter URL:"
:start
	set /p choice="1)Video Stream 2)Audio Stream 3)Download Video 4)Download Audio 5)Download Playlist 6)Download Channel:"
	if %choice%==1 goto streaming
	if %choice%==2 goto streaming
	if %choice%==3 goto downloading
	if %choice%==4 goto downloading
	if %choice%==5 goto downloading
	if %choice%==6 goto downloading
	
:streaming
	REM MPV Streaming
	if %choice%==1 ( start/MAX mpv %url% ) 
	if %choice%==2 ( start/MIN mpv %url% --no-video)
	goto :eof

:downloading
	set /p res="1)480 2)720 3)1080 4)1440 5)1260 (Default 1080):"
	if not defined res set "res=3"
	REM Selecting Resolution
	if %res%==1 ( set best="bestvideo[height<=?480]+bestaudio/best" )
	if %res%==2 ( set best="bestvideo[height<=?720]+bestaudio/best" )
	if %res%==3 ( set best="bestvideo[height<=?1080]+bestaudio/best" )
	if %res%==4 ( set best="bestvideo[height<=?1440]+bestaudio/best" )
	if %res%==5 ( set best="bestvideo[height<=?1260]+bestaudio/best" )
	REM YT-DL Downloading
	REM Video Download in C:\Users\user\Videos\ 
	if %choice%==3 ( start/MIN youtube-dl -f %best% -o "C:\%HOMEPATH%\Videos\%%(creator)s/%%(title)s.%%(ext)s" %url% )
	REM Audio Download in C:\Users\user\Music\ 
    if %choice%==4 ( start /MIN youtube-dl --extract-audio --audio-format mp3 -o "C:\%HOMEPATH%\Music\%%(creator)s/%%(title)s.%%(ext)s" %url% )
    REM Playlist Download in C:\Users\user\Videos\Playlist
    if %choice%==5 ( start /MIN youtube-dl -f %best% -o "C:\%HOMEPATH%\Videos\Playlist\%%(playlist)s/%%(playlist_index)s - %%(title)s.%%(ext)s" %url% )
    REM Download Channel in C:\Users\user\Videos\Channel\
    if %choice%==6 ( start /MIN youtube-dl -i -w -c --add-metadata -f %best% -o "C:\%HOMEPATH%\Videos\Channel\%%(uploader)s/(%%(uploader_id)s)/%%(upload_date)s - %%(title)s - (%%(duration)s) [%%(resolution)s] [%%(id)s].%%(ext)s" -v %url% )
	goto :eof
