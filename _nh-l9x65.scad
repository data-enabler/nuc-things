include <_constants.scad>;
include <_cpu-shim.scad>;

$fn = 40;

heatsink_plate_width = 42;
heatsink_plate_depth = 45;
heatsink_plate_to_mount = 3.6;
heatsink_mount_width = 60;
heatsink_mount_height = 8.1;
heatsink_mounting_screw_distance = 82.5;
heatsink_mounting_bracket_outer_width = 93;
heatsink_mounting_bracket_inner_width = heatsink_mounting_screw_distance*2 - heatsink_mounting_bracket_outer_width;
heatsink_mounting_bracket_height = heatsink_mount_height - 1.8;
heatsink_mounting_bracket_thickness = 2;

m2_5_insert_diameter = 3;
m2_5_insert_depth = 5;
m4_diameter = 4;
m4_insert_diameter = 5.5;
m4_insert_depth = 4;

post_diameter = 8; // Matches the circle printed around it

// This is the height (measuring from the top of the chassis) at which the
// heatsink mounting bracket and our motherboard bracket connect
bracket_height = inner_chassis_to_mobo
  - heatsink_mounting_bracket_height
  + heatsink_mounting_bracket_thickness
  - shim_height
  - die_to_pcb;

// This is the primary height for the bracket, giving a minimum clearance that's
// sufficient for most components on the motherboard
main_height = inner_chassis_to_mobo - inner_chassis_mobo_min_clearance;

// Using the same distance for every side, just for convenience
post_to_chassis = min(
  inner_chassis_to_post_x,
  inner_chassis_to_post_y_1,
  inner_chassis_to_post_y_2
);

module heatsink_brackets() {
  difference() {
    union() {
      translate([-mobo_screw_distance_x/2, 0, 0]) {
        chassis_bracket();
      }
      translate([mobo_screw_distance_x/2, 0, 0]) {
        mirror([1, 0, 0]) {
          chassis_bracket();
        }
      }
    }

    outer_chassis_pegs();

    // Airflow for rear of the case
    translate([0, mobo_screw_distance_y/2, 0]) {
      cube([rear_vent_width, post_to_chassis*2, bracket_height*2], center=true);
    }

    // CPU fan attachment post
    translate([-mobo_screw_distance_x/2 + 6, -mobo_screw_distance_y/2 + 5, inner_chassis_to_mobo]) {
      mirror([0, 0, 1]) cylinder(d=ceil(5.5), h=5, center=false);
    }

    // Rubber spacer thing
    translate([0, -mobo_screw_distance_y/2 + 4, inner_chassis_to_mobo - 6.5/2]) {
      cube([ceil(14.4+1), ceil(3.9+1), 6.5], center=true);
    }

    // CMOS battery
    translate([mobo_screw_distance_x/2 - 23.5, -mobo_screw_distance_y/2 + 5.5, inner_chassis_to_mobo]) {
      mirror([0, 0, 1]) cube([21, 31, 6.95], center=false);
    }

    // CMOS battery connector
    translate([mobo_screw_distance_x/2 - 7.5, -mobo_screw_distance_y/2 + 29, inner_chassis_to_mobo]) {
      mirror([0, 0, 1]) cube([7.5+3.5, 7.5, 8]);
    }

    // CPU fan connector
    translate([mobo_screw_distance_x/2 - 15.5, -mobo_screw_distance_y/2 + 2, inner_chassis_to_mobo]) {
      mirror([0, 0, 1]) cube([11, 6, 8]);
    }
  }
}

