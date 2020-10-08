include <_constants.scad>;

// Desktop CPU heatsinks can't be mounted directly on the die, because some
// components on the PCB get in the way. So we need some kind of metal shim.
// Unfortunately nobody seems to sell copper shims in rectangular sizes, but we
// can make do with two square ones.
//
// It's nice to be able to do this with store-bought parts, but ideally this
// would be a custom-machined rectangular heatspreader that has some kind of lip
// that a retaining bracket can be attached to. As it stands, these will
// definitely remain stuck to the bottom of your heatsink if you ever try to
// remove it.
shim_width = 20;
shim_depth = 40;
shim_height = 1.2; // Ideally 2mm or more, but this should work with the right cooler. Yeehaw.

die_frame_size = 2;
die_frame_height = shim_height- 0.4;

module shim_bracket() {
  rotate([180, 0, 0]) {
    screw_holes();
    translate([0, die_depth/2 - heatsink_screw_spacing_y/2 - heatsink_screw_to_die_end, 0]) {
      die_part();
    }
  }
}

module screw_holes() {
  screw_hole();
  mirror([1, 0, 0]) screw_hole();
  mirror([0, 1, 0]) screw_hole();
  rotate([0, 0, 180]) screw_hole();
}

module screw_hole() {
  height = die_frame_height + die_to_screw;
  width = heatsink_screw_size*2;
  screw_head_thickness = 0.8;
  screw_head_diameter = 4.5;
  translate([heatsink_screw_spacing_x/2, heatsink_screw_spacing_y/2, 0]) {
    difference() {
      translate([0, 0, -height]) {
        linear_extrude(height=height) {
          polygon([
            [width/2, -width/2],
            [width/2, width/2],
            [-(heatsink_screw_spacing_x/2 - die_width/2 - die_frame_size), (heatsink_screw_to_die_end + die_frame_size)],
            [-(heatsink_screw_spacing_x/2 - die_width/2 - die_frame_size), -(heatsink_screw_to_die_end + die_frame_size)],
          ]);
        }
      }
      cylinder(d=heatsink_screw_size, h=height*3, center=true);
      cylinder(d1=0, d2=screw_head_diameter*2, h=screw_head_diameter, center=true);
    }
  }
}

module die_part() {
  height = die_frame_height + die_height;
  difference() {
    translate([0, 0, -height/2]) {
      cube([die_width + die_frame_size*2, die_depth + die_frame_size*2, height], center=true);
    }
    cube([shim_width, shim_depth, shim_height*3], center=true);
    translate([0, 0, -die_frame_height - die_height]) {
      cube([die_width, die_depth, die_height*3], center=true);
    }
  }
}
