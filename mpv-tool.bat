@ECHO OFF
SETLOCAL enabledelayedexpansion
cls
echo *------------------------ MPV Tool ------------------------*

set /p url="Enter URL:"

if "%url%" == "" (
	echo Error: No link provided
	goto :eof
)

if not "%url:~0,4%" == "http" ( 
	if not "%url:~0,5%" == "https" (
		echo Error: Invalid link. 
		goto :eof
	)
)

:start
	set /p choice="1)Video Stream 2)Audio Stream 3)Download Video 4)Download Audio 5)Download Playlist 6)Download Channel:"
	if %choice%==1 goto streaming
	if %choice%==2 goto streaming
	if %choice%==3 goto downloading
	if %choice%==4 goto downloading
	if %choice%==5 goto downloading
	if %choice%==6 goto downloading

:getdisks
	REM Function for user to select disk to save to
	set main_count=0
	set display_count=0
	for /F "usebackq tokens=1" %%a in (`wmic logicaldisk get caption`) do (
		set /A main_count+=1
		if !main_count! NEQ 1 (
			if !main_count! NEQ 8 (
				set disk_!display_count!=%%a
				echo !display_count! - %%a
				set /A display_count+=1
			)
		)
	)

	set /P selected="Please enter the number of the disk you want to save to (Default is 0):"
	set disk_choice=!disk_%selected%!
	if not defined disk_choice set "disk_choice=!disk_0!"
	goto :eof
	
:streaming
	REM MPV Streaming
	if %choice%==1 ( start/MAX mpv %url% ) 
	if %choice%==2 ( start/MIN mpv %url% --no-video)
	goto :eof

:downloading
	call :getdisks
	set /p res="1)480 2)720 3)1080 4)1440 5)2160 (Default 1080):"
	if not defined res set "res=3"
	REM Selecting Resolution
	if %res%==1 ( set best="bestvideo[height<=?480]+bestaudio/best" )
	if %res%==2 ( set best="bestvideo[height<=?720]+bestaudio/best" )
	if %res%==3 ( set best="bestvideo[height<=?1080]+bestaudio/best" )
	if %res%==4 ( set best="bestvideo[height<=?1440]+bestaudio/best" )
	if %res%==5 ( set best="bestvideo[height<=?2160]+bestaudio/best" )

	REM Set directory
	set video_base_filetree=library\non-personal\media\vids
	set music_base_filetree=library\non-personal\media\music
	echo Saving to: %disk_choice%\library\non-personal\media

	REM YT-DL Downloading
	REM Video Download in DISK:\\user\Videos\ 
	if %choice%==3 ( start/MIN youtube-dl -f %best% -w --add-metadata -o "%disk_choice%\%video_base_filetree%\%%(channel)s/[%%(upload_date)s]-[%%(channel)s]-%%(title)s-[%%(resolution)s].%%(ext)s" %url% )
	REM Audio Download in DISK:\Users\user\Music\ 
    if %choice%==4 ( start /MIN youtube-dl --extract-audio -w --add-metadata --audio-format mp3 -o "%disk_choice%\%music_base_filetree%\mp3\%%(channel)s/%%(title)s.%%(ext)s" %url% )
    REM Playlist Download in DISK:\Users\cia\Videos\Playlist
    if %choice%==5 ( start /MIN youtube-dl -f %best% -w --add-metadata -o "%disk_choice%\%video_base_filetree%\playlists\%%(playlist)s/%%(playlist_index)s-[%%(upload_date)s]-%%(title)s-[%%(resolution)s].%%(ext)s" %url% )
    REM Download Channel in DISK:\Users\cia\Videos\Channel\
    if %choice%==6 ( start /MIN youtube-dl -i -w -c --add-metadata -f %best% -o "%disk_choice%\%video_base_filetree%\channels/%%(uploader)s-[%%(uploader_id)s]/[%%(upload_date)s]-%%(title)s-[%%(resolution)s].%%(ext)s" -v %url% )
	goto :eof