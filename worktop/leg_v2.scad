include<config.scad>
include<lumber_dimensions.scad>
include<../general/plank.scad>

module leg_v2(length) {
    lumber_thickness = two_by;
    lumber_width = four_by;

    plank(length, lumber_width, lumber_thickness, "z", "y");
}