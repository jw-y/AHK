;
; Apple Wireless Keyboard Eject Key and Function kKey remapper for Windows.
; You can get the latest version of this file at:
; https://gist.github.com/TheZoc/a913642e9bedf62ba3ef
;
;==========================================================================================================================================
; Please, if you make a significant change, fix or would like to improve this script,
; I'd really appreciate if you can contact me so we can merge both works :)
;==========================================================================================================================================
;
; This is a havily modified version of the script:
; https://gist.github.com/anonymous/4294405
;
; This is a "hack" of the original script with was updated to support 64 bits Windows.
; With a file compare tool, it's easy to update the original script, if you prefer it's remaps.
;
; Changes from the original script:
; - Windows x64 support.
; - Eject key changed to take screenshots to <user>/Pictures/Screenshots
; - Added a "bootcampWindows" config variable, so users in bootcamp can disable some remappings (System volume changes) - untested.
; - Disabled fn key + arrow key remapping
; - Disabled F12 to Insert Key remapping
; - Disabled swapping of the fn key and left Ctrl key.
;
;==========================================================================================================================================
; Original script header follows
;==========================================================================================================================================
;
; AutoHotkey Version: 1.x
; Language.........: English
; Platform.........: NT/XP/Vista
; Author...........: mrBTK
;
; Script Function..: Make Apple Wireless Keyboard useful in MS Windows: 
;    - EJECT = Delete with repeat deleting on long pressing. Shift-DEL and other combinations works too.
;    - Swap FN & left Control 
;    - FN-functions оn F3-F12 keys and arrow keys (use new-FN)
;    - FN+EJECT = drive eject
;    - F12 = INSERT (on your need, it simple to delete this feature: find in script "switch F12 to Insert" and delete the command)
;    - AWK POWER button toggle script suspending. Place in script directory two any sound files "on.wav" & "off.wav" for notification
;
; Based on.........: DLLCall: Support for Human Interface devices: some keymapping code
; By...............: Micha
; URL..............: http://www.autohotkey.com/forum/viewtopic.php?t=6367
; Based on.........: HID/Extended input devices (MS Natural Keyboard 4000 etc.): HID operations code
; By...............: Shaun 
; URL..............: http://www.autohotkey.com/board/topic/36304-hidextended-input-devices-ms-natural-keyboard-4000-etc/
;
; Use..............: Spread the word! Just be sure to credit the writer of the original config
;                    and the authors of this file.
;

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#MaxHotkeysPerInterval 1000
#SingleInstance force ; Replace any previous instance 

DetectHiddenWindows, on
OnMessage(0x00FF, "InputMessage")

SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
;#NoTrayIcon

; Set screen title, to set the HWND
Gui, Show, x0 y0 h0 w0, AppleWKHelper
HWND := WinExist("AppleWKHelper")

hidMessage := 0
isSuspend := 0

; Variable for the modifier key
fnPressed := 0
fnPrevState := 0
ejPressed := 0
ejPrevState := 0
pwrPressed := 0
pwrPrevState := 0

; Variable for Fn <> Lctrl
lctrlPressed := 0
lctrlPrevState := 0

; set this to 0 if you're not running windows on Bootcamp (aka: Normal PC)
bootcampWindows := 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; handle HID input, set global vars, call modKeysProcessing

; List all of the "Raw Input" devices available for use and allow 
; capture of output 
; 
; There may be more than one 'raw' device per device actually attached 
; to the system. This is because these devices generally represent 
; "HID Collections", and there may be more than one HID collection per 
; USB device. For example, the Natural Keyboard 4000 supports a normal
; keyboard HID collection, plus an additional HID collection that can 
; be used for the zoom slider and other important buttons

SizeofRawInputDeviceList	:= A_PtrSize * 2
SizeofRawInputDevice		:= 8 + A_PtrSize

RIM_TYPEMOUSE				:= 0
RIM_TYPEKEYBOARD			:= 1
RIM_TYPEHID					:= 2

RIDI_DEVICENAME				:= 0x20000007
RIDI_DEVICEINFO				:= 0x2000000b

RIDEV_INPUTSINK				:= 0x00000100

RID_INPUT					:= 0x10000003

DoCapture					:= 0


;;get count of HID devices
Res := DllCall("GetRawInputDeviceList", "Ptr", 0, "UInt*", Count, UInt, SizeofRawInputDeviceList)
VarSetCapacity(RawInputList, SizeofRawInputDeviceList * Count)

