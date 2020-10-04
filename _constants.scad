// 8th-gen NUC
// https://www.intel.com/content/dam/support/us/en/documents/mini-pcs/nuc-kits/NUC8i3BE_NUC8i5BE_NUC8i7BE_TechProdSpec.pdf
mobo_screw_distance_x = 95.0;
mobo_screw_distance_y = 90.4;
mobo_screw2_offset_x = 1.9;
mobo_screw2_offset_y = mobo_screw_distance_y - 81.9;
chassis_width = 117;
chassis_depth = 112;
chassis_bottom_width = 112.5;
chassis_bottom_depth = 108.5;
chassis_outer_radius = 7;
chassis_inner_radius = 7;
chassis_bolt_diameter_1 = 5;
chassis_bolt_diameter_2 = 6.5;
chassis_bolt_diameter_3 = 8;
// distance from widest part of bolt (without rubber feet) to where the bottom plate rests
chassis_bolt_offset = 2;
center_column_width = 10.5;
chassis_thickness_1 = 0.8;
chassis_thickness_2 = chassis_thickness_1*1.5; // around the trapezoidal hole
opening_width_1 = 27.3;
opening_width_2 = 25.6;
opening_height = 14.45;
opening_offset_z = -3.4;
opening_to_bottom = 6.45;
interior_depth = 106.5 -1;
sodimm_to_chassis = 8;
rear_vent_width = 80;

// the metal spacer thing around the cpu die
die_width = 24;
die_depth = 46.2;
die_height = 0.4; // die top to raised area
die_to_screw = 0.6; // die top to heatsink screw holes
die_to_pcb = 1.15; // die top to pcb

// heatsinks screws
heatsink_screw_spacing_x = 35;
heatsink_screw_spacing_y = 35;
heatsink_screw_size = 2.5;
heatsink_screw_ = 2.5;
heatsink_screw_to_die_end = 4; // from screw center

// inner chassis
inner_chassis_to_mobo = 11;
inner_chassis_mobo_min_clearance = 3.5;
inner_chassis_to_post_x = 8.5;
inner_chassis_to_post_y_1 = 8.5; // front
inner_chassis_to_post_y_2 = 8;

// those four pegs on the outer chassis that slot into the inner chassis
inner_chassis_peg_diameter = ceil(2.75); // rounded up a bit, since it's hard to measure
inner_chassis_peg_height = ceil(1.62);
// offsets from nearest post (mobo screw)
inner_chassis_peg_fl_x = 2.5; // front-left, if chassis is upside-down
inner_chassis_peg_fl_y = 6.25;
inner_chassis_peg_fr_x = -0.75;
inner_chassis_peg_fr_y = 10;
inner_chassis_peg_bl_x = -2.75;
inner_chassis_peg_bl_y = -15.5;
inner_chassis_peg_br_x = 2.25;
inner_chassis_peg_br_y = -15.5;


// Yuan SC550N4 M2 HDMI
// HDMI jack boards
// https://www.yuan.com.tw/products/capture/m2/sc550n4_m2_type-b-m_hdmi.htm
board_width = 33.6;
board_depth = 30;
board_height = 1.65;
board_ribbon_width = 11;
board_ribbon_length = 4; // portion that can't be bent
plug_width = 15.2;
plug_depth = 11.5;
plug_height = 6.25;
plug_offset = 10.85;
plug_chassis_gap = 2;
plug_solder_width = 2.5;
plug_solder_depth = 12;
plug_solder_height = 0.75;
screw_offset_x = 4.2;
screw_offset_y = 4;
screw_distance_x = board_width - screw_offset_x * 2;
screw_distance_y = board_depth - screw_offset_y * 2;
screw_diameter = 3;
