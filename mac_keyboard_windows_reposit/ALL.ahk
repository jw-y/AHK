#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include youtube_numpad_control.ahk

; media control

#F7::Media_Prev
#F8::Media_Play_Pause
#F9::Media_Next

#F10::Volume_Mute

#F11::Volume_Down
#F12::Volume_Up

#Numpad3::^NumpadPgDn
#Numpad1::^NumpadPgUp

-------------------------
; do not use delete when Kakaotalk is open

$Delete::
SetTitleMatchMode 2
IfWinActive 카카오톡
{
   return
}
else
{
   Send {Delete}
}
return


---------------------------
^!#+Esc::
   Shutdown 1
   Return

---------------------------

; win + shift + 3 rectangular snipping tool
; win + shift + 4 full window snip


#+3::
SetTitleMatchMode 2
IfWinExist SnippingTool.exe
{ 
   WinActivate SnippingTool.exe
}   
else
{
   Run, SnippingTool.exe
}
   sleep 300
   Send !m
   sleep 10
   Send {down}
   Send {down}
   Send {Enter}
   Return
   
#+4::
SetTitleMatchMode 2
IfWinExist SnippingTool.exe
{ 
   WinActivate SnippingTool.exe
}   
else
{
   Run, SnippingTool.exe
}
   sleep 300
   Send !m
   sleep 10
   Send {up}
   sleep 10
   Send {Enter}
   Return

------------------------------


!3::
   Send ♥
   Return

--------------------------

#s::
   Send ^s
   Return

#b::
   Send ^b
   Return

-------------------------

;#LButton::
;   Send ^{LButton}
;   Return

#LButton::
  Send {ctrl Down}
  Send {LButton Down}
  Return

#LButton Up::
  Send {LButton Up}
  Send {ctrl Up}
  Return

-------------------------

#w::
  Send {ctrl Down}
  Send {w Down}
  Return

#w Up::
  Send {w Up}
  Send {ctrl Up}
  Return
-------------------------

#t::
   Send ^t
   Return

-----------------------

#+t::
   Send ^+t
   Return

------------------------

#f::
  Send {ctrl Down}
  Send {f Down}
  Return

#f Up::
  Send {f Up}
  Send {ctrl Up}
  Return

-------------------------

#c::
  Send {ctrl Down}
  Send {c Down}
  Return

#c Up::
  Send {c Up}
  Send {ctrl Up}
  Return

-------------------------

#v::
  Send {ctrl Down}
  Send {v Down}
  Return

#v Up::
  Send {v Up}
  Send {ctrl Up}
  Return


-------------------------

#x::
  Send {ctrl Down}
  Send {x Down}
  Return

#x Up::
  Send {x Up}
  Send {ctrl Up}
  Return
-------------------------

#z::
  Send {ctrl Down}
  Send {z Down}
  Return

#z Up::
  Send {z Up}
  Send {ctrl Up}
  Return

------------------------

; win + shift + {alpha}
; opens webpages

#+x::
   Run chrome.exe
   WinWait, ahk_exe chrome.exe, , 3
   Run, https://en.oxforddictionaries.com
Return

#+y::
   Run chrome.exe
   WinWait, ahk_exe chrome.exe, , 3
   Run, https://youtube.com
Return

#+d::
   Run chrome.exe
   WinWait, ahk_exe chrome.exe, , 3
   Run, https://drive.google.com/drive/my-drive
Return

#+c::
   Run chrome.exe
   WinWait, ahk_exe chrome.exe, , 3
   Run, https://yscec.yonsei.ac.kr/my/
Return
