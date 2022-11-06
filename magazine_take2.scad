battery_length_mm = 50.5;
battery_diameter_mm = 14.5;

battery_spacing_small_mm = 14.5;
battery_spacing_large_mm = 18.5;

$fn = 32;

module battery() {
    cylinder(d = battery_diameter_mm, h = battery_length_mm - 1);
    translate([0, 0, battery_length_mm - 1]) cylinder(d = 4, h = 1);
}

module contact_box() {
    hull() {
        translate([-4, -4, 0]) cylinder(r = 1, h = 5);
        translate([4, -4, 0]) cylinder(r = 1, h = 5);
        translate([4, 4, 0]) cylinder(r = 1, h = 5);
        translate([-4, 4, 0]) cylinder(r = 1, h = 5);
        translate([0, 0, 0]) cylinder(r = 0.01, h = 10, $fn=4);
    }
}

module env_cylinders(r, h, offset = 1) {
    hull() {
        translate([-offset, 0, 0]) cylinder(r = r, h = h);
        translate([battery_spacing_small_mm+offset, 0]) cylinder(r = r, h = h);
        translate([-offset, battery_spacing_small_mm + battery_spacing_large_mm, 0]) cylinder(r = r, h = h);
        translate([battery_spacing_small_mm+offset, battery_spacing_small_mm + battery_spacing_large_mm, 0]) cylinder(r = r, h = h);
    }
}

module edge_cutouts() {
    translate([-8.35, battery_spacing_large_mm/2 - 4, -1]) cube([1.6, 8, 150]);
    hull() {
        translate([19.25, 5, -1]) cube([10, 7, 31]);
        translate([21.25, 3.5, -1]) cube([2.1, 10, 31]);
    }
    hull() {
        translate([18, 1.5, 1.2]) cube([4.1, 16, 31]);
        translate([22, 1.5, 1.2]) cube([4.1, 16, 35]);
    }
    translate([21, battery_spacing_large_mm/2 - 4, -1]) cube([1.6, 8, 150]);
}

