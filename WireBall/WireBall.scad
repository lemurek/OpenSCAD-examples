$fn = 40;
$margin = 0.2;
$magic_angle = 63;

include <Rotations.scad>

module cutout_extrude(cut_depth) {
    difference() {
        rotate_extrude() children(0);
        clone(5) rotate($magic_angle, [1,0,0]) translate([cut_depth / 2, 0,0]) rotate_extrude() offset($margin) children(0);
    }
}

module wire_ball(cut_depth) {
    rotate(180) cutout_extrude(cut_depth) children(0);
    clone(5) rotate(-$magic_angle, [1,0,0]) cutout_extrude(cut_depth) children(0);
}

module ring_profile(R, h, d) {
    translate([R-d/2, 3*h/2]) square([d, h]);
    translate([R-d/2, -h/2]) square([d, h]);
    translate([R-d/2, -5*h/2]) square([d, h]);
}

wire_ball(2) ring_profile(20, 1, 2);
