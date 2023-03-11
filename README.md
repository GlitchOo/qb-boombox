# qb-boombox

This resource creates a usable boombox item.
Using the item places the object on the ground giving anyone near access to a menu to play music.
It accepts youtube urls, you can pause, resume, stop, and change the volume of the audio.<br>
Preview:<br>
https://medal.tv/games/gta-v/clips/4KeJhpohKXePa/JhzHWjffDVEZ?invite=cr-MSxxVlksMjQxMDUxMjgs
<br>

Requires:<br>
  [qb-core](https://github.com/qbcore-framework/qb-core)<br>
  [qb-menu](https://github.com/qbcore-framework/qb-menu)<br>
  [qb-input](https://github.com/qbcore-framework/qb-input)<br>
  [qb-inventory](https://github.com/qbcore-framework/qb-inventory)<br>
  [qb-target](https://github.com/qbcore-framework/qb-target)<br>
  [xsound](https://github.com/Xogy/xsound)<br>
<br>
Place the "html" folder in qb-inventory.<br>
Add the following to qb-core shared.lua in QBShared.Items;<br>
```
["boombox"] 			     	 = {["name"] = "boombox", 						["label"] = "Boombox", 					["weight"] = 5000, 		["type"] = "item", 		["image"] = "boombox.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Play some music anywhere."},
```
