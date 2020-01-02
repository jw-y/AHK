#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

$Ins::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {k}
} 
IfWinActive ahk_class PotPlayer
{
   Send {Space}
} 
else 
{
   Send {Ins}
}
return

$NumpadEnter::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {f}
}
else
{
   Send {NumpadEnter}
}
return

$Numpad0::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {k}
}
else
{
   Send {Numpad0}
}
return

$Numpad1::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Return
}
else
{
   Send {Numpad1}
}
return

$Numpad2::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {Volume_Down}
}
else
{
   Send {Numpad2}
}
return

$Numpad3::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {PgDn}
}
else
{
   Send {Numpad3}
}
return

$Numpad4::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {j}
}
else
{
   Send {Numpad4}
}
return

$Numpad5::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   return
}
else
{
   Send {Numpad5}
}
return

$Numpad6::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {l}
}
else
{
   Send {Numpad6}
}
return

$Numpad7::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Return
}
else
{
   Send {Numpad7}
}
return

$Numpad8::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {Volume_Up}
}
else
{
   Send {Numpad8}
}
return

$Numpad9::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send {PgUp}
}
else
{
   Send {Numpad9}
}
return

$NumpadDiv::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send +,
}
else
{
   Send {NumpadDiv}
}
return

$NumpadMult::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send +.
}
else
{
   Send {NumpadMult}
}
return

$NumpadAdd::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send c
}
else
{
   Send {NumpadAdd}
}
return

$NumpadSub::
SetTitleMatchMode 2
IfWinActive - YouTube
{
   Send, {F6}
   Sleep, 50
   Send, youtube.com
   Send, {Enter}
}
else
{
   Send {NumpadSub}
}
return

;SetTitleMatchMode 2
;IfWinActive - YouTube || ahk_class PotPlayer
;{
;   Ins::Send {Space}
;} 