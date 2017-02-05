$fn = 30;

// Copy libraries from OpenSCAD-utils into local OpenSCAD libraries folder
include <Spirals.scad>
include <Transforms.scad>
include <Stands.scad>

function color_pairs() = [
        ["red", "blue"],
        ["blue", "red"],
        ["green", "yellow"],
        ["yellow", "green"]
    ];
    
function random_colors() = color_pairs() [floor(rands(0,4,1)[0])];

module rna(shift) { 
    angle = acos(shift);
    p1 = z_rotation(angle) * [1,0,0];
    p2 = z_rotation(-angle) * [1,0,0];
    c = [shift, 0, 0];
    
    colors = random_colors();
    color(colors[0]) follow([p1, c], 0.1, $fn=10);
    color(colors[1]) follow([p2, c], 0.1, $fn=10);
}

module rna_2d(shift) {    
    translate([shift, -1, 0]) square([0.2, 2]);
}

module joint(shift) {
    translate([0, shift, 0]) rotate(-45, [1, 0, 0]) cube(1, center = true);
}

module rna_with_joint(shift) {
    
    colors = random_colors();
    
    intersection() {
        translate([shift, 0, 0]) union() {
            color(colors[0]) intersection() {
                translate([0, -0.5, 0]) rotate(90, [1,0,0]) cylinder(h=1.05, r=0.1, center=true,$fn = 10);
                joint(-0.66);
            }
            color(colors[1]) difference() {
                translate([0, 0.5, 0]) rotate(90, [1,0,0]) cylinder(h=1.05, r=0.1, center=true, ,$fn = 10);
                joint(-0.66);
            }
        }
        sphere(1);
    }
}

module edge(length, width, shift) {
    angle = acos(shift);
    echo ("Starting angle: ", angle);
    p1 = z_rotation(angle) * [1,0,0];
    p2 = z_rotation(-angle) * [1,0,0];
    follow(spiral(length, width, 72 * length, p1), width/2);
    follow(spiral(length, width, 72 * length, p2), width/2);
}

module dna(length, shift) {
    spiral_repeat(length, 0.7, 72 * length) 
    rna(shift);
    edge(length+0.3, 0.3, shift);
}

module dna_2d(length, shift) {
    linear_extrude(height = length, twist = 72 * length, $fn = 300) 
    rna_2d(shift);
}

stand(3.5)
clone(3) 
    translate([1.3,0,0]) rotate(-22, [1,0,0]) dna(9.2, 0.46);
