// 8th-gen NUC
// https://www.intel.com/content/dam/support/us/en/documents/mini-pcs/nuc-kits/NUC8i3BE_NUC8i5BE_NUC8i7BE_TechProdSpec.pdf
mobo_screw_distance_x = 95.0;
mobo_screw_distance_y = 90.4;
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
