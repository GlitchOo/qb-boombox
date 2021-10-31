# qb-boombox

This resource creates a usable boombox item.
Using the item places the object on the ground giving anyone near access to a menu to play music.
It accepts youtube urls, you can pause, resume, stop, and change the volume of the audio.

Requires:
  [qb-core](https://github.com/qbcore-framework/qb-core)
  [qb-inventory](https://github.com/qbcore-framework/qb-inventory)
  [xsound](https://github.com/Xogy/xsound)

Place the "html" folder in qb-inventory.
Add the following to qb-core shared.lua in QBShared.Items;
```
["boombox"] 			     	 = {["name"] = "boombox", 						["label"] = "Boombox", 					["weight"] = 5000, 		["type"] = "item", 		["image"] = "boombox.png", 				["unique"] = true, 		["useable"] = true, 	["shouldClose"] = true,	   ["combinable"] = nil,   ["description"] = "Play some music anywhere."},
```
