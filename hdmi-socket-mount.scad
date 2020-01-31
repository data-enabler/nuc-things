// 8th-gen NUC
// https://www.intel.com/content/dam/support/us/en/documents/mini-pcs/nuc-kits/NUC8i3BE_NUC8i5BE_NUC8i7BE_TechProdSpec.pdf
mobo_screw_distance = 90.4;
chassis_bolt_diameter = 5;
center_column_width = 10.5;
chassis_thickness_1 = 0.8;
chassis_thickness_2 = chassis_thickness_1*1.5; // around the trapezoidal hole
opening_width_1 = 27.3;
opening_width_2 = 25.6;
opening_height = 14.45;
opening_offset_z = -3.4;
opening_to_bottom = 6.45;
interior_width = 106.5 -1;
sodimm_to_chassis = 8;

// HDMI jack boards
board_width = 33.6;
board_depth = 30;
board_height = 1.65;
plug_width = 15.2;
plug_depth = 11.5;
plug_height = 6.25;
plug_offset = 10.85;
screw_distance_x = 25;
screw_distance_y = 22;
screw_offset_x = 4.25;
screw_offset_y = 4;
screw_diameter = 3.3;

// DIY HDMI Cable Parts - Straight Micro HDMI Socket Adapter
// https://www.adafruit.com/product/3559
socket_width_1 = 15;
socket_width_2 = 19.5;
socket_narrow_length = 5.6;
socket_wide_length = 8.5;
socket_ribbon_width = 10.5;
socket_depth = 16.25;
socket_height = 4.75;

// Variables
chassis_overhang = chassis_thickness_1*3;
mount_panel_thickness = 1;
socket_padding_x = 1.5;
socket_padding_y = 4;
mount_panel_width_1 = center_column_width + opening_width_1*2;
mount_panel_width_2 = socket_width_2*2 + socket_padding_x*2;
mount_panel_depth = socket_depth + socket_padding_y;
footer_height = opening_to_bottom - mount_panel_thickness/2;
panel_height = mount_panel_thickness + socket_height;
peg_size = 2;

module socket() {
  union() {
    // narrow end
    translate([-socket_width_1/2, 0, 0]) {
      cube([socket_width_1, socket_depth, socket_height]);
    }

    // wide end
    translate([-socket_width_2/2, socket_depth - socket_wide_length, 0]) {
      cube([socket_width_2, socket_wide_length, socket_height]);
    }

    linear_extrude(socket_height) {
      x1 = socket_width_1/2;
      y1 = socket_narrow_length;
      x2 = socket_width_2/2;
      y2 = socket_depth - socket_wide_length;
      polygon(points=[
        [-x1,y1],
        [x1,y1],
        [x2,y2],
        [-x2,y2],
      ]);
    }

    // cable
    translate([-socket_ribbon_width/2, 0, 0]) {
      cube([socket_ribbon_width, socket_depth*2, socket_height]);
    }
  }
}

module socket_shell(depth=mount_panel_depth) {
  width = socket_width_2 + socket_padding_x*2;
  translate([-width/2, 0, 0]) {
    cube([width, depth, socket_height]);
  }
}

module peg_1() {
  translate([-peg_size/2, mount_panel_depth/4, 0]) {
    cube([peg_size, mount_panel_depth/2, socket_height/2]);
  }
}

module peg_2() {
  translate([-peg_size/2, sodimm_to_chassis/4, 0]) {
    cube([peg_size, sodimm_to_chassis/2, socket_height/2]);
  }
}

module corner_peg() {
  translate([peg_size/2, peg_size/2, 0]) {
    cube([peg_size, peg_size, mount_panel_thickness]);
  }
}

module corner_pegs(width=mount_panel_width_1) {
  translate([-width/2, 0, 0]) {
    corner_peg();
  }
  translate([width/2, 0, 0]) {
    rotate([0, 0, 90]) corner_peg();
  }
  translate([width/2, mount_panel_depth, 0]) {
    rotate([0, 0, 180]) corner_peg();
  }
  translate([-width/2, mount_panel_depth, 0]) {
    rotate([0, 0, 270]) corner_peg();
  }
}

module center_column(width=center_column_width, depth=interior_width) {
  translate([0, -depth/2, 0]) {
    cube([width, depth, interior_width], center=true);
  }
}

module lip() {
  translate([-interior_width, 0, 0]) {
    rotate([180, 0, 0]) cube([interior_width*2, chassis_thickness_1, interior_width], center=false);
  }
}

module footer() {
  width = peg_size*3;
  translate([-width/2, 0, 0]) {
    cube([width, mount_panel_depth, footer_height]);
  }
  translate([0, 0, footer_height]) {
    peg_1();
  }
}

module panel_1() {
  offset = mount_panel_width_1/2 - socket_padding_x - socket_width_2/2;
  hole_width = 4;
  difference() {
    union() {
      for (x = [-offset, offset]) {
        translate([x, 0, mount_panel_thickness]) {
          socket_shell();
        }
      }
      translate([-mount_panel_width_1/2, 0, 0]) {
        cube([mount_panel_width_1, mount_panel_depth, mount_panel_thickness]);
      }
      translate([0, 0, panel_height]) {
        corner_pegs();
        corner_pegs(mount_panel_width_1 - socket_width_2*2 - socket_padding_x*4 + peg_size*4);
      }

      // Hook into that little trapezoidal hole
      center_width = peg_size*3;
      translate([-center_width/2, 0, 0]) {
        cube([center_width, mount_panel_depth, panel_height]);
      }
      translate([-hole_width/2, -chassis_overhang, 0]) {
        cube([hole_width, mount_panel_depth + chassis_overhang, mount_panel_thickness*2]);
      }
    }
    for (x = [-offset, offset]) {
      translate([x, -chassis_overhang, mount_panel_thickness]) {
        socket();
      }
    }
    difference() {
      center_column(depth=chassis_thickness_2);
      translate([-hole_width/2, 0, 0]) {
        mirror([0, 1, 0]) cube([hole_width, 100, 1]);
      }
    }
    peg_1();
    corner_pegs();
    corner_pegs(mount_panel_width_1 - socket_width_2*2 - socket_padding_x*4 + peg_size*4);
  }
}

module panel_2() {
  offset = socket_width_2/2;
  difference() {
    union() {
      for (x = [-offset, offset]) {
        translate([x, -chassis_overhang, mount_panel_thickness]) {
          socket_shell(mount_panel_depth + chassis_overhang);
        }
      }
      translate([-mount_panel_width_1/2, -chassis_overhang, 0]) {
        cube([mount_panel_width_1, mount_panel_depth + chassis_overhang, mount_panel_thickness]);
      }
      translate([0, 0, panel_height]) {
        peg_2();
        difference() {
          corner_pegs(mount_panel_width_2);
          translate([0, mount_panel_depth, 0]) {
            cube([mount_panel_width_2, mount_panel_depth, panel_height*2], center=true);
          }
        }
      }
    }
    for (x = [-offset, offset]) {
      translate([x, 0, mount_panel_thickness]) {
        socket();
      }
    }
    center_column(socket_width_1 + socket_width_2);
    corner_pegs();
    corner_pegs(mount_panel_width_1 - socket_width_2*2 - socket_padding_x*4 + peg_size*4);
  }
}

module topper() {
  difference() {
    translate([-mount_panel_width_2/2, -chassis_overhang, 0]) {
      cube([
        mount_panel_width_2,
        sodimm_to_chassis + chassis_overhang,
        -opening_offset_z + mount_panel_thickness,
      ]);
    }
    peg_2();
    corner_pegs(mount_panel_width_2);
    center_column(socket_width_1 + socket_width_2);
    translate([0, 0, -opening_offset_z]) {
      mirror([0, 0, 1]) lip();
    }
  }
}

module arrange(spacing = 0) {
  footer();

  translate([0, 0, footer_height + spacing]) {
    panel_1();

    translate([0, 0, panel_height + spacing]) {
      panel_2();

      translate([0, 0, panel_height + spacing]) {
        topper();
      }
    }
  }
}

rotate([0, 180, 0]) arrange(0);