module chassis_bracket() {
  difference() {
    union() {
      // Front-to-back
      hull() {
        for (y = [-1, 1]) {
          translate([0, y * mobo_screw_distance_y/2, 0]) {
            cylinder(r=post_to_chassis, h=main_height, center=false);
          }
        }
      }

      // Side-to-side
      for (y = [-1, 1]) {
        hull() {
          for (x = [0, mobo_screw_distance_x/2]) {
            translate([x, y * mobo_screw_distance_y/2, 0]) {
              cylinder(r=post_to_chassis, h=main_height, center=false);
            }
          }
        }
      }

      // Extra area for mounting the heatsink
      translate([0, -mobo_screw_distance_y/2, 0]) {
        cube([mobo_screw_distance_x/2 - heatsink_mounting_bracket_inner_width/2, mobo_screw_distance_y, main_height]);
      }

      mobo_mounting_post();

      chassis_post();
    }

    // Cutout for heatsink bracket
    translate([mobo_screw_distance_x/2 - heatsink_mounting_bracket_outer_width/2, -heatsink_plate_depth/2, bracket_height]) {
      mirror([0, 0, 1]) {
        cube([heatsink_mounting_bracket_outer_width/2, heatsink_plate_depth, heatsink_mounting_bracket_thickness]);
      }
    }

    // Hole for a threaded insert to mount the heatsink
    translate([mobo_screw_distance_x/2 - heatsink_mounting_screw_distance/2, 0, bracket_height]) {
      cylinder(d=m4_insert_diameter, h=m4_insert_depth*2, center=true);
    }

    // Some space for the screw to attach the heatsink to the bracket
    translate([mobo_screw_distance_x/2 - heatsink_mounting_bracket_outer_width/2, -m4_diameter, bracket_height]) {
      mirror([0, 0, 1]) {
        cube([heatsink_mounting_bracket_outer_width/2, m4_diameter*2, heatsink_mounting_bracket_thickness*3]);
      }
    }

    mobo_mounting_post_hole();

    chassis_post_holes();
  }
}

module mobo_mounting_post() {
  translate([-mobo_screw2_offset_x, mobo_screw_distance_y/2 - mobo_screw2_offset_y, inner_chassis_to_mobo]) {
    // Using the same diameter as the other posts would come right up against a component
    mirror([0, 0, 1]) {
      cylinder(d=post_diameter-0.5, h=inner_chassis_mobo_min_clearance, center=false);
    }
  }
}

module mobo_mounting_post_hole() {
  translate([-mobo_screw2_offset_x, mobo_screw_distance_y/2 - mobo_screw2_offset_y, inner_chassis_to_mobo]) {
    mirror([0, 0, 1]) {
      cylinder(d=m2_5_insert_diameter, h=m2_5_insert_depth*2, center=true);
    }
  }
}

module chassis_post() {
  difference() {
    for (y = [-1, 1]) {
      translate([0, y * mobo_screw_distance_y/2, 0]) {
        cylinder(d=post_diameter, h=inner_chassis_to_mobo, center=false);
      }
    }
    chassis_post_holes();
  }
}

module chassis_post_holes() {
  for (y = [-1, 1]) {
    translate([0, y * mobo_screw_distance_y/2, 0]) {
      cylinder(d=m2_5_insert_diameter, h=inner_chassis_to_mobo*3, center=true);
    }
  }
}

module outer_chassis_pegs() {
  x = mobo_screw_distance_x/2;
  y = mobo_screw_distance_y/2;
  for (xy = [
    [-x + inner_chassis_peg_fl_x, -y + inner_chassis_peg_fl_y],
    [ x + inner_chassis_peg_fr_x, -y + inner_chassis_peg_fr_y],
    [-x + inner_chassis_peg_bl_x,  y + inner_chassis_peg_bl_y],
    [ x + inner_chassis_peg_br_x,  y + inner_chassis_peg_br_y],
  ]) {
    translate([each xy, 0]) {
      cylinder(d=inner_chassis_peg_diameter, h=inner_chassis_peg_height*2, center=true);
    }
  }
}

module slice_connectors(diameter) {
  for (x = [-1, 1], y = [-1, 1]) {
    translate([x*(mobo_screw_distance_x/2), y*(mobo_screw_distance_y/2 - 12), 0]) {
      cylinder(d=diameter, h=2, center=false);
    }
  }
}

module slice1() {
  difference() {
    heatsink_brackets();
    translate([0, 0, bracket_height]) {
      cylinder(r=mobo_screw_distance_x, h=inner_chassis_to_mobo, center=false);
    }
  }
  translate([0, 0, bracket_height]) slice_connectors(3);
}

module slice2() {
  difference() {
    translate([0, 0, -bracket_height]) {
      heatsink_brackets();
    }
    mirror([0, 0, 1]) {
      cylinder(r=mobo_screw_distance_x, h=inner_chassis_to_mobo, center=false);
    }
    slice_connectors(3.1);
  }
}

slice1();
translate([0, 0, inner_chassis_to_mobo*3]) slice2();