;;get list of HID devices
Res := DllCall("GetRawInputDeviceList", "Ptr", &RawInputList, "UInt*", Count, "UInt", SizeofRawInputDeviceList)

rimHIDregistered := 0

Loop %Count% { ;for all HID devices
	Handle := NumGet(RawInputList, (A_Index - 1) * SizeofRawInputDeviceList, "UInt")
	Type := NumGet(RawInputList, ((A_Index - 1) * SizeofRawInputDeviceList) + A_PtrSize, "UInt")
	if (Type = RIM_TYPEMOUSE)
		TypeName := "RIM_TYPEMOUSE"
	else if (Type = RIM_TYPEKEYBOARD)
		TypeName := "RIM_TYPEKEYBOARD"
	else if (Type = RIM_TYPEHID)
		TypeName := "RIM_TYPEHID"
	else
		TypeName := "RIM_OTHER"

;; get HID device name length  
	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Ptr", 0, "UInt *", nLength)
	VarSetCapacity(Name, (nLength + 1) * 2)
;; get HID device name
	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Str", Name, "UInt*", nLength)

; get HID device info   
	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "Ptr", 0, "UInt *", iLength)
	VarSetCapacity(Info, iLength)
	NumPut(iLength, Info, 0, "UInt") ;Put length in struct RIDI_DEVICEINFO
	
	Res := DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "UInt", &Info, "UInt *", iLength)

; Keyboards are always Usage 6, Usage Page 1, Mice are Usage 2, Usage Page 1, 
; HID devices specify their top level collection in the info block


; AWK modifier buttons is separate TYPEHID (rather keyboard standard buttons)
	if (Type = RIM_TYPEHID)
	{
		Vendor := NumGet(Info, 4 * 2, "UShort")
		Product := NumGet(Info, 4 * 3, "UShort")
		Version := NumGet(Info, 4 * 4, "UShort")
		UsagePage := NumGet(Info, (4 * 5), "UShort")
		Usage := NumGet(Info, (4 * 5) + 2, "UShort")
	}

	VarSetCapacity(RawDevice, SizeofRawInputDevice, 0)
	NumPut(RIDEV_INPUTSINK, RawDevice, 4)
	NumPut(HWND, RawDevice, 8)

	if (Type = RIM_TYPEHID && Vendor = 1452  && rimHIDregistered = 0) ; AWK Vendor number
	{
		rimHIDregistered := 1
		NumPut(UsagePage, RawDevice, 0, "UShort")
		NumPut(Usage, RawDevice, 2, "UShort")	  
;; Register AWK modifier buttons HID
		Res := DllCall("RegisterRawInputDevices", "UInt", &RawDevice, UInt, 1, UInt, SizeofRawInputDevice) 
		if (Res = 0) {
			MsgBox, Failed to register for AWK device!
		ExitApp
	}
	}
}

Count := 1 

