// =============================================
// Time Travel Lines - All 7 Sins
// Highly Modular OpenSCAD - Fixed & Cleaned
// =============================================

$fn = 80;   // Resolution (64-120 recommended)

// ============== PARAMETERS ==============
length       = 180;   // Total height along Z
width        = 18;    // Base radius
thickness    = 2.2;   // Wall thickness
segments     = 45;    // Segments along length (increased for smoothness)
amplitude    = 4.5;   // Wave amplitude
twist_total  = 720;   // Total twist degrees over length
spacing      = 18 * 3.2; // Group separation spacing

show_all     = true;  // Set false + change sin_index to view single one
sin_index    = 0;     // 1-7 for single, 0 for all

// ============== PROFILES ==============
module ring(r, thick) {
    difference() {
        circle(r);
        circle(r - thick);
    }
}

// ============== 1. PRIDE - Clean Infinite Cylinder ==============
module pride(len, r, t) {
    linear_extrude(len, convexity=10) ring(r, t);
}

// ============== 2. ENVY - Concentric Flared Shells ==============
module envy(len, r, t) {
    for (i = [0:3]) {
        scale_factor = 1 + i * 0.25;
        translate([0, 0, i * (len / 12)]) {
            linear_extrude(len * 0.7, twist=twist_total * 0.2, scale=0.85, convexity=10) 
                ring(r * scale_factor, t);
        }
    }
}

// ============== 3. GREED - Corrugated Conduit ==============
module greed(len, r, t, segs) {
    step = len / segs;
    for (i = [0:segs-1]) {
        z = i * step;
        rad = r + sin(i * 30) * (r * 0.18);
        translate([0, 0, z])
            linear_extrude(step + 0.05, convexity=10) // 0.05 overlap to prevent manifold gaps
                ring(rad, t);
    }
}

// ============== 4. WRATH - Chaotic Waving Tube ==============
module wrath(len, r, t, segs, amp) {
    step = len / segs;
    for (i = [0:segs-1]) {
        z = i * step;
        ox = sin(i * 360 / segs * 2.8) * amp;
        oy = cos(i * 360 / segs * 2.1) * amp * 0.8;
        translate([ox, oy, z])
            linear_extrude(step + 0.05, convexity=10)
                ring(r, t);
    }
}

// ============== 5. SLOTH - Interlocking Helical Cage ==============
module sloth(len, r, t, segs) {
    // Main vertical core tube
    linear_extrude(len) ring(r * 0.85, t * 1.2);
    
    // Helical struts
    for (i = [0:segs*2-1]) {
        ang = i * 720 / (segs * 2);
        z = i * (len / (segs * 2));
        translate([0, 0, z])
            rotate([0, 0, ang])
                translate([r * 1.1, 0, 0])
                    linear_extrude(len / 20, center=true)
                        square([t * 1.8, t * 0.8], center=true);
    }
    
    // Horizontal rings stacked up Z
    for (i = [0:segs/4]) {
        z = i * (len / (segs / 4));
        translate([0, 0, z])
            rotate_extrude() 
                translate([r * 1.15, 0]) square([t * 1.2, t], center=true);
    }
}

// ============== 6. GLUTTONY - Alternating Hourglass ==============
module gluttony(len, r, t, segs) {
    step = len / segs;
    for (i = [0:segs-1]) {
        z = i * step;
        // Smoothly oscillate the radius using a cosine wave for a continuous hourglass effect
        r_now = r * (0.72 + 0.28 * cos(i * 360 / 6));
        r_next = r * (0.72 + 0.28 * cos((i + 1) * 360 / 6));
        
        translate([0, 0, z])
            linear_extrude(step + 0.05, scale = r_next / r_now, convexity=10)
                ring(r_now, t);
    }
}

// ============== 7. LUST - Matrix / Finned Column ==============
module lust(len, r, t, segs) {
    // Core tube
    linear_extrude(len) ring(r, t * 1.5);
    
    // Radial fins
    for (a = [0:24:359]) {
        rotate([0, 0, a])
            translate([r * 1.2, 0, len / 2])
                cube([t * 3, t * 0.6, len], center=true);
    }
    
    // Grid layers stacked up Z
    for (i = [1:(segs/5)-1]) {
        z = i * (len / (segs / 5));
        translate([0, 0, z]) {
            linear_extrude(t * 1.2, center=true) {
                for (x = [-r * 1.3 : r * 0.5 : r * 1.3])
                    translate([x, 0]) square([t * 1.1, r * 2.8], center=true);
                for (y = [-r * 1.3 : r * 0.5 : r * 1.3])
                    translate([0, y]) square([r * 2.8, t * 1.1], center=true);
            }
        }
    }
}

// ============== MAIN ASSEMBLY ==============
module time_travel_lines() {
    if (show_all || sin_index == 0) {
        translate([-spacing * 3, 0, 0]) color("silver") pride(length, width, thickness);
        translate([-spacing * 2, 0, 0]) color("gold")   envy(length, width * 0.85, thickness);
        translate([-spacing * 1, 0, 0]) color("orange") greed(length, width * 0.8, thickness, segments);
        translate([ 0,           0, 0]) color("red")    wrath(length, width * 0.75, thickness, segments, amplitude);
        translate([ spacing * 1, 0, 0]) color("purple") sloth(length, width * 0.9, thickness, segments);
        translate([ spacing * 2, 0, 0]) color("lime")   gluttony(length, width * 0.82, thickness, segments);
        translate([ spacing * 3, 0, 0]) color("cyan")   lust(length, width * 0.88, thickness, segments);
    } 
    else {
        // Single mode centered
        if (sin_index == 1) color("silver") pride(length, width, thickness);
        if (sin_index == 2) color("gold")   envy(length, width * 0.85, thickness);
        if (sin_index == 3) color("orange") greed(length, width * 0.8, thickness, segments);
        if (sin_index == 4) color("red")    wrath(length, width * 0.75, thickness, segments, amplitude);
        if (sin_index == 5) color("purple") sloth(length, width * 0.9, thickness, segments);
        if (sin_index == 6) color("lime")   gluttony(length, width * 0.82, thickness, segments);
        if (sin_index == 7) color("cyan")   lust(length, width * 0.88, thickness, segments);
    }
}

// Render Geometry
time_travel_lines();

// Reference ground plane (No longer throws scope errors)
%translate([0, 0, -2]) cube([spacing * 7.5, length * 0.8, 2], center=true);

echo("Time Travel Lines rendered successfully.");