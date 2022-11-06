// The actual AA batteries I have are about 50 x 13.5; Wikipedia specifies
// 50.5 x 14.5 as maximum dimensions, but the original magazine (and presumably
// therefore the contacts in the Battery Pack MA) is spaced for 14.5 mm between
// centers so an actual 14.5mm battery wouldn't fit without interference.

battery_length_mm = 50.5;
battery_diameter_mm = 13.8;

battery_spacing_small_mm = 14.5;
battery_spacing_large_mm = 18.5;

$fn = 32;

module battery() {
    cylinder(d = battery_diameter_mm, h = battery_length_mm - 1);
    translate([0, 0, battery_length_mm - 1]) cylinder(d = 4, h = 1);
}

module batteries() {
    for(z = [0, battery_length_mm]) {
        translate([0, 0, z]) {
            /*
            for(xy = [[0, 0], [battery_spacing_small_mm, battery_spacing_small_mm], [0, battery_spacing_small_mm + battery_spacing_large_mm]]) {
                translate([xy[0], xy[1], 0]) {
                    cylinder(d = battery_diameter_mm, h = battery_length_mm - 1);
                    translate([0, 0, battery_length_mm - 1]) cylinder(d = 4, h = 1);
                }
            }
            for(xy = [[battery_spacing_small_mm, 0], [0, battery_spacing_small_mm], [battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm]]) {
                translate([xy[0], xy[1], -2.5]) {
                    translate([0, 0, 1]) cylinder(d = battery_diameter_mm, h = battery_length_mm - 1);
                    cylinder(d = 4, h = 1);
                }
            }
            */
            for(xyzt = [
                [0, 0, 0.3, 0],
                [0, battery_spacing_small_mm, 0.3, 180],
                [0, battery_spacing_small_mm + battery_spacing_large_mm, 0.3, 0],
                [battery_spacing_small_mm, 0, 0.3, 180],
                [battery_spacing_small_mm, battery_spacing_small_mm, 0.3, 0],
                [battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm, 0.3, 180]
            ]) {
                translate([xyzt[0], xyzt[1], xyzt[2]])
                    translate([0, 0, battery_length_mm/2])
                    rotate([xyzt[3], 0, 0])
                    translate([0, 0, -battery_length_mm/2])
                    battery();
            }          
        }
    }
}

module battery_envelope() {
    for(xy = [[0, 0], [battery_spacing_small_mm, battery_spacing_small_mm], [0, battery_spacing_small_mm + battery_spacing_large_mm]]) {
        translate([xy[0], xy[1], 0]) {
            cylinder(d = battery_diameter_mm, h = battery_length_mm * 2);
        }
    }
    for(xy = [[battery_spacing_small_mm, 0], [0, battery_spacing_small_mm], [battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm]]) {
        translate([xy[0], xy[1], 0]) {
            cylinder(d = battery_diameter_mm, h = battery_length_mm * 2);

        }
    }
}

module env_cylinders(r, h) {
    hull() {
        cylinder(r = r, h = h);
        translate([battery_spacing_small_mm, 0]) cylinder(r = r, h = h);
        translate([0, battery_spacing_small_mm + battery_spacing_large_mm, 0]) cylinder(r = r, h = h);
        translate([battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm, 0]) cylinder(r = r, h = h);
    }
}

// reference plane in Z is the end of the Battery Pack MA
module envelope() {
    difference() {
        union() {
            env_cylinders(7, 103);
            env_cylinders(8, 4);
            translate([0, 0, -2.5]) env_cylinders(9, 2.5);
        }
        
        translate([-7 - 0.1, battery_spacing_small_mm + battery_spacing_large_mm - 5 - 8, 4]) cube([1.6, 8, 100]);
        
        hull() {
            translate([17.5, 21, 103 - 30]) cube([4.1, 7, 100]);
            // was y = 19.5, 10 originally, modified to avoid small towers
            translate([19.5, 15.5, 103 - 30]) cube([2.1, 20, 100]);
        }
    }
}


module contact_flat() {
    color("#ff9999") {
        translate([-4.5, -4.5, 0]) cube([9, 9, 0.3]);
        cylinder(d1 = 6, d2 = 3, h = 1.5);
    }
}


module contact_spring() {
    color("#999999") {
        translate([-4.5, -4.5, 0]) cube([9, 9, 0.3]);
        cylinder(d1 = 6, d2 = 4, h = 4);
    }
}


module contact_envelope(x_stretch = 0, y_stretch = 0) {
    translate([-5, -5 - y_stretch, -0.01]) cube([10 + x_stretch, 10 + y_stretch, 0.51]);
    cylinder(d = 7, h = 10);
}

//color("#f77") batteries();

intersection() {
    difference() {
        envelope();
        translate([0, 0, 1]) battery_envelope();
        translate([0, battery_spacing_small_mm + battery_spacing_large_mm, 50]) cylinder(d = 8, h = 100);
        translate([battery_spacing_small_mm, 0, 50]) cylinder(d = 8, h = 100);
        translate([-20, battery_spacing_small_mm + battery_spacing_large_mm - 1.5, 4]) cube([21.5, 40, 97]);
        translate([13, battery_spacing_small_mm + battery_spacing_large_mm - 1.5, 4]) cube([21.5, 40, 97]);
        translate([-20, -15, 4]) cube([21.5, 31, 97]);
        translate([13, -15, 4]) cube([21, 31, 97]);
        translate([0, 0, 103]) rotate([180, 0, 0]) contact_envelope(y_stretch = 10);
        translate([0, battery_spacing_small_mm, 103]) rotate([180, 0, 0]) contact_envelope();
        translate([battery_spacing_small_mm, battery_spacing_small_mm, 103]) rotate([180, 0, 0]) contact_envelope(y_stretch = 10);
        translate([battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm, 103]) rotate([180, 0, 0]) contact_envelope();
    }
    translate([-50, -50, 4.01]) cube([100, 100, 100]);
}

/*
translate([0, 0, 102.8]) rotate([180, 0, 0]) contact_flat();
translate([0, battery_spacing_small_mm, 102.8]) rotate([180, 0, 0]) contact_flat();
translate([battery_spacing_small_mm, battery_spacing_small_mm, 102.8]) rotate([180, 0, 0]) contact_flat();
translate([battery_spacing_small_mm, battery_spacing_small_mm + battery_spacing_large_mm, 102.8]) rotate([180, 0, 0]) contact_flat();
*/