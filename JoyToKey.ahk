#Persistent
#NoEnv
SetBatchLines -1
ListLines Off

; -------------------------------------------------------
;   JoyToKeys: convert joystick movement to key presses
;
; settings!
;  change these to fit your needs
;  default is for Cyborg V.1
; --------------------------

HatUp    := "Space"
HatDown  := "c"
HatLeft  := "a"
HatRight := "d"
XPlus    := "Right"
XMinus   := "Left"
YPlus    := "Up"
YMinus   := "Down"
RPlus    := "e"
RMinus   := "q"

Button1  := "LButton"
Button7  := "w" ;forward
Button2  := "l" ;lights
Button4  := "t" ;use
Button5  := "y" ;toggle power
Button6  := "p" ;lock landing legs

;comment in to test which button is which
;Loop, 32
; Button%a_index% := a_index

DeadZone    := 7   ; percent of axis deadzone
Coarseness  := 3   ; ms resolution of key dithering
SampleRate  := 1   ; ms between samples
JoystickNum := 1   ; if you have more than one Joystick, select the right one here

; YOU SHOULD NOT CHANGE ANYTHING PAST THIS POINT
; ==============================================

SetTimer, SampleJoyEvent, %SampleRate%
return

MakeKey(Key, DownMode = -1) {
  local Result
  if (DownMode == true)
    Result := "{" . Key . " down}"
  else if (DownMode == false)
    Result := "{" . Key . " up}"
  else
    Result := "{" . Key . "}"
  return Result
}

Update(Key, NewState, ByRef KeyState) {
  if (KeyState and not NewState) {
    SendEvent % MakeKey(Key, false)
    KeyState := false
  }
  if (not KeyState and NewState) {
    SendEvent % MakeKey(Key, true)
    KeyState := true
  }
}

Dither(Key, Rate, ByRef KeyState) {
  local TimeSet := Mod(A_TickCount, Coarseness)
  if (TimeSet < Rate * Coarseness) {
    Update(Key, true, KeyState)
  }
  if (TimeSet >= Rate * Coarseness) {
    Update(Key, false, KeyState)
  }
}

HatMode(Dir_) {
  local Dir := Floor(Dir_)
  Update(HatUp   , Dir==7 or Dir==0 or Dir==1, HatUpState   )
  Update(HatRight, Dir==1 or Dir==2 or Dir==3, HatRightState)
  Update(HatDown , Dir==3 or Dir==4 or Dir==5, HatDownState )
  Update(HatLeft , Dir==5 or Dir==6 or Dir==7, HatLeftState )
}

CheckHalfAxis(VarName, Value, Plus) {
  local Rate := 0
  local HighBegin = 50 + DeadZone
  local LowBegin = 50 - DeadZone
  if not %VarName% == "" {
    if Plus and Value >= HighBegin {
      Rate := (Value - HighBegin) / (100 - HighBegin)
    }
    if not Plus and Value <= LowBegin {
      Rate := (LowBegin - Value) / LowBegin
    }
    ;MsgBox % VarName . " [" . %VarName% . "] " . Plus . " " . Value . " rate " . Rate
    Dither(%VarName%, Rate, %VarName%State)
  }
}

CheckAxis(VarName, Value) {
  CheckHalfAxis(VarName . "Plus", Value, true)
  CheckHalfAxis(VarName . "Minus", value, false)
}

UpdateJoy() {
  local JoyX, JoyY, JoyZ, JoyR, JoyPOV
  GetKeyState, JoyX, %JoystickNum%JoyX
  GetKeyState, JoyY, %JoystickNum%JoyY
  GetKeyState, JoyZ, %JoystickNum%JoyZ
  GetKeyState, JoyR, %JoystickNum%JoyR
  GetKeyState, JoyPOV, %JoystickNum%JoyPOV
  
  CheckAxis("X", JoyX)
  CheckAxis("Y", JoyY)
  CheckAxis("Z", JoyZ)
  CheckAxis("R", JoyR)
  
  Loop, 32 {
    if Button%a_index% {
      local Joy
      GetKeyState, Joy, %JoystickNum%Joy%a_index%
      Update(Button%a_index%, Joy == "D", Joy%a_index%State)
    }
  }
  
  if (JoyPOV == -1)
    HatMode(-1)
  else
    HatMode(JoyPOV / 4500)
}

SampleJoyEvent:
UpdateJoy()