InputMessage(wParam, lParam, msg, hwnd)
{
	global hidMessage   
	global isSuspend
	global RIM_TYPEMOUSE, RIM_TYPEKEYBOARD, RIM_TYPEHID 
	global RID_INPUT 

; get HID input
	Res := DllCall("GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", 0, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
	VarSetCapacity(Buffer, Size)
	Res := DllCall("GetRawInputData", "UInt", lParam, "UInt", RID_INPUT, "Ptr", &Buffer, "UInt *", Size, "UInt", 8 + A_PtrSize * 2)
   
	Type := NumGet(Buffer, 0, "UInt")


	if (Type = RIM_TYPEHID)
	{
		SizeHid := NumGet(Buffer, (8+A_PtrSize*2), "UInt")
		InputCount := NumGet(Buffer, (12+A_PtrSize*2), "UInt")
		Loop %InputCount% {
			Addr := &Buffer + (16+A_PtrSize*2) + ((A_Index - 1) * SizeHid)
			hidMessage := Mem2Hex(Addr, SizeHid)
			ProcessHIDData(wParam, lParam)
		}
	}
	return
} ; END: InputMessage

Mem2Hex( pointer, len )
{
	multiply := 0x100
	Hex := 0
	Loop, %len%  {
		Hex := Hex * multiply
		Hex := Hex + *Pointer+0
		Pointer ++
	}
	Return Hex 
} ; END: Mem2Hex

ProcessHIDData(wParam, lParam)   ; set global vars for further handling
{
  	global hidMessage
	global isSuspend
	
	global fnPressed
	global fnPrevState
	global ejPressed
	global ejPrevState
	global pwrPressed
	global pwrPrevState

;	SetTimer, SendDelete, Off			

; Filter bit 5 (Fn key)
	Transform, FnValue, BitAnd, 0xFF10, hidMessage

	if (FnValue = 0x1110) {
		; Fn is pressed
		fnPrevState := fnPressed
		fnPressed := 1
	} else {
		; Fn is released
		fnPrevState := fnPressed
		fnPressed := 0
	}

; Filter bit 4 (Eject key)
  Transform, FnValue, BitAnd, 0xFF08, hidMessage
  
	if (FnValue = 0x1108) {
		; Eject is pressed
		ejPrevState := ejPressed
		ejPressed := 1
	} else {
		; Eject is Released
		ejPrevState := ejPressed
		ejPressed := 0
	}

; Filter bit 1 fnd 2 (Power key)
	Transform, FnValue, BitAnd, 0xFF03, hidMessage
	if (FnValue = 0x1303) { ; Power is pressed
		pwrPrevState := 0
		pwrPressed := 1
	; Toggle Suspend of this script.
	chkSuspend() 
	}
	if (fnValue = 0x1302) { 	
		; Power is released
		pwrPrevState := 1
		pwrPressed := 0
	; no anything doing оn power button release
	}
  
  if (isSuspend = 0)
	modKeysProcessing()

} ; END: ProcessHIDData

modKeysProcessing() { ; handle keypressing for modifier keys
  global fnPressed
  global ejPressed
  global ejPrevState
  global fnPrevState

  global lctrlPressed
  global lctrlPrevState

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eject = delete with delay and repeat
;  if (lctrlPressed = 0) {               		; eject only pressed
;     if (ejPressed = 1 and ejPrevState = 0) {  	; eject down
;	    if  (GetKeyState("Shift") or GetKeyState("Alt") or GetKeyState("Control")) {
;           SendInput {Blind}{Delete}                      ; Edit::Cut and other w|o repeating
;	    } else if (fnPressed = 1) {
;			SendInput {Ctrl}{Delete}                      ; ctrl - del 
;		} else {										  ; No modifiers = Del with repeating
;		  SendInput {Delete}
;		  SetTimer, SendDelete, -800           		      ; Delay for start repeating
;	   }
;    }
;  }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fn = rCtrl
;  if (ejPressed = 0) {                       	; fn only pressed
;     if (fnPressed = 1 and fnPrevState = 0)     ; fn down
;        SendInput {rCtrl Down}
;
;     if (fnPressed = 0 and fnPrevState = 1)     ; fn up
; 	    SendInput {rCtrl Up}
;  }
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lctrl + Eject Up = optical drive eject
;  if (lctrlPressed = 1 and ejPressed = 0 and ejPrevState = 1 and fnPressed = 0) 
;	Drive, Eject

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Eject Up = Save screenshot to <user>/Pictures/Screenshots
	if (lctrlPressed = 0 and ejPressed = 0 and ejPrevState = 1 and fnPressed = 0) 
		SendInput #{PrintScreen}

} ; END: modKeysProcessing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Send Delete keystroke repeatedly while Eject still pressed
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;SendDelete:
;	; repeating del while Eject still down
;	if (ejPressed = 1) {
;		SendInput {delete}
;		SetTimer, SendDelete, -40			
;}
;Return

chkSuspend() {
	
	global fnPressed
	global fnPrevState
	global ejPressed
	global ejPrevState
	global lctrlPressed
	global lctrlPrevState
	global pwrPressed
	global pwrPrevState
	global isSuspend	
	
	if (isSuspend = 0) {
		isSuspend := 1
		
		fnPressed := 0
		fnPrevState := 0
		ejPressed := 0
		ejPrevState := 0
		pwrPressed := 0
		pwrPrevState := 0
		lctrlPressed := 0
		lctrlPrevState := 0
		
		Suspend , On
;		SetTimer, SendDelete, Off			
		SendInput {rCtrl Up}
		TrayTip, AWK Helper, Suspended, 1, 1
		Soundplay , off.wav		
	} else {
		isSuspend := 0
		Suspend , Off
		TrayTip, AWK Helper, Restored, 1, 1
		Soundplay , on.wav	
	}	
} ; END: chkSuspend

; switch F12 to Insert
;*F12::sendInput {Blind}{Insert}

;
; lctrl = fn
; get up and down Lcontrol, sets global variables
;
$*lControl up::LCtrlUp()

LCtrlUp() {

  global lctrlPressed
  global lctrlPrevState

  lctrlPrevState := 1
  lctrlPressed := 0

  SendInput {LCtrl up}
}
Return

$*lControl::LCtrlDn()

LCtrlDn() {

  global lctrlPressed
  global lctrlPrevState

  lctrlPrevState := 0
  lctrlPressed := 1
  
;  SetTimer, SendDelete, Off			

  SendInput {LCtrl down}
}
Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: PrintScreen, Task Manager
; lctrl uses as fn
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; fn+alt F3 = PrtScr for Active Window
;
$!F3::hotkeyAltF3()

hotkeyAltF3() {
	global ejPressed
	global fnPressed

	if(fnPressed = 1 and ejPressed = 0) 
		SendInput !{PrintScreen}
	else 
		SendInput !{F3}
}
Return

;
; fn+F3 = PrtScr
;
$F3::hotkeyF3()

hotkeyF3() {
	global ejPressed
	global fnPressed

	if(fnPressed = 1 and ejPressed = 0)
		SendInput {PrintScreen}
	else
		SendInput {F3}
}
Return

;
; fn+F4 = Run TM
;
$F4::hotkeyF4()

hotkeyF4() {
	global ejPressed
	global fnPressed

	if(fnPressed = 1 and ejPressed = 0)
        SendInput +^{Esc}
	else
		SendInput {F4}
}
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Audio hotkeys, specified for WMP
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Zoc: Disabled, I don't use WMP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; WinMPlayer: Previous
;
;$F7::hotkeyF7()
;
;hotkeyF7() {
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0)
;		SendInput {Media_Prev}  ; Previous
;	else
;		SendInput {F7}
;}
;Return

