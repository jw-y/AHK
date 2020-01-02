#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;$CapsLock::                                              		; Long press (> 0.5 sec) on * substitutes the dot multiply
;    KeyWait, CapsLock, T0.5                               	; Wait no more than 0.5 sec for key release (also suppress auto-repeat)
;    If ErrorLevel {                                    	; timeout, so long press
;        Send {Capslock}                               
;        ;KeyWait, CapsLock
;    } Else                                                	; otherwise...
;        Send {vk15sc138}                               
;Return

$CapsLock::
	KeyWait,CapsLock, T0.1
	
	if (ErrorLevel)
		Send {Capslock}

	else {
		Send {vk15sc138}
	}

	KeyWait, Capslock
Return