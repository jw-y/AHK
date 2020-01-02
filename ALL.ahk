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
/*
$w::
If GetKeyState("CapsLock","p")
 Send {Up Down} ;press down the up key
else
 Send w
Return
w Up::Send {Up Up} ;on w releace, releace the up key

$a::
If GetKeyState("CapsLock","p")
 Send {Left Down} ;press down the up key
else
 Send a
Return
a Up::Send {Left Up} ;on w releace, releace the up key

$s::
If GetKeyState("CapsLock","p")
 Send {Down Down} ;press down the up key
else
 Send s
Return
s Up::Send {Down Up} ;on w releace, releace the up key

$d::
If GetKeyState("CapsLock","p")
 Send {Right Down} ;press down the up key
else
 Send d
Return
d Up::Send {Right Up} ;on w releace, releace the up key

*/
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

; win + shift + 3 full window snip
; win + shift + 4 rectangular snipping tool

#+3::
SetTitleMatchMode 2
IfWinExist Snip & Sketch
{ 
   Send {PrintScreen}      
   ;WinActivate Snip & Sketch
}          
else
{
   Send {PrintScreen}
   ;Run, ApplicationFrameHost.exes
}
   ;sleep 300
   ;Send !n
   sleep 700
   Send {tab}
   Send {tab}
   Send {tab}
   Send {Space}
   Return


#+4::
SetTitleMatchMode 2
IfWinExist Snip & Sketch
{ 
   Send {PrintScreen}
  ;WinActivate Snip & Sketch
}   
else
{
   Send {PrintScreen}
   ;Run, ApplicationFrameHost.exes
}
   ;sleep 300
   ;Send !n
   ;sleep 10
   ;Send {down}
   ;Send {down}
   ;Send {Enter}
   ;sleep 10
   ;Send !n
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


LShift & LButton::
SetTitleMatchMode 2
IfWinActive, ahk_exe chrome.exe
{
    Send {ctrl Down}
    Send {LButton Down}
    Return
}
else{
    Send {LShift Down}
    Send {LButton Down}
    Return
}

LShift & LButton Up::
SetTitleMatchMode 2
IfWinActive, ahk_exe chrome.exe
{
    Send {LButton Up}
    Send {ctrl Up}
    Return
}
else{
    Send {LButton Up}
    Send {LShift Up}
    Return
}


;  LShift & LButton::
;    Send {ctrl Down}
;    Send {LButton Down}
;    Return

;  LShift & LButton Up::
;    Send {LButton Up}
;    Send {ctrl Up}
;    Return
 
;F24 & LButton::
;  Send {ctrl Down}
;  Send {LButton Down}
;  Return

;F24 & LButton Up::
;  Send {LButton Up}
;  Send {ctrl Up}
;  Return
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

^+v::
  Send {lwin Down}
  Send {v Down}
  Return

^+v Up::
  Send {lwin Up}
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

#BackSpace::
SetTitleMatchMode 2
IfWinActive 카카오톡
{
   Send {BackSpace}
}
else
{
   Send {Delete}
}
return
------------------------

;F2::
;SetTitleMatchMode 2
;IfWinActive ahk_exe chrome.exe
;{
;   Send {ctrl Down}
;   Send {w Down}
;   Send {w Up}
;   Send {ctrl Up}
;}
;else
;{
;   Send {F2}
;}
;return

F4::
SetTitleMatchMode 2
IfWinActive ahk_exe chrome.exe
{
   Send {alt Down}
   Send {F4 Down}
   Send {F4 Up}
   Send {alt Up}
}
else
{
   Send {F4}
}
return


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

#+f::
   Run D:\Music\foobar2000_v1.4\foobar2000.exe
Return