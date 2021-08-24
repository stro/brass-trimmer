/*
 * Copyright (c) 2021 sttek.com <https://sttek.com>
 *
 * This work is licensed under a Creative Commons Attribution-NonCommercial
 * 4.0 International License.
 *
 * https://creativecommons.org/licenses/by-nc/4.0/
 * 
 * You are free to:
 *   Share — copy and redistribute the material in any medium or format
 *   Adapt — remix, transform, and build upon the material
 * Under the following terms:
 *   Attribution — You must give appropriate credit, provide a link to the
 *     license, and indicate if changes were made. You may do so in any
 *     reasonable manner, but not in any way that suggests the licensor
 *     endorses you or your use.
 *   NonCommercial — You may not use the material for commercial purposes. 
 *   No additional restrictions — You may not apply legal terms or
 *     technological measures that legally restrict others from doing anything
 *     the license permits.
 */

// total length of the boring bar with a bit attached in millimeters
bar_length = 95.25; // in mm; 3.75" boring bar

// set "is_body_only" if you want to generate the main tube which you can print
// with higher density as described in documentation
is_body_only = 0;

// router model.
//   "makita" : Makita RT0701C 1 1/4 hp router
//   "dm2hp"  : DRILL MASTER 2 hp router
router_type = "makita";

// set to 1 if you want a shorter adapter, for example, if you're using a thick
// 13/16" nut or your boring bar is really short. Drill Master 2hp adapter should
// use "short_threads" set to 1 if you're using a 2.5" boring bar.
short_threads = 0;

// if you set it to 1, threads would be a little tighter so the router won't
// turn the adapter when starting as easily. A downside, you must not share
// one adapter among multiple dies because threads will get destroyed. 
tight_threads = 1;

// You can use "additional_height" parameter to adjust the final length of the
// adapter if default calculations don't work for you for some reason. Negative
// to shorten, positive to elongate.

// For example, Makita router allows to raise the lower level by 20mm so you
// can specify "additional_height = -20" and save some filament
additional_height = 0; // in mm

/*****************************************************************************
 * NO SERVICEABLE PARTS BELOW. ENTER AT YOUR OWN RISK
 ****************************************************************************/

mm_in_in = 25.4;
fn = 120; // slower rendering once, nicer look every day
threads_size = 13 / 16 * mm_in_in; // 20.6375mm
threads_length = short_threads ? threads_size * 0.5 : threads_size; // not less than the length of threads on the trim die
max_bar = 14; // how long the bar extends below the threads. May depend upon the trim die and your preferred trim length

is_makita = router_type == "makita" ? 1 : 0;
is_dm2hp = is_makita ? 0 : 1;

bolt_hole_height = 30; // for mounting holes, should be more than the base_height
center_hole = 44; // the opening at the very bottom, can be increased if more clearance is needed or decreased if your boring bar is too short. 
main_body_inside_diameter = 32; // 

base_height = 10;   //  
body_diameter = 40; // outer diameter of the tube

spaces = "                "; 

// minimum body height is base_height + threads_length 
// minimum_body + max_bar should be equal to bar_lenght - holder_depth assuming the bit holder is completely below the base_height line

holder_depth = is_makita ? 30 : is_dm2hp ? -1.5 : 0;

min_height = (center_hole - threads_size) / 2 + threads_length;

echo(str("min height = ", min_height, spaces));

// Some sanity checks
assert(body_diameter > main_body_inside_diameter);
assert(main_body_inside_diameter <= center_hole);
assert(threads_size < main_body_inside_diameter);

body_height = bar_length - holder_depth - max_bar;

min_bar_length = threads_length + max_bar + holder_depth + min_height;
echo(str("min_bar_length = ", min_bar_length, "mm (", min_bar_length / mm_in_in, "in)", spaces));

echo(str("body height is ", body_height, spaces));
if (body_height < min_height) {
    echo("WARNING! YOUR BORING BAR/DRILL BIT IS TOO SHORT");    
    echo(str("Minimum body height should be at least ", min_height, "mm", spaces)); 
    echo(str("Minimum bar length should be at least ", min_bar_length, "mm", spaces)); 
    echo("You can also decrease center_hole value");
    
    assert(body_height >= min_height, str("The bar length should be at least ", min_bar_length, " mm AKA ", min_bar_length / mm_in_in, " inches"));
}

makita_y_offset = -4;
makita_x1_diff = 56.2; // farther from the cut
makita_x2_diff = 54.2; // closer to the cut
makita_y_diff = 45.2;

makita_diameter = 88;
makita_width = 80;
makita_mount_hole_diameter = 4.4;

m4_bolt_head_diameter = 7.4;
m4_bolt_head_height = 4.0;

dm2hp_mount_hole_diameter = 5.5;
dm2hp_hole_difference = 25;
dm2hp_diameter = 2.3 * mm_in_in;
dm2hp_minimum_hole_height = 37; // how long is the chuck

slope_cone_height = 2;
slope_cone_angle = 45;

// DM2hp router needs more space to fit the chuck nut, change the angle of the top cone
taper_cone_angle = is_dm2hp ? 60 : 45;

use <./contrib/threads-library-by-cuiso-v1.scad>;

module embossed () {
    // main body
    translate([0, 0, (body_height + additional_height) / 2])
        cylinder(h = body_height + additional_height, d = body_diameter, center = true, $fn = fn);
    
    // Drill Master 2hp mount
    if (is_dm2hp && ! is_body_only) {
        translate([0, 0, base_height / 2])
            cylinder(h = base_height, d = dm2hp_diameter, center = true, $fn = fn);
    }