;
; WinMPlayer: Pause/Unpause
;
;$F8::hotkeyF8()
;
;hotkeyF8() {
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0)
;		SendInput {Media_Play_Pause} ; Pause/Unpause
;	else
;		SendInput {F8}
;}
;Return

;
; WinMPlayer: Next
;
;$F9::hotkeyF9()
;
;hotkeyF9()
;{
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and and ejPressed = 0)
;		SendInput {Media_Next} ; Next
;	else
;		SendInput {F9}
;}
;Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Audio hotkeys, system volume
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if (bootcampWindows = 0)
{
	;
	; System volume: Mute/Unmute
	;
	$F10::hotkeyF10()

	hotkeyF10() {
		global ejPressed
		global fnPressed

		if(fnPressed = 1 and ejPressed = 0)
			SendInput {Volume_Mute} ; Mute/unmute the master volume.
		else
			SendInput {F10}
	}
	Return

	;
	; System volume: Volume Down
	;
	$F11::hotkeyF11()

	hotkeyF11() {
		global ejPressed
		global fnPressed

		if(fnPressed = 1 and ejPressed = 0)
			SendInput {Volume_Down} ; Lower the master volume by 1 interval (typically 5%)
		else
			SendInput {F11}
	}
	Return

	;
	; System volume: Volume Down
	;
	$F12::hotkeyF12()

	hotkeyF12() {
		global ejPressed
		global fnPressed

		if(fnPressed = 1 and ejPressed = 0)
			SendInput {Volume_Up}  ; Raise the master volume by 1 interval (typically 5%).
		else
			SendInput {F12}
	}
	Return
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fn modifier: Arrow keys
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Zoc: Disabled, I don't like this function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Page Up
;;
;$UP::hotkeyPgUp()
;
;hotkeyPgUp() {
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0) {
;		if (GetKeyState("Shift"))
;			SendInput {rCtrl Up}+{PgUp}
;		else
;			SendInput {rCtrl Up}{PgUp}
;	} else
;		SendInput {UP}
;}
;Return
;
;;
;; Page Down
;;
;$Down::hotkeyPgDn()
;
;hotkeyPgDn() {
;	global fnPressed
;	global ejPressed
;	global ejPrevState
;	global fnPrevState
;
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0)
;		SendInput {rCtrl Up}{PgDn}
;	else
;		SendInput {Down}
;}
;Return
;
;;
;; Home
;;
;$Left::hotkeyHome()
;
;hotkeyHome() {
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0)
;		SendInput {rCtrl Up}{Home}
;	else
;		SendInput {Left}
;}
;Return
;
;;
;; End
;;
;$Right::hotkeyEnd()
;
;hotkeyEnd() {
;	global ejPressed
;	global fnPressed
;
;	if(fnPressed = 1 and ejPressed = 0)
;		SendInput {rCtrl Up}{End}
;	else
;		SendInput {Right}
;}
;Return