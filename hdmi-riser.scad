include <_constants.scad>;

$fn = 40;

riser_height = 10;
riser_base_height = 2;
wall_thickness = 5;
bottom_inset = 2;
bottom_height = 2.5;
layer_height = 0.1;
fan_size = 60;
fan_height = 10;
fan_screw_offset = 5;
fan_screw_diameter = 4;

module riser() {
  difference() {
    union() {
      difference() {
        union() {
          translate([0, 0, -riser_height]) {
            w = chassis_width - chassis_outer_radius * 2;
            d = chassis_depth - chassis_outer_radius * 2;
            translate([-w/2, -d/2, 0]) {
              minkowski() {
                cube([w, d, riser_height / 2]);
                cylinder(r=chassis_outer_radius, h=riser_height / 2, center=false);
              }
            }
          }
          translate([0, 0, 0]) {
            difference() {
              w = chassis_bottom_width - chassis_inner_radius * 2;
              d = chassis_bottom_depth - chassis_inner_radius * 2;
              translate([-w/2, -d/2, 0]) {
                minkowski() {
                  cube([
                    chassis_bottom_width - chassis_inner_radius * 2,
                    chassis_bottom_depth - chassis_inner_radius * 2,
                    bottom_height / 2,
                  ]);
                  cylinder(r=chassis_inner_radius, h=bottom_height / 2, center=false);
                }
              }
              bottom_insets();
              mirror([1, 0, 0]) bottom_insets();
            }
          }
        }
        interior();
      }
      4way_mirror() {
        bolt_mount();
      }
      translate([-8, chassis_depth/2, -riser_height]) {
        rotate([0, 0, 180]) socket_mount();
      }
      translate([chassis_width/2, 0, -riser_height]) {
        rotate([0, 0, 90]) socket_mount();
      }
    }
    4way_mirror() {
      bolt();
    }
    translate([-8, chassis_depth/2, -riser_height + riser_base_height]) {
      rotate([0, 0, 180]) {
        double_cutout();
      }
    }
    translate([chassis_width/2, 0, -riser_height + riser_base_height]) {
      rotate([0, 0, 90]) {
        double_cutout();
      }
    }
    translate([-11, -13, -riser_height + riser_base_height]) fan_cutout();
    // cross-section
    // translate([mobo_screw_distance_x/2 + 10, 0, 0]) {
    //   cube([20, 200, 200], center=true);
    // }
  }
}

module bolt_mount() {
  offset_x = (chassis_width - wall_thickness*2 - mobo_screw_distance_x) / 2;
  offset_y = (chassis_depth - wall_thickness*2 - mobo_screw_distance_y) / 2;
  w = offset_x + chassis_bolt_diameter_3;
  d = offset_y + chassis_bolt_diameter_3;
  h = riser_height + bottom_height;
  translate([mobo_screw_distance_x / 2, mobo_screw_distance_y / 2, 0]) {
    translate([offset_x - w, offset_y - d, -riser_height]) {
      cube([w, d, h], center=false);
    }
    translate([0, 0, bottom_height]) {
      cylinder(r=min(offset_x, offset_y), h=5, center=false);
    }
  }
}

module bolt() {
  translate([mobo_screw_distance_x / 2, mobo_screw_distance_y / 2, bottom_height - chassis_bolt_offset]) {
    mirror([0, 0, 1]) cylinder(d=chassis_bolt_diameter_3, h=riser_height*2, center=false);
    cylinder(d=chassis_bolt_diameter_2, h=riser_height*2, center=true);
    cylinder(d1=chassis_bolt_diameter_3, d2=0, h=chassis_bolt_diameter_3/2, center=false);
  }
}

module interior() {
  difference() {
    w = chassis_width - wall_thickness * 2;
    d = chassis_depth - wall_thickness * 2;
    translate([-w/2, -d/2, -riser_height + riser_base_height]) {
      cube([w, d, (riser_height + bottom_height)], center=false);
    }
  }
}

module fan_cutout() {
  h = (riser_height + bottom_height) * 4;
  w = fan_screw_offset + fan_screw_diameter;
  cube([fan_size, fan_size - w*2, h], center=true);
  cube([fan_size - w*2, fan_size, h], center=true);
  4way_mirror() {
    translate([fan_size/2 - fan_screw_offset, fan_size/2 - fan_screw_offset, 0]) {
      cylinder(d=fan_screw_diameter, h=h, center=true);
    }
  }
  translate([0, 0, h/2]) cube([fan_size, fan_size, h], center=true);
}

module socket_mount(base_thickness=riser_base_height) {
  w = board_width * 2 + 4;
  d = board_depth + plug_chassis_gap + board_ribbon_length;
  h = board_height * 2 + base_thickness;
  translate([-w/2, 0, 0]) {
    cube([w, d, h]);
  }
}

module socket_cutout() {
  h = (riser_height + bottom_height) * 4;
  translate([0, plug_chassis_gap, 0]) {
    translate([0, board_depth/2, 0]) {
      difference() {
        translate([0, 0, h/2]) cube([board_width, board_depth, h], center=true);
        4way_mirror() {
          translate([screw_distance_x/2, screw_distance_y/2, board_height * 2]) {
            mirror([0, 0, 1]) cylinder(d=screw_diameter-0.2, h=h, center=false);
          }
        }
      }
    }
    translate([0, 0, h/2 + board_height]) {
      cube([plug_width, plug_chassis_gap * 4, h], center=true);
    }
    translate([0, board_depth, h/2]) {
      cube([board_ribbon_width, board_ribbon_length * 4, h], center=true);
    }
    solder_offset = plug_width / 2;
    for (x = [-solder_offset, solder_offset]) {
      translate([x, plug_solder_depth / 2, 0]) {
        cube([plug_solder_width, plug_solder_depth, plug_solder_height * 2], center=true);
      }
    }
  }
}

module double_cutout() {
  translate([-board_width / 2, 0, 0]) socket_cutout();
  translate([board_width / 2, 0, 0]) socket_cutout();

  // avoid artifacts between boards
  h = (riser_height + bottom_height) * 4;
  translate([0, plug_chassis_gap + board_depth/2, h/2]) {
    cube([1, board_depth, h], center=true);
  }
}

module bottom_insets() {
  translate([34, -chassis_bottom_depth / 2, 0]) {
    cube([20, bottom_inset * 2, bottom_height * 4], center=true);
  }
  translate([0, chassis_bottom_depth / 2, 0]) {
    cube([35, bottom_inset * 2, bottom_height * 4], center=true);
  }
  translate([chassis_bottom_width / 2, 40, 0]) {
    cube([bottom_inset * 2, 18, bottom_height * 4], center=true);
  }
  translate([chassis_bottom_width / 2, -40, 0]) {
    cube([bottom_inset * 2, 18, bottom_height * 4], center=true);
  }
}

module 4way_mirror() {
  children();
  mirror([1, 0, 0]) children();
  mirror([0, 1, 0]) children();
  rotate([0, 0, 180]) children();
}

riser();
