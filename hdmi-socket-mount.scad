// 8th-gen NUC
// https://www.intel.com/content/dam/support/us/en/documents/mini-pcs/nuc-kits/NUC8i3BE_NUC8i5BE_NUC8i7BE_TechProdSpec.pdf
mobo_screw_distance = 90.4;
chassis_bolt_diameter = 5;
center_column_width = 10.5;
center_column_thickness = 0.5;
opening_width = 27.35;
opening_height = 14.45;
opening_offset_z = -3.4;
opening_to_bottom = 6.45;
interior_width = 106.5 -1;
sodimm_to_chassis = 9;

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
socket_narrow_length = 5.6;
socket_width_2 = 19.5;
socket_ribbon_width = 10.5;
socket_depth = 16.25;
socket_height = 4.75;

// Variables
mount_panel_thickness = 1;
socket_padding_x = 2;
socket_padding_y = 4;
mount_panel_width = center_column_width + socket_width_1 + socket_width_2 +
  socket_padding_x * 2;
mount_panel_depth = socket_depth + socket_padding_y;
footer_height = opening_to_bottom - mount_panel_thickness/2;
panel_height = mount_panel_thickness + socket_height;

module socket() {
  union() {
    // narrow end
    translate([-socket_width_1/2, 0, 0]) {
      cube([socket_width_1, socket_depth, socket_height]);
    }

    // wide end
    translate([-socket_width_2/2, socket_narrow_length, 0]) {
      cube([socket_width_2, socket_depth - socket_narrow_length, socket_height]);
    }

    // cable
    translate([-socket_ribbon_width/2, 0, 0]) {
      cube([socket_ribbon_width, socket_depth*2, socket_height]);
    }
  }
}

module peg() {
  translate([-socket_padding_x/2, mount_panel_depth/4, 0]) {
    cube([socket_padding_x, mount_panel_depth/2, socket_height/2]);
  }
}

module peg_2() {
  translate([-socket_padding_x/2, sodimm_to_chassis/4, 0]) {
    cube([socket_padding_x, sodimm_to_chassis/2, socket_height/2]);
  }
}

module center_column() {
  translate([0, -interior_width/2, 0]) {
    cube([center_column_width, interior_width, interior_width], center=true);
  }
}

module lip() {
  translate([-interior_width, 0, 0]) {
    rotate([180, 0, 0]) cube([interior_width*2, center_column_thickness, interior_width], center=false);
  }
}

module panel() {
  difference() {
    translate([0, -center_column_thickness*3, 0]) {
      difference() {
        union() {
          translate([-mount_panel_width/2, 0, 0]) {
            cube([mount_panel_width, mount_panel_depth, panel_height]);
          }
        }
        offset = center_column_width/2 + socket_width_1/2;
        for (x = [-offset, offset]) {
          translate([x, 0, mount_panel_thickness]) {
            socket();
          }
        }
      }
    }
    center_column();
  }
}

module footer() {
  width = socket_padding_x*3;
  translate([-width/2, 0, 0]) {
    cube([width, mount_panel_depth, footer_height]);
  }
  translate([0, 0, footer_height]) {
    peg();
  }
}

module panel_1() {
  difference() {
    union() {
      panel();
      translate([0, 0, panel_height]) {
        peg();
      }
    }
    peg();
    translate([0, 0, mount_panel_thickness/2]) {
      lip();
    }
  }
}

module panel_2() {
  difference() {
    union() {
      panel();
      translate([0, 0, panel_height]) {
        peg_2();
      }
    }
    peg();
  }
}

module topper() {
  difference() {
    translate([-mount_panel_width/2, -center_column_thickness*3, 0]) {
      cube([
        mount_panel_width,
        sodimm_to_chassis + center_column_thickness*3,
        -opening_offset_z + mount_panel_thickness/2,
      ]);
    }
    peg_2();
    center_column();
    translate([0, 0, -opening_offset_z]) {
      mirror([0, 0, 1]) lip();
    }
  }
}

// y=0 is the interior side of the chassis
// z=0 is the top of the SO-DIMM sockets
/*difference() {
  union() {
    translate([0, 0, opening_offset_z + mount_panel_thickness/2]) {
      mirror([0, 0, 1]) {
        panel_1();
      }
    }
  }
}*/



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

arrange(5);
