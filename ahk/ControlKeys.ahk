; Copyright (c) 2007-2012 Pavel Chikulaev
; Distributed under BSD license

; if not A_IsAdmin
; {
;    DllCall("shell32\ShellExecuteA", uint, 0, str, "RunAs", str, A_AhkPath
;       , str, """" . A_ScriptFullPath . """", str, A_WorkingDir, int, 1)
;    ExitApp
; }

#InstallKeybdHook

press_count = 0

MyAppsKeyHotkeys(enable)
{
   if (enable = "Off")
   {
      Menu, TRAY, Icon, %A_ScriptDir%\Letter-E.ico
   }
   else
   {
      Menu, TRAY, Icon, %A_ScriptDir%\Letter-C.ico
   }
   HotKey,  a, MyHotKeyOff, %enable%
   HotKey,  b, MyBackWord, %enable%
   HotKey,  c, MyEmpty, %enable%
   HotKey,  d, MyEmpty, %enable%
   HotKey,  e, MyEmpty, %enable%
   HotKey,  f, MyEmpty, %enable%
   HotKey,  g, MyEmpty, %enable%
   HotKey, *h, MyLeft,  %enable%
   HotKey, *i, MyHotKeyOff, %enable%
   HotKey, j, MyDown,   %enable%
   HotKey, k, MyUp,     %enable%
   HotKey, +j, MyPgDn,  %enable%
   HotKey, +k, MyPgUp,  %enable%
   HotKey, *l, MyRight, %enable%
   Hotkey, *m, MyApps,  %enable%
   HotKey, *n, MyPgDn,  %enable%
   HotKey, *o, MyEnd,   %enable%
   HotKey,  p, MyPaste, %enable%
   HotKey,  q, MyEmpty, %enable%
   HotKey,  r, MyEmpty, %enable%
   HotKey,  s, MyEmpty, %enable%
   HotKey,  t, MyEmpty, %enable%
   HotKey, *u, MyHome,  %enable%
   HotKey,  v, MyEmpty, %enable%
   HotKey,  w, MyWord,  %enable%
   HotKey,  x, MyDel,   %enable%
   Hotkey,  y, MyCopy,  %enable%
   HotKey,  z, MyEmpty, %enable%
   HotKey, *;, MyEnter, %enable%
   HotKey, *[, MyBS,    %enable%
   HotKey,  ], MyEmpty, %enable%
   HotKey,  ', MyEmpty, %enable%
   HotKey,  ., MyEmpty, %enable%
   HotKey,  /, MyEmpty, %enable%
   HotKey,  0, MyHome, %enable%
}

MyEmpty:
   Return
MyHotKeyOff:
   MyAppsKeyHotkeys("Off")
   Return
MyHotKeyOn:
   MyAppsKeyHotkeys("On")
   Return
MyUp:
   press_count += 1
   Send {Blind}{Up} ;fix for OneNote use SendPlay
   Return
MyDown:
   press_count += 1
   Send {Blind}{Down} ;fix for OneNote use SendPlay
   Return
MyLeft:
   press_count += 1
   Send {Blind}{Left}
   Return
MyRight:
   press_count += 1
   Send {Blind}{Right}
   Return
MyPgUp:
   press_count += 1
   Send {Blind}{PgUp}
   Return
MyPgDn:
   press_count += 1
   Send {Blind}{PgDn}
   Return
MyEnter:
   press_count += 1
   Send {Blind}{Enter}
   Return
MyBS:
   press_count += 1
   Send {Blind}{BS}
   Return
MyDel:
   press_count += 1
   Send {Blind}{Del}
   Return
MyHome:
   press_count += 1
   Send {Blind}{Home}
   Return
MyEnd:
   press_count += 1
   Send {Blind}{End}
   Return
MyApps:
   press_count += 1
   Send {Blind}{AppsKey}
   Return
MyEsc:
   press_count += 1
   Send {Esc}
   Return
MyCut:
   press_count += 1
   Send ^x
   Return
MyCopy:
   press_count += 1
   Send ^c
   Return
MyPaste:
   press_count += 1
   Send ^v
   MyAppsKeyHotkeys("Off")
   Return
MyWord:
   press_count += 1
   Send ^{Right}
   Return
MyBackWord:
   press_count += 1
   Send ^{Left}
   Return

SetCapsLockState, AlwaysOff

#IfWinNotActive ahk_exe Code.exe
CapsLock::HotkeyHook("Down")
CapsLock Up::HotkeyHook("Up")
ScrollLock::HotkeyHook("Down")
ScrollLock Up::HotkeyHook("Up")
#IfWinNotActive

IfWinActive, ahk_exe Code.exe
{ 
  q::MyAppsKeyHotkeys("Off")
}


HotkeyHook(Mode)
{
  Send {Blind}{Esc}
   static sticky_hotkeys = 0
   global press_count
   if (Mode = "Down")
   {
      if (sticky_hotkeys = 1)
      {
         sticky_hotkeys = 2
      }
      else
      {
         MyAppsKeyHotkeys("On")
         press_count = 0
      }
   }
   else if (Mode = "Up")
   {
      if (sticky_hotkeys = 0)
      {
         if (press_count = 0)
         {
            sticky_hotkeys = 1
         }
         else
         {
            MyAppsKeyHotkeys("Off")
         }
      }
      else if (sticky_hotkeys = 2)
      {
         MyAppsKeyHotkeys("Off")
         sticky_hotkeys = 0
      }
   }
}