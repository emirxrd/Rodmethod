@echo off
Mode 125,35  
setlocal EnableDelayedExpansion
title Hazirlaniyor...
REM Make Directories
mkdir %SYSTEMDRIVE%\KlofroxRod >nul 2>&1
mkdir %SYSTEMDRIVE%\KlofroxRod\Resources >nul 2>&1
mkdir %SYSTEMDRIVE%\KlofroxRod\HoneRevert >nul 2>&1
mkdir %SYSTEMDRIVE%\KlofroxRod\Drivers >nul 2>&1
mkdir %SYSTEMDRIVE%\KlofroxRod\Renders >nul 2>&1
cd %SYSTEMDRIVE%\Hone
REM Run as Admin
reg add HKLM /F >nul 2>&1
if %errorlevel% neq 0 start "" /wait /I /min powershell -NoProfile -Command start -verb runas "'%~s0'" && exit /b

REM Show Detailed BSoD
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f >nul 2>&1


REM Blank/Color Character
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a" & set "COL=%%b")

REM Add ANSI escape sequences
reg add HKCU\CONSOLE /v VirtualTerminalLevel /t REG_DWORD /d 1 /f >nul 2>&1
:Disclaimer
reg query "HKCU\Software\Hone" /v "Disclaimer" >nul 2>&1 && goto CheckForUpdates
cls
echo.
echo.
call :KlofroxTitle
echo.
echo                                        %COL%[90m HoneCtrl is a free and open-source desktop utility
echo                                        %COL%[90m    made to improve your day-to-day productivity
echo.
echo.
echo.
echo %COL%[91m  WARNING:
echo %COL%[37m  Please note that we cannot guarantee an FPS boost from applying our optimizations, every system + configuration is different.
echo.
echo     %COL%[33m1.%COL%[37m Everything is "use at your own risk", we are %COL%[91mNOT LIABLE%COL%[37m if you damage your system in any way
echo        (ex. not following the disclaimers carefully).
echo.
echo     %COL%[33m2.%COL%[37m If you don't know what a tweak is, do not use it and contact our support team to receive more assistance.
echo.
echo     %COL%[33m3.%COL%[37m Even though we have an automatic restore point feature, we highly recommend making a manual restore point before running.
echo.
echo   For any questions and/or concerns, please join our discord: discord.gg/hone
echo.
echo   Please enter "I agree" without quotes to continue:
echo.
echo.
echo.
set /p "input=%DEL%                                                            >: %COL%[92m"
if /i "!input!" neq "i agree" goto Disclaimer
reg add "HKCU\Software\Hone" /v "Disclaimer" /f >nul 2>&1

:CheckForUpdates
set local=1.0
set localtwo=%LOCAL%
if exist "%TEMP%\KlofroxUpdater.bat" DEL /S /Q /F "%TEMP%\KlofroxUpdater.bat" >nul 2>&1
curl -g -L -# -o "%TEMP%\KlofroxUpdater.bat" "https://raw.githubusercontent.com/auraside/HoneCtrl/main/Files/HoneCtrlVer" >nul 2>&1
call "%TEMP%\KlofroxUpdater.bat"
if "%LOCAL%" gtr "%LOCALTWO%" (
	clsr
	Mode 65,16
	echo.
	echo  --------------------------------------------------------------
	echo                           Guncelleme Bulundu
	echo  --------------------------------------------------------------
	echo.
	echo                    Sizin surumunuz: %LOCALTWO%
	echo.
	echo                          Yeni surum: %LOCAL%
	echo.
	echo.
	echo.
	echo      [Y] Evet, Guncelle
	echo      [N] Hayir
	echo.
	%SYSTEMROOT%\System32\choice.exe /c:YN /n /m "%DEL%                                >:"
	set choice=!errorlevel!
	if !choice! == 1 (
		curl -L -o %0 "https://github.com/auraside/HoneCtrl/releases/latest/download/HoneCtrl.Bat" >nul 2>&1
		call %0
		exit /b
	)
	Mode 130,45
)
:menu
color 4
cls
echo.
echo                                              Klofrox tarafindan yapilmistir  
echo.
echo                          Sorulariniz veya yardim icin discord adresimi birakiyorum klof#1864
echo. 
echo                    Restore point (geri yukleme noktasi) mutlaka olusturmaniz gerekmektedir [2 ye basin]
echo.
echo                                                   Version [1.0]
echo.
echo.

echo                                     [1] Rod Method                  [2] 
echo.
echo                                                       [3] Exit
echo.
choice /C "123" /N 
if "%errorlevel%"=="2" goto rodmethod
if "%errorlevel%"=="3" goto exit
if "%errorlevel%"=="1" goto warning

:rodmethod
cls
::Optimizing Internet Final
::Internet Settings
ipconfig /release
ipconfig /renew
ipconfig /flushdns
ipconfig /registerdns
netsh winhttp reset proxy 
netsh int ip reset 
netsh int tcp reset  
netsh winsock reset 
netsh int tcp set global autotuninglevel=normal
netsh int tcp set heuristics disabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global MaxSynRetransmissions=2
netsh int tcp set global rsc=disabled
netsh int tcp set global rss=enabled
netsh int tcp set global initialRto=2000
netsh int tcp set global fastopen=enabled
netsh int tcp set global dca=enabled
netsh int ipv4 set subinterface "Ethernet" mtu=1492 store=persistent
netsh int tcp set supplemental template=custom icw=10
::Disable Nagle's Algorithm and Set MTU Manually
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%i" /v "MTU" /t REG_DWORD /d "1492" /f
::Internet Optimizations
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "30" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDataRetransmissions" /t REG_DWORD /d "5" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxFreeTcbs" /t REG_DWORD /d "65535" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxHashTableSize" /t REG_DWORD /d "65536" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableDCA" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "LocalPriority" /t REG_DWORD /d "4" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "HostsPriority" /t REG_DWORD /d "5" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "DnsPriority" /t REG_DWORD /d "6" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\ServiceProvider" /v "NetbtPriority" /t REG_DWORD /d "7" /f 
reg add "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" /v "IRPStackSize" /t REG_DWORD /d "32" /f 
reg add "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" /v "SizReqBuf" /t REG_DWORD /d "17424" /f 
reg add "HKLM\System\CurrentControlSet\Services\LanmanServer\Parameters" /v "Size" /t REG_DWORD /d "3" /f 
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v "DisableBandwidthThrottling" /t REG_DWORD /d "1" /f 
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_SZ /d "1" /f
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "1" /f
reg add "HKLM\System\SOFTWARE\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f 
reg add "HKLM\SOFTWARE\Microsoft\MSMQ\Parameters" /v "TCPNoDelay" /t REG_DWORD /d "1" /f

::Delete Windows Apps
echo.
echo lutfen bekleyiniz windows uygulamari siliniyor bu islem biraz zaman alacaktir
powershell "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage" 
echo.
echo islem basariyla tamamlandi (1/81)
powershell "Get-AppxPackage *Microsoft.3DBuilder* | Remove-AppxPackage"
echo islem basariyla tamamlandi (2/81)
powershell "Get-AppxPackage *Microsoft.Appconnector* | Remove-AppxPackage"
echo islem basariyla tamamlandi (3/81)
powershell "Get-AppxPackage *Microsoft.Advertising.Xaml* | Remove-AppxPackage"
echo islem basariyla tamamlandi (4/81)
powershell "Get-AppxPackage *Microsoft.BingFinance* | Remove-AppxPackage"
echo islem basariyla tamamlandi (5/81)
powershell "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage"
echo islem basariyla tamamlandi (6/81)
powershell "Get-AppxPackage *Microsoft.BingSports* | Remove-AppxPackage"
echo islem basariyla tamamlandi (7/81)
powershell "Get-AppxPackage *Microsoft.BingTranslator* | Remove-AppxPackage"
echo islem basariyla tamamlandi (8/81)
powershell "Get-AppxPackage *Microsoft.BingWeather* | Remove-AppxPackage"
echo islem basariyla tamamlandi (9/81)
powershell "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage"
echo islem basariyla tamamlandi (10/81)
powershell "Get-AppxPackage *Microsoft.MicrosoftOfficeHub* | Remove-AppxPackage"
echo islem basariyla tamamlandi (11/81)
powershell "Get-AppxPackage *Microsoft.MicrosoftSolitaireCollection* | Remove-AppxPackage"
echo islem basariyla tamamlandi (12/81)
powershell "Get-AppxPackage *Microsoft.MicrosoftPowerBIForWindows* | Remove-AppxPackage"
echo islem basariyla tamamlandi (13/81)
powershell "Get-AppxPackage *Microsoft.MinecraftUWP* | Remove-AppxPackage"
echo islem basariyla tamamlandi (14/81)
powershell "Get-AppxPackage *Microsoft.MicrosoftStickyNotes* | Remove-AppxPackage"
echo islem basariyla tamamlandi (15/81)
powershell "Get-AppxPackage *Microsoft.NetworkSpeedTest* | Remove-AppxPackage"
echo islem basariyla tamamlandi (16/81)
powershell "Get-AppxPackage *Microsoft.Office.OneNote* | Remove-AppxPackage"
echo islem basariyla tamamlandi (17/81)
powershell "Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage"
echo islem basariyla tamamlandi (18/81)
powershell "Get-AppxPackage *Microsoft.People* | Remove-AppxPackage"
echo islem basariyla tamamlandi (19/81)
powershell "Get-AppxPackage *Microsoft.Wallet* | Remove-AppxPackage"
echo islem basariyla tamamlandi (20/81)
powershell "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage"
echo islem basariyla tamamlandi (21/81)
powershell "Get-AppxPackage *Microsoft.WindowsCamera* | Remove-AppxPackage"
echo islem basariyla tamamlandi (22/81)
powershell "Get-AppxPackage *microsoft.windowscommunicationsapps*| Remove-AppxPackage"
echo islem basariyla tamamlandi (23/81)
powershell "Get-AppxPackage *Microsoft.WindowsMaps* | Remove-AppxPackage"
echo islem basariyla tamamlandi (24/81)
powershell "Get-AppxPackage *Microsoft.WindowsPhone* | Remove-AppxPackage"
echo islem basariyla tamamlandi (25/81)
powershell "Get-AppxPackage *Microsoft.WindowsSoundRecorder* | Remove-AppxPackage"
echo islem basariyla tamamlandi (26/81)
powershell "Get-AppxPackage *Microsoft.ZuneMusic* | Remove-AppxPackage"
echo islem basariyla tamamlandi (27/81)
powershell "Get-AppxPackage *Microsoft.ZuneVideo* | Remove-AppxPackage"
echo islem basariyla tamamlandi (28/81)
powershell "Get-AppxPackage *Microsoft.CommsPhone* | Remove-AppxPackage"
echo islem basariyla tamamlandi (29/81)
powershell "Get-AppxPackage *Microsoft.ConnectivityStore* | Remove-AppxPackage"
echo islem basariyla tamamlandi (30/81)
powershell "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage"
echo islem basariyla tamamlandi (31/81)
powershell "Get-AppxPackage *Microsoft.Getstarted* | Remove-AppxPackage"
echo islem basariyla tamamlandi (32/81)
powershell "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage"
echo islem basariyla tamamlandi (33/81)
powershell "Get-AppxPackage *Microsoft.Office.Sway* | Remove-AppxPackage"
echo islem basariyla tamamlandi (34/81)
powershell "Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage"
echo islem basariyla tamamlandi (35/81)
powershell "Get-AppxPackage *Microsoft.WindowsFeedbackHub* | Remove-AppxPackage"
echo islem basariyla tamamlandi (36/81)
powershell "Get-AppxPackage *Microsoft.Microsoft3DViewer* | Remove-AppxPackage"
echo islem basariyla tamamlandi (37/81)
powershell "Get-AppxPackage *Microsoft.BingFoodAndDrink* | Remove-AppxPackage"
echo islem basariyla tamamlandi (38/81)
powershell "Get-AppxPackage *Microsoft.BingTravel* | Remove-AppxPackage"
echo islem basariyla tamamlandi (39/81)
powershell "Get-AppxPackage *Microsoft.BingHealthAndFitness* | Remove-AppxPackage"
echo islem basariyla tamamlandi (40/81)
powershell "Get-AppxPackage *Microsoft.WindowsReadingList* | Remove-AppxPackage"
echo islem basariyla tamamlandi (41/81)
powershell "Get-AppxPackage *Microsoft.MixedReality.Portal* | Remove-AppxPackage"
echo islem basariyla tamamlandi (42/81)
powershell "Get-AppxPackage *Microsoft.ScreenSketch* | Remove-AppxPackage"
echo islem basariyla tamamlandi (43/81)
powershell "Get-AppxPackage *Microsoft.YourPhone* | Remove-AppxPackage"
echo islem basariyla tamamlandi (44/81)
powershell "Get-AppxPackage *9E2F88E3.Twitter* | Remove-AppxPackage"
echo islem basariyla tamamlandi (45/81)
powershell "Get-AppxPackage *PandoraMediaInc.29680B314EFC2* | Remove-AppxPackage"
echo islem basariyla tamamlandi (46/81)
powershell "Get-AppxPackage *Flipboard.Flipboard* | Remove-AppxPackage"
echo islem basariyla tamamlandi (47/81)
powershell "Get-AppxPackage *ShazamEntertainmentLtd.Shazam* | Remove-AppxPackage"
echo islem basariyla tamamlandi (48/81)
powershell "Get-AppxPackage *king.com.CandyCrushSaga* | Remove-AppxPackage"
echo islem basariyla tamamlandi (49/81)
powershell "Get-AppxPackage *king.com.CandyCrushSodaSaga* | Remove-AppxPackage"
echo islem basariyla tamamlandi (50/81)
powershell "Get-AppxPackage *king.com.BubbleWitch3Saga* | Remove-AppxPackage"
echo islem basariyla tamamlandi (51/81)
powershell "Get-AppxPackage *ClearChannelRadioDigital.iHeartRadio* | Remove-AppxPackage"
echo islem basariyla tamamlandi (52/81)
powershell "Get-AppxPackage *4DF9E0F8.Netflix* | Remove-AppxPackage"
echo islem basariyla tamamlandi (53/81)
powershell "Get-AppxPackage *6Wunderkinder.Wunderlist* | Remove-AppxPackage"
echo islem basariyla tamamlandi (54/81)
powershell "Get-AppxPackage *Drawboard.DrawboardPDF* | Remove-AppxPackage"
echo islem basariyla tamamlandi (55/81)
powershell "Get-AppxPackage *2FE3CB00.PicsArt-PhotoStudio* | Remove-AppxPackage"
echo islem basariyla tamamlandi (56/81)
powershell "Get-AppxPackage *D52A8D61.FarmVille2CountryEscape* | Remove-AppxPackage"
echo islem basariyla tamamlandi (57/81)
powershell "Get-AppxPackage *TuneIn.TuneInRadio* | Remove-AppxPackage"
echo islem basariyla tamamlandi (58/81)
powershell "Get-AppxPackage *GAMELOFTSA.Asphalt8Airborne* | Remove-AppxPackage"
echo islem basariyla tamamlandi (59/81)
powershell "Get-AppxPackage *TheNewYorkTimes.NYTCrossword* | Remove-AppxPackage"
echo islem basariyla tamamlandi (60/81)
powershell "Get-AppxPackage *DB6EA5DB.CyberLinkMediaSuiteEssentials* | Remove-AppxPackage"
echo islem basariyla tamamlandi (61/81)
powershell "Get-AppxPackage *Facebook.Facebook* | Remove-AppxPackage"
echo islem basariyla tamamlandi (62/81)
powershell "Get-AppxPackage *flaregamesGmbH.RoyalRevolt2* | Remove-AppxPackage"
echo islem basariyla tamamlandi (63/81)
powershell "Get-AppxPackage *Playtika.CaesarsSlotsFreeCasino* | Remove-AppxPackage"
echo islem basariyla tamamlandi (64/81)
powershell "Get-AppxPackage *A278AB0D.MarchofEmpires* | Remove-AppxPackage"
echo islem basariyla tamamlandi (65/81)
powershell "Get-AppxPackage *KeeperSecurityInc.Keeper* | Remove-AppxPackage"
echo islem basariyla tamamlandi (66/81)
powershell "Get-AppxPackage *ThumbmunkeysLtd.PhototasticCollage* | Remove-AppxPackage"
echo islem basariyla tamamlandi (67/81)
powershell "Get-AppxPackage *XINGAG.XING* | Remove-AppxPackage"
echo islem basariyla tamamlandi (68/81)
powershell "Get-AppxPackage *89006A2E.AutodeskSketchBook* | Remove-AppxPackage"
echo islem basariyla tamamlandi (69/81)
powershell "Get-AppxPackage *D5EA27B7.Duolingo-LearnLanguagesforFree* | Remove-AppxPackage"
echo islem basariyla tamamlandi (70/81)
powershell "Get-AppxPackage *46928bounde.EclipseManager* | Remove-AppxPackage"
echo islem basariyla tamamlandi (71/81)
powershell "Get-AppxPackage *ActiproSoftwareLLC.562882FEEB491* | Remove-AppxPackage"
echo islem basariyla tamamlandi (72/81)
powershell "Get-AppxPackage *DolbyLaboratories.DolbyAccess* | Remove-AppxPackage"
echo islem basariyla tamamlandi (73/81)
powershell "Get-AppxPackage *A278AB0D.DisneyMagicKingdoms* | Remove-AppxPackage"
echo islem basariyla tamamlandi (74/81)
powershell "Get-AppxPackage *WinZipComputing.WinZipUniversal* | Remove-AppxPackage"
echo islem basariyla tamamlandi (75/81)
powershell "Get-AppxPackage *CAF9E577.Plex* | Remove-AppxPackage"
echo islem basariyla tamamlandi (76/81)
powershell "Get-AppxPackage *7EE7776C.LinkedInforWindows* | Remove-AppxPackage"
echo islem basariyla tamamlandi (77/81)
powershell "Get-AppxPackage *613EBCEA.PolarrPhotoEditorAcademicEdition* | Remove-AppxPackage"
echo islem basariyla tamamlandi (78/81)
powershell "Get-AppxPackage *Fitbit.FitbitCoach* | Remove-AppxPackage"
echo islem basariyla tamamlandi (79/81)
powershell "Get-AppxPackage *DolbyLaboratories.DolbyAccess* | Remove-AppxPackage"
echo islem basariyla tamamlandi (80/81)
powershell "Get-AppxPackage *Microsoft.BingNews* | Remove-AppxPackage"
echo islem basariyla tamamlandi (81/81)
powershell "Get-AppxPackage *NORDCURRENT.COOKINGFEVER* | Remove-AppxPackage"


echo. 
echo.
::Delete Windows Logs


FOR /F "tokens=1,2*" %%V IN ('bcdedit') DO SET adminTest=%%V
IF (%adminTest%)==(Access) goto noAdmin
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")
echo.
goto menu
:do_clear
echo clearing %1
wevtutil.exe cl %1
goto :eof
:noAdmin
pause

:KlofroxTitle
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@B7@@@@@@@@PJ@@@@@@@@@@@@@##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@&BPY?!~P@@@@@@@@@@@@@P JGY??YGP ~@@@@@@@@@@@@@B^.:^!?YPB&@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@B5?~:     5@@@@@@@@@@@@@@?          .&@@@@@@@@@@@@@B        :~?5B@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@#P7:         ^@@@@@@@@@@@@@@@~           G@@@@@@@@@@@@@@~            ^?G&@@@@@@@@@@@@@
echo @@@@@@@@@@@&P!.            ^@@@@@@@@@@@@@@&:           Y@@@@@@@@@@@@@&:               :?B@@@@@@@@@@@
echo @@@@@@@@@&Y:                J@@@@@@@@@@@@@B            !@@@@@@@@@@@@&!                   !B@@@@@@@@@
echo @@@@@@@@5:                   ~P&@@@@@@@@@@P            :@@@@@@@@@@#Y:                      ?&@@@@@@@
echo @@@@@@&!                       :!J5PGGGGPY~             ?PGBBBG5J~.                         ^#@@@@@@
echo @@@@@@~                                                                                      ^&@@@@@
echo @@@@@J                                                                                        ?@@@@@
echo @@@@@^                                                                                        ^@@@@@
echo @@@@@:                                                                                        :@@@@@
echo @@@@@J                                                                                        ?@@@@@
echo @@@@@&~                    .:.                                       .::.                    ^&@@@@@
echo @@@@@@&7                :Y#&&#GY~.                                :?P#&&&BJ.                ^#@@@@@@
echo @@@@@@@@P^             :#@@@@@@@@#?.                            :5&@@@@@@@@#^             .J@@@@@@@@
echo @@@@@@@@@@5~           Y@@@@@@@@@@@#7  .YBBP?.        .7PBBJ.  ?&@@@@@@@@@@@P           :?#@@@@@@@@@
echo @@@@@@@@@@@@B?^        Y@@@@@@@@@@@@@G:P@@@@@&?      7#@@@@@P.5@@@@@@@@@@@@@B        .!P&@@@@@@@@@@@
echo @@@@@@@@@@@@@@@BJ~.    ~@@@@@@@@@@@@@@&@@@@@@@@5    5@@@@@@@@B@@@@@@@@@@@@@@J    .~?P&@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@&GY!^ Y@@@@@@@@@@@@@@@@@@@@@@@Y  Y@@@@@@@@@@@@@@@@@@@@@@@B^~7YG&@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@#G@@@@@@@@@@@@@@@@@@@@@@@@^~@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@PP@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

echo                    `.
goto :eof


:createrestorepoint
cls
color A
echo Rod method isleminde tabikide bilgisayariniza zarar verecek bir islem yoktur fakat ne olur ne olmaz geri yukleme olusturmaniz faydali olacaktir. Asagidaki video linkine giderek nasil yapilacagini ogrenebilirsiniz.

echo.

echo Video linki: https://www.youtube.com/watch?v=vKH0QeV0coM
echo.
echo.
echo.
echo                                                     [B] Menuye donmek icin tiklayin
choice /C "B" /N 
if "%errorlevel%"=="1" goto Menu
:exit
exit /b