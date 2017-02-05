$fn = 10;

$margin = 0.2;
$epsilon = 0.001;
$rotate = 63;

module clone(n, axis) {
    a = 360./n;
    for (i = [1:n]) {
        rotate(i*a, axis) children(0);
    }
}

module ringA(R, h, d) {
    difference() {
        cylinder(h=h, r=R+d/2, center = true);
        cylinder(h=h+$epsilon, r=R-d/2, center = true);
    }
}

module ring(R, h, d) {
    difference() {
        intersection() {
            cylinder(h=h, r=R+d/2, center = true);
            sphere(R+d/2);
        }
        sphere(R-d/2);
    }
}

module cutout_ring(R, h, d) {
    difference() {
        ring(R, h, d);
        clone(5) rotate($rotate, [1,0,0]) translate([d / 2, 0,0])  
         ring(R, h + $margin, d + $margin);
    }
}

module wire_ball(R, h, d) {
    rotate(180) cutout_ring(R, h, d);
    clone(5) rotate(-$rotate, [1,0,0]) cutout_ring(R, h, d);
}

wire_ball(10, 2, 1);
