# Brass Trimmer Adapters

These adapters allow to make DIY brass trimmers from routers for a fracture of the price of specialized brass trimmers.

Currently supported router models:

* Makita RT0701C 1-1/4 hp Compact Router
* DRILL MASTER 2 hp Fixed Base Router

You will also need:

* 3/8" collet (only when using Makita router, part #763619-3)
* 3/8" boring bar with indexable carbide inserts, 3.75" long or more for Makita, 2.5" long for DRILL MASTER
* 13/16"-20 trim dies made by Dillon, Lyman, Whidden, etc; one per caliber
* 13/16"-20 nut (comes with Lyman dies, can also be found at automotive stores, they are thread axle nuts); one per caliber
* 4 M4x16 bolts (Makita) or 2 M5x25 bolts (DRILL MASTER)

And one-time requirements:

* OpenSCAD
* Cura or other slicing software
* 3D printer, PLA+ filament

## Basic instructions

1. Decide what type of router you prefer. DRILL MASTER is cheaper and comes with a 3/8" collet, but it's a fixed speed router, it's loud, and it's massive. Makita is slightly more expensive, requires an additional 3/8" collet sold separately, but it's more compact and has variable speeds. At lower speeds, it's much quieter. It also allows to move the base up and down. But it also vibrates more because it's lighter.

2. Remove the base from your router. 

3. Measure your boring bar and trim it if necessary.
 
   For Makita: The optimal length is 2.75" below the base of the router. That would make a 3.75" or a 4" bar a perfect fit. The least expensive options on the market are 6" long boring bars, but while they will work, it's better to have them trimmed to 3.75" or 4" to decrease vibration and make more compact adapters. Don't trim your bars less than 3.75", but if it's shorter, you can use "short_threads" set to 1 to make a shorter adapter. 2.8" is the shortest you could go. Shorter bar means less vibration.

   For DRILL MASTER: Your boring bar should be at least 2.5" long. Again, shorter bar means less vibration.

4. (Optional) Use OpenSCAD to generate two models, one with "is_body_only" set to 0, another set to 1. Or download pre-rendered ones. 

5. Use slicing software to combine full and body-only models. Set body-only model infill higher and keep additional walls. Trimming involves a significant force and you'll need additional reinforcements.

6. Print your model using PLA+ or other strong filament materials.

7. Insert the boring bar into the router and make sure it's affixed tight.

8. Attach the printed adapter to the base of the router using bolts.

9. Install the trim die in your toolhead as you would install a sizing die. Remember to lubricate your brass when adjusting the position.

10. Put a 13/16"-20 nut and screw it all the way down.

11. Put adapter with the router on top of the trim die and screw it down until the carbide insert touches the brass.

12. Screw the 13/16"-20 nut all way up but don't tighten it.

13. Plug the router in, turn it on, and trim the brass.

14. Measure the trimmed brass length. If it's longer than desired, slightly turn the adapter more to move it down. Repeat until the desired trimming length is achieved.

15. Screw tight the 13/16"-20 nut to prevent adapter from rotating.


If you have multiple trim dies for different calibers, remove the router from adapter/die/toolhead combo, and repeat steps 6 - 15 for each caliber.

It's very advisable to use one adapter per caliber and just share the router.

## License AKA **You cannot sell it**

This project is released under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) License. What it means to you in just four words?

***You cannot sell it***

You can share and adapt it freely. I cannot revoke these freedoms as long as you follow the license terms, specifically:

* Attribution - you must give appropriate credit
* Non-Commercial - you cannot profit from it
* ShareAlike - if you change something, you must use the same license terms

Full license text can be found at https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode

Copyright (c) 2021 sttek.com

## Trademarks

Dillon is a registered trademark of Dillon Precision Products, Inc.
DRILL MASTER is a registered trademark of Harbor Freight Tools USA, Inc.
Lyman is a registered trademark of Lyman Products Corporation.
Makita is a registered trade mark of Makita USA, Inc.