module contacts() {
    hull() {
        translate([battery_spacing_small_mm, 0, 0.4]) contact_box();
        translate([battery_spacing_small_mm, battery_spacing_large_mm, 0.4]) contact_box();
    }
    hull() {
        translate([0, battery_spacing_large_mm, 0.4]) contact_box();
        translate([0, battery_spacing_large_mm+battery_spacing_small_mm, 0.4]) contact_box();
    }
    hull() {
        translate([0, 0, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
        translate([battery_spacing_small_mm, 0, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
    }
    hull() {
        translate([0, battery_spacing_large_mm, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
        translate([battery_spacing_small_mm, battery_spacing_large_mm, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
    }
    hull() {
        translate([0, battery_spacing_large_mm + battery_spacing_small_mm, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
        translate([battery_spacing_small_mm, battery_spacing_large_mm + battery_spacing_small_mm, 0.4 + 1.5 + battery_length_mm * 2 + 4.4]) rotate([180, 0, 0]) contact_box();
    }
}

difference() {
    env_cylinders(7, 1.2);
    translate([0, 0, -1]) cylinder(d = 8, h = 10);
    translate([battery_spacing_small_mm, battery_spacing_large_mm+battery_spacing_small_mm, -1]) cylinder(d = 8, h = 10);
    hull() {
        translate([0, 0, 1]) cylinder(d = 14, h = 10);
        translate([0, -10, 1]) cylinder(d = 14, h = 10);
    }
    hull() {
        translate([battery_spacing_small_mm, battery_spacing_large_mm+battery_spacing_small_mm, 1]) cylinder(d = 14, h = 10);
        translate([battery_spacing_small_mm, battery_spacing_large_mm+battery_spacing_small_mm+10, 1]) cylinder(d = 14, h = 10);
    }
    contacts();
    edge_cutouts();
}

difference() {
    translate([-8, battery_spacing_large_mm/2 - 7.5, 1.2]) cube([30.5, 15, 90]);
    contacts();
    edge_cutouts();
    hull() {
        translate([battery_spacing_small_mm - 5, 0, 0]) cube([10, 20, 5.4]);
        translate([22.5, 0, 0]) cube([10, 20, 20]);
    }
    translate([0, 0, 1]) cylinder(d = battery_diameter_mm, h = 150);
    translate([battery_spacing_small_mm, 0, 1]) cylinder(d = battery_diameter_mm, h = 150);
    translate([0, battery_spacing_large_mm, 1]) cylinder(d = battery_diameter_mm, h = 150);
    translate([battery_spacing_small_mm, battery_spacing_large_mm, 1]) cylinder(d = battery_diameter_mm, h = 150);
    translate([0, battery_spacing_large_mm/2, 80]) cylinder(d = 1.9, h = 20);
    translate([battery_spacing_small_mm, battery_spacing_large_mm/2, 80]) cylinder(d = 1.9, h = 20);
    
    translate([0, battery_diameter_mm/2, 10]) rotate([90, 0, 0]) linear_extrude(4) text("+", halign="center", valign="center");
}

difference() {
    translate([0, 0, 11]) env_cylinders(7, 79.2);
    translate([0, 0, 0.9]) env_cylinders(battery_diameter_mm/2, 90.4, offset=0);
    edge_cutouts();
    
    translate([-10, -10, 10]) cube([50, 50, 10]);
    
    hull() {
        translate([10, battery_spacing_large_mm/2 - 7.5, 10]) cube([20, 15, 10]);
        translate([10, battery_spacing_large_mm/2 - 7.5, 15]) cube([20, 15, 10]);
        translate([10, -8, 20]) cube([20, 1, 23]);
    }
    
    hull() {
        translate([10, battery_spacing_large_mm/2 + 7.5, 10]) cube([20, 30, 10]);
        translate([10, battery_spacing_large_mm/2 + 7.5, 25.4]) cube([20, 30, 10]);
        translate([10, 40, 30]) cube([20, 1, 25.4]);
    }
    
    hull() {
        translate([-10, battery_spacing_large_mm/2 - 7.5, 10]) cube([20, 15, 1]);
        translate([-10, -8, 10]) cube([20, 1, 21]);
    }
    
    hull() {
        translate([-10, battery_spacing_large_mm/2 + 7.5, 10]) cube([20, 30, 10]);
        translate([-10, 40, 10]) cube([20, 1, 30]);
    }
}

hull() {
    translate([21, 5, 82.7]) cube([1.5, 4, 1]);
    translate([21, 3.2, 67.7]) cube([1.5, 1, 1]);
}
/*
    color("#ff7777") {
        translate([0, 0, 0.4 + 1.5]) battery();
        translate([0, 0, 0.4 + 1.5 + battery_length_mm]) battery();
    }
*/

translate([0, 0, 10]) {
    difference() {
        union() {
            translate([0, 0, 0.4 + 1.5 + battery_length_mm * 2 + 4]) cube();
            translate([0, 0, 100]) env_cylinders(8, 4);
            translate([0, 0, 104]) env_cylinders(9, 4);
            
        }
        translate([0, 0, 0]) env_cylinders(battery_diameter_mm/2, 0.4 + 1.5 + battery_length_mm * 2 + 4, offset=0);
        translate([0, battery_spacing_large_mm/2, 80]) cylinder(d = 4, h = 30);
        translate([battery_spacing_small_mm, battery_spacing_large_mm/2, 80]) cylinder(d = 4, h = 30);
        contacts();
    }

    difference() {
        translate([-8, battery_spacing_large_mm/2 - 7.5, 91.2]) cube([30.5, 15, 16.5]);
        edge_cutouts();
        contacts();
        hull() {
            translate([battery_spacing_small_mm - 5, 0, 0]) cube([10, 20, 5.4]);
            translate([22.5, 0, 0]) cube([10, 20, 20]);
        }
        translate([0, 0, 1]) cylinder(d = battery_diameter_mm, h = 150);
        translate([battery_spacing_small_mm, 0, 1]) cylinder(d = battery_diameter_mm, h = 150);
        translate([0, battery_spacing_large_mm, 1]) cylinder(d = battery_diameter_mm, h = 150);
        translate([battery_spacing_small_mm, battery_spacing_large_mm, 1]) cylinder(d = battery_diameter_mm, h = 150);
        translate([0, battery_spacing_large_mm/2, 80]) cylinder(d = 2.2, h = 30);
        translate([battery_spacing_small_mm, battery_spacing_large_mm/2, 80]) cylinder(d = 2.2, h = 30);
        translate([0, battery_spacing_large_mm/2, 91.2 + 5]) cylinder(d = 4, h = 30);
        translate([battery_spacing_small_mm, battery_spacing_large_mm/2, 91.2+5]) cylinder(d = 4, h = 30);
        translate([0, battery_diameter_mm/2, 10]) rotate([90, 0, 0]) linear_extrude(4) text("+", halign="center", valign="center");
    }
}