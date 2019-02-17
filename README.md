# solarMonitor
A solar system themed Conky system display. Takes up a lot of screen space, best for 4k or multiple monitors


Tested on Xubuntu 18 LTS
Requires: Conky-all, Cairo, Lua

Install: Copy conky.conf to your user ./config/conky/ folder. Copy script.lua to ./config/conky/lua/Solar/ folder.
If nothing appears on screen after installing and running conky, adjust the screen settings in conky.conf. This
was made on 4 screens in a 2x2 setup and was configured to output to the top right screen, so offsets may need adjusted.

Configuration:
SolarMap variable in script.lua will control if the position of the planets is calculated based on the system clock,
if this is turned off, the planets will just be drawn at a default position and will not move.
SolarMap will also turn the asteroid belt on or off.
