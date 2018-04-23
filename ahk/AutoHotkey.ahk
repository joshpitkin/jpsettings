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

#z::Run www.autohotkey.com

; ^!n::
; IfWinExist Untitled - Notepad
;	WinActivate
; else
; 	Run Notepad
; return
;esc::
;	MsgBox Escape!!!!
;Return

^!right:: ;This will disable the effect of Win + ->
^!left::  ;This will disable the effect of Win + <-
^!down::

Capslock::Esc

!o::ToggleWinMinimize("Mailbox - Josh Pitkin","Calendar")
!z::ToggleWinMinimize("Calendar - Mailbox","")
!a::ToggleWinMinimize("- Atom","")
!d::ToggleWinMinimize("Developer Tools - ","")
!x::ToggleWinMinimize("xplorer","Internet Explorer")
^!c::ToggleWinMinimize("APF Formatter","")
^!s::ToggleWinMinimize("Google Chrome","")
^!n::ToggleWinMinimize("- OneNote","")
#y::send ^!+3

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

#IfWinActive, ahk_class CabinetWClass ; for use in explorer.
^!h::
Send ^l
ControlGetText, address , edit1,ahk_class CabinetWClass
MsgBox %address%
Run, C:\Program Files\ConEmu\ConEmu64.exe, %address%
return
#IfWinActive

#IfWinActive ahk_exe Ssms.exe
!S::send,
(
select top 100 * from
)
return


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
