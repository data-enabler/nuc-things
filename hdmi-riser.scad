include <constants.scad>;

$fn = 40;

riser_height = 1;
wall_thickness = 5;
bottom_inset = 2;
bottom_height = 2.5;

difference() {
  union() {
    translate([0, 0, 0]) {
      w = chassis_width - chassis_outer_radius * 2;
      d = chassis_depth - chassis_outer_radius * 2;
      translate([-w/2, -d/2, 0]) {
        minkowski() {
          cube([w, d, riser_height / 2]);
          cylinder(r=chassis_outer_radius, h=riser_height / 2, center=false);
        }
      }
    }
    translate([0, 0, riser_height]) {
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
  cube([
    chassis_width - wall_thickness * 2,
    chassis_depth - wall_thickness * 2,
    (riser_height + bottom_height) * 4,
  ], center=true);
}

module bottom_insets() {
  translate([34, -chassis_bottom_depth / 2, 0]) {
    cube([20, bottom_inset * 2, bottom_height * 4], center=true);
  }
  translate([0, chassis_bottom_depth / 2, 0]) {
    cube([35, bottom_inset * 2, bottom_height * 4], center=true);
  }
  translate([chassis_bottom_width / 2, 50, 0]) {
    cube([bottom_inset * 2, 20, bottom_height * 4], center=true);
  }
  translate([chassis_bottom_width / 2, -50, 0]) {
    cube([bottom_inset * 2, 20, bottom_height * 4], center=true);
  }
}
