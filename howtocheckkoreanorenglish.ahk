#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


IME_CHECK(WinTitle)
{
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}


Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{
    DetectSave := A_DetectHiddenWindows       
    DetectHiddenWindows,ON                           


     SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
    if (DetectSave <> A_DetectHiddenWindows)
        DetectHiddenWindows,%DetectSave%
    return ErrorLevel
}


ImmGetDefaultIMEWnd(hWnd)
{
    return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}


;#+x::
;Run chrome.exe
;;WinActivate, ahk_exe chrome.exe
;sleep 200

;ret := IME_CHECK("A")
;if %ret% != 0                ; 0 means IME is in English mode now.
;{
;	Send, {vk15sc138}       ; Turn IME into Hangul(Korean) mode.
;}

;Send en.oxforddictionaries.com
;Send {Enter}
;return



#+y::
Run chrome.exe
;WinActivate, ahk_exe chrome.exe
sleep 200

ret := IME_CHECK("A")
if %ret% != 0                ; 0 means IME is in English mode now.
{
	Send, {vk15sc138}       ; Turn IME into Hangul(Korean) mode.
}

Send youtube.com
Send {Enter}
return



#+f::
Run chrome.exe
;WinActivate, ahk_exe chrome.exe
sleep 200

ret := IME_CHECK("A")
if %ret% != 0                ; 0 means IME is in English mode now.
{
	Send, {vk15sc138}       ; Turn IME into Hangul(Korean) mode.
}

Send facebook.com
Send {Enter}
return



#+d::
Run chrome.exe
;WinActivate, ahk_exe chrome.exe
sleep 200

ret := IME_CHECK("A")
if %ret% != 0                ; 0 means IME is in English mode now.
{
	Send, {vk15sc138}       ; Turn IME into Hangul(Korean) mode.
}

Send https://drive.google.com/drive/my-drive
Send {Enter}
return
