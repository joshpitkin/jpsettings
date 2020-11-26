; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.
; # = windows key
; ^ = ctrl
; ! = alt
; + = shift


; #z::Run www.autohotkey.com

^!right:: ;This will disable the effect of Win + ->
^!left::  ;This will disable the effect of Win + <-
^!down::

; Capslock::Esc

^SPACE::  Winset, Alwaysontop, , A

!d::ToggleWinMinimize("Developer Tools - ","")
^!s::ToggleWinMinimize("Google Chrome","")
; #z::Run % "chrome.exe" ( WinExist("ahk_class Chrome_WidgetWin_1") ? " --new-window" : " ")
^!n::ToggleWinMinimize("- OneNote","")
#y::send ^!+3

^!l::
send jpitkin{tab}Y0uv5Y0u21
return

^!p::
send Y0uv5Y0u21
return

^!a::
send auxitauto{tab}628bXJ@@VaBg
return

#IfWinActive ahk_exe OUTLOOK.EXE
^L::send,
(
Let me know if you have any questions.

Thanks -Josh
)
return

#IfWinActive ahk_exe OUTLOOK.EXE
^T::send,
(
Thanks -Josh
)
return
#IfWinActive

#IfWinActive ahk_exe Ssms.exe
!S::send,
(
select top 100 * from 
)
return
#IfWinActive

; Note: From now on whenever you run AutoHotkey directly, this script
; will be loaded.  So feel free to customize it to suit your needs.

; Please read the QUICK-START TUTORIAL near the top of the help file.
; It explains how to perform common automation tasks such as sending
; keystrokes and mouse clicks.  It also explains more about hotkeys.


ToggleWinMinimize(TheWindowTitle,NotWindowTitle)
{
	SetTitleMatchMode,2
	DetectHiddenWindows, Off
	IfWinActive, %TheWindowTitle%, , %NotWindowTitle%
	{
		WinMinimize, %TheWindowTitle%
	}
	Else
	{
		IfWinExist, %TheWindowTitle%, , %NotWindowTitle%
		{
			WinGet, winid, ID, %TheWindowTitle%, , %NotWindowTitle%
			DllCall("SwitchToThisWindow", "UInt", winid, "UInt", 1)
		}
	}
	Return
}

; hotstrings
; #Hotstring EndChars -()[]{}:;'"/\,.?!`n `t
#Hotstring EndChars /\;

:o:btw::by the way
:o:ga::git add .
:o:gc::git commit -m "
:o:gp::git push -u origin HEAD
:o:ngsl::ng serve libdev --host 0.0.0.0
:o:ngs::ng serve --host 0.0.0.0
:o:ngs1::ng serve --host 0.0.0.0 --port 4100
:o:ocl::oc login https://bo-ose-test.micron.com:8443
:o:oct::TOKEN=``oc whoami -t``
:o:octt::echo $TOKEN | docker login --password-stdin -u unused docker-registry-default.bo-ose-test.micron.com
:o:dri::iteng-docker-dev.boartifactory.micron.com
:o:dro::docker-registry-default.bo-ose-test.micron.com
:o:dvp::docker volume prune --force
:o:dip::docker image prune --force
:o:dcp::docker container prune --force
:o:dsp::docker system prune
:o:dcu::docker-compose -f .devcontainer/docker-compose.yml up -d
:o:dcd::docker-compose -f .devcontainer/docker-compose.yml down
:o:de::docker exec -it <container> zsh
:o:dcb::docker-compose -f docker-compose-build.yml build