    // Makita 1 1/4 hp mount
    if (is_makita && ! is_body_only) {
        translate([0, 0, base_height / 2])
            cylinder(h = base_height, d = makita_diameter, center = true, $fn = fn);
    }

    // Wider lower part and a slope between the base and the main tube 
    translate([0, 0, slope_cone_height / 2 + base_height])
        cylinder(h = slope_cone_height, d1 = slope_cone_height / tan(slope_cone_angle) + body_diameter, d2 = body_diameter, center = true, $fn = fn);
    translate([0, 0, base_height / 2])
        cylinder(h = base_height, d = slope_cone_height / tan(slope_cone_angle) + body_diameter, center = true, $fn = fn);
}

module engraved () {
    // Threads; double the length to make sure they go all the way through
    translate([0, 0, body_height - threads_length * 2 + additional_height])
        thread_for_nut_fullparm(threads_size, 2 * threads_length, usrclearance = tight_threads ? -0.4 : -0.2, pitch = mm_in_in / 20, divs = 50, entry = 1);

    echo(str("threads_length = ", threads_length, spaces));
    
    // DRILL MASTER 2 hp: two holes on the opposite side of the router
    if (is_dm2hp) {
        translate([dm2hp_hole_difference, 0, 0])
            mount_hole(dm2hp_mount_hole_diameter);
        translate([-dm2hp_hole_difference, 0, 0])
            mount_hole(dm2hp_mount_hole_diameter);
    }

    // Makita: four holes, and also a cutout 
    if (is_makita) {
        translate([- makita_x1_diff / 2, makita_y_offset - makita_y_diff / 2, 0])
            makita_mount_hole();
        translate([makita_x1_diff / 2, makita_y_offset - makita_y_diff / 2, 0])
            makita_mount_hole();
        translate([- makita_x2_diff / 2, makita_y_offset + makita_y_diff / 2, 0])
            makita_mount_hole();
        translate([makita_x2_diff / 2, makita_y_offset + makita_y_diff / 2, 0])
            makita_mount_hole();
        
        translate([0, makita_width / 2, base_height / 2])
            cube([100, makita_diameter - makita_width, base_height + 2], center = true);       
    }

    base_cone_height = (center_hole - main_body_inside_diameter) / 2;
    echo(str("base_cone_height = ", base_cone_height, spaces));

    cone_height = (main_body_inside_diameter - threads_size) / 2 / tan(taper_cone_angle);
    echo(str("cone_height = ", cone_height, spaces));

    main_body_inside_height = body_height - threads_length - cone_height + additional_height;
    echo(str("tube_height = ", main_body_inside_height, spaces));
    
    assert(main_body_inside_height >= 0, "You need a longer bar, a narrower center_hole, or shorter threads"); 

    if (is_dm2hp) {
        // Drill Master uses a pretty big chuck nut, and it needs to be taken into consideration
        if (main_body_inside_height < dm2hp_minimum_hole_height) {
            expected_bar_length = min_bar_length + main_body_inside_height - dm2hp_minimum_hole_height;

            echo(str("WARNING: adapter is too short to fit the router's chuck"));
            echo(str("Make sure you're using 'short_threads = 1'"));
            assert(main_body_inside_height >= dm2hp_minimum_hole_height, str("The bar length should be at least ", expected_bar_length, " mm AKA ", expected_bar_length / mm_in_in, " inches")); 
        }
    }

    // The taper at the bottom of the base
    translate([0, 0, base_cone_height / 2])
        cylinder(base_cone_height, d1 = center_hole, d2 = main_body_inside_diameter, center = true, $fn = fn);

    // Tube part
    translate([0, 0, (main_body_inside_height) / 2])
        cylinder(h = main_body_inside_height, d = main_body_inside_diameter, center = true, $fn = fn);

    // The taper between threads and the main tube
    translate([0, 0, main_body_inside_height + cone_height / 2])
        cylinder(cone_height, d1 = main_body_inside_diameter, d2 = threads_size, center = true, $fn = fn);

    // The rest don't matter in the end, but useful for debugging
    // Main body height reference. 
    translate([0, 42, (body_height + additional_height) / 2])
        cylinder(h = body_height + additional_height, d = threads_size / 2, center = true, $fn = fn);
    // Boring bar references
    translate([10, 42, bar_length / 2 - holder_depth])
        cylinder(h = bar_length, d = 3/8 * mm_in_in, center = true, $fn = fn);
    color("red")
        translate([20, 42, bar_length - holder_depth - max_bar / 2])
            cylinder(h = max_bar, d1 = 1/4 * mm_in_in, d2 = 1/8 * mm_in_in, center = true, $fn = fn); 
    color("yellow")
        translate([20, 42, bar_length - holder_depth - max_bar - threads_length / 2])
            cylinder(h = threads_length, d = 1/4 * mm_in_in, center = true, $fn = fn);
    color("green")
        translate([20, 42, - holder_depth / 2])
            cylinder(h = holder_depth, d = 1/4 * mm_in_in, center = true, $fn = fn);
}

module mount_hole ( diameter, head_diameter = 0, head_height = 0) {
    cylinder(h = bolt_hole_height, d = diameter, center = true, $fn = fn);
    if (head_diameter && head_height) {
        translate([0, 0, base_height - head_height / 2])
            cylinder(h = head_height, d = head_diameter, center = true, $fn = fn);
    }
}

module makita_mount_hole ( ) {
    mount_hole(makita_mount_hole_diameter, m4_bolt_head_diameter, m4_bolt_head_height);
}

difference () {
    embossed();
    engraved();
}
