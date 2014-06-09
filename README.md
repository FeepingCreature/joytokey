JoyToKey
========
JoyToKey is a script for AutoHotKey to translate Joystick movement to keypresses.

Joystick movements are dithered so that "slight Joystick movement" is translated to
"short keypresses" and "strong movement" is translated to "long keypresses".

Usage
-----

1. Install a current version of [AutoHotKey](http://www.autohotkey.com/).
2. Download the script file ([JoyToKey.ahk](https://raw.githubusercontent.com/FeepingCreature/joytokey/master/JoyToKey.ahk)) and save it somewhere convenient, like your desktop or My Documents.
3. Open the script in AutoHotKey by double-clicking on it. If the script is operating correctly, moving your Joystick slightly should move the cursor.
4. To change settings, right-click on the green "H" in the System Tray (bottom right) and select "Edit This Script".
  * To reload your changes, save the file in Notepad, right-click on "H" and select "Reload This Script".
5. To close JoyToKey, right-click on "H" and select "Exit" or "Pause Script".

If there is a problem with repeated text inputs, please create an issue about
it on Github. Don't forget to give your type of Joystick.

Configuration
-------------

To disable a line, comment it out by placing a semicolon at the front.

    ;This line is commented out.
	This line is not.

The names of keys can be found in the [AutoHotKey help](http://www.autohotkey.com/docs/KeyList.htm).

The Hat* settings (HatUp, HatRight..) bind keys to the Hat or Point-Of-View switch on your Joystick.
It is usually found at the top of your Joystick and used to adjust the camera.

XPlus/XMinus binds keys to the Joystick's X axis (Right/Left, respectively).

YPlus/YMinus binds keys to the Y Axis (Down/Up).

RPlus/RMinus are the Joystick's rotation axis.

The Joystick buttons are numbered. To find which buttons correspond to which number,
uncomment the two test lines beneath the Button section. Then reload the script. At this
point, pressing a button should insert the button's number as text. Add their bindings as
desired. When you're done, remember to comment the test lines again!

DeadZone: the percent of Joystick axis that is ignored when determining movement. Increase this if
you get spurious movement. Decrease it if you want more reactive controls.

Coarseness: the timestep of key dithering; that is, turning keys on and off to simulate strength.
This may require adjustment depending on the game. Play with what works best. It is not recommended
to raise this above 50ms.

SampleRate: how often the script checks the status of the Joystick. Should not require changing.

JoystickNum: the index of the Joystick used. If you have multiple Joysticks, and the script uses
the wrong one, try to set this to a different number.
