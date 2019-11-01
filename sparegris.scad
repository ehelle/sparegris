PI = 3.14;
th = 4; //matrialtykkelse
min_th = 4;
body_r = 100;
head_r = body_r*5/7;
eye_r = head_r/5;
nose_w = head_r/2.5;
foot_r = head_r/2;
side_w = 50;
side_c = (body_r-(th/2))*2*PI;
lid_r = body_r/2;
lid_center_r = lid_r/2;
coin_w = 8;
hinge_sp = 6;
hinge_w = 0.2;

module front ()
{
     union ()
     {
	  translate([0,-head_r*4/5,0]) cylinder(th, r = body_r, [0,0,0]);
	  cylinder(th, r = head_r, [0,0,0]);
	  translate([head_r/4,head_r/4,0]) earshape(head_r);
	  mirror([1,0,0]) translate([head_r/4,head_r/4,0]) earshape(head_r);
	  translate([foot_r*1.2, -head_r*2.25,0]) footshape();
	  mirror([1,0,0]) translate([foot_r*1.2, -head_r*2.25,0]) footshape();
     }
}

module back ()
{
     difference ()
     {
	  front();
	  translate([0,-head_r*4/5,0]) lid();
     }
}

module lid()
{
     cylinder(th, r = lid_r, center=false);
}

module lid_center()
{
     cylinder(th, r = lid_center_r, center=false);
}

module lid_lock()
{
     union()
     {
	  difference ()
	  {
	       lid();
	       union()
	       {
		    translate([0,0,0]) cube([lid_r,lid_r,th]);
		    translate([-lid_r,-lid_r,0]) cube([lid_r,lid_r,th]);
	       }
	  }
	  lid_center();
     }
}

module innerPlateFront ()
{
     cylinder(th, r = body_r-th, center=false);
}

module innerPlateBack ()
{
     difference ()
     {
	  innerPlateFront();
	  lid_lock();
     }
}

module hode ()
{
     difference ()
     {
	  union ()
	  {
	       cylinder(th, r = head_r, [0,0,0]);
	       translate([head_r/4,head_r/4,0]) ear(head_r);
	       mirror([1,0,0]) translate([head_r/4,head_r/4,0]) ear(head_r);
	  }
	  union ()
	  {
	       translate([head_r/3,head_r/4,0])
		    cylinder(th, r = eye_r, [0,0,0]);
	       translate([-head_r/3,head_r/4,0])
		    cylinder(th, r = eye_r, [0,0,0]);
	  }
     }
}

module footshape ()
{
     difference ()
     {
	  cylinder(th, r = foot_r, center=false);
	  translate([-foot_r,-foot_r*2,0]) cube([foot_r*2,foot_r*2,th]);
     }
}

module foot ()
{
     difference ()
     {
	  footshape();
	  translate([-body_r*0.75,-body_r*0.4,0])
	  difference ()
	  {
	       cylinder(th, r = body_r, center=false);
	       translate([-body_r*0.4+min_th,0,0]) cylinder(th, r = body_r*1.3, center=false);
	  }
     }
}

module earshape (head_r)
{
     rotate(45)
	  scale([1.0,0.4,1.0])
	  cylinder(th, r = head_r, [0,0,0]);
}

module innerearshape (head_r)
{
     rotate(45)
	  scale([1.0,0.35,1.0])
	  cylinder(th, r = head_r - min_th, [0,0,0]);
}

module ear (head_r)
{
     union ()
     {
	  difference ()
	  {
	       earshape(head_r);
	       innerearshape(head_r);
	  }
	  linear_extrude(th)
	       polyline([[head_r*3/5, head_r*2/3], [head_r*2.5/5, head_r*2.5/4], [head_r/3,head_r/2]], min_th);
     }
}

module nose ()
{
     difference ()
     {
	  scale([1.0,0.7,1.0])
	       cylinder(th, r = nose_w, [0,0,0]);
	  union ()
	  {
	       translate([nose_w/3,0,0])
		    cylinder(th, r = nose_w/4, [0,0,0]);
	       translate([-nose_w/3,0,0])
		    cylinder(th, r = nose_w/4, [0,0,0]);
	  }
     }
}

// copy from https://openhome.cc/eGossip/OpenSCAD/Polyline.html
module line(point1, point2, width = 1, cap_round = true) {
    angle = 90 - atan((point2[1] - point1[1]) / (point2[0] - point1[0]));
    offset_x = 0.5 * width * cos(angle);
    offset_y = 0.5 * width * sin(angle);

    offset1 = [-offset_x, offset_y];
    offset2 = [offset_x, -offset_y];

    if(cap_round) {
        translate(point1) circle(d = width, $fn = 24);
        translate(point2) circle(d = width, $fn = 24);
    }

    polygon(points=[
        point1 + offset1, point2 + offset1,  
        point2 + offset2, point1 + offset2
    ]);
}

module polyline(points, width = 1) {
    module polyline_inner(points, index) {
        if(index < len(points)) {
            line(points[index - 1], points[index], width);
            polyline_inner(points, index + 1);
        }
    }

    polyline_inner(points, 1);
}
// -copy end

module side()
{
     difference()
     {
	  cube([side_c,side_w,th]);
	  union()
	  {
	       translate([side_c/2-(coin_w/2), side_w/2-(side_w*0.35), 0])
		    cube([coin_w, side_w*0.7,th]);
	       hinge_group();
	       translate([side_c,0,0]) mirror([1,0,0]) hinge_group();
	  }
     }
}

module hinge_group()
{
     n_hinge_elmt_side = floor((side_c-(coin_w*2))/2 / (hinge_sp*2)) - 1;
     for(i = [0:n_hinge_elmt_side])
     {
	  translate([i*hinge_sp*2,0,0]) hinge_elmt();
     }
}

module hinge_elmt()
{
     union()
     {
	  translate([hinge_sp,side_w*0.15,0]) cube([hinge_w,side_w*0.7,th]);
	  translate([hinge_sp*2, 0, 0]) cube([hinge_w,side_w*0.35,th]);
	  translate([hinge_sp*2, side_w*0.65, 0]) cube([hinge_w,side_w*0.35,th]);
     }
}

module display()
{
     front();
     translate([0,0,th]) hode();
     translate([0,-head_r/3,th*2]) nose();
     translate([foot_r*1.2, -head_r*2.25,th]) foot();
     mirror([1,0,0]) translate([foot_r*1.2, -head_r*2.25,th]) foot();
     translate([0,-head_r*4/5,-th]) innerPlateFront();
     translate([0,-head_r*4/5,-side_w+th]) innerPlateBack();
     translate([0,0,-side_w]) back();

     translate([0,-head_r*4/5,-side_w*1.5]) lid_lock();
     translate([0,-head_r*4/5,-side_w*1.5 -th]) lid_center();
     translate([0,-head_r*4/5,-side_w*1.5 -th*2]) lid();
}

module flat()
{
     front();
     translate([-body_r*1.7,0,0]) hode();
     translate([-body_r*1.6,-body_r,0]) nose();
     translate([-body_r*2, -body_r*1.5,0]) foot();
     translate([-body_r*3, 0,0]) mirror([1,0,0]) foot();
     translate([body_r*4,0,0]) innerPlateFront();
     translate([body_r*4,-body_r*2,0]) innerPlateBack();
     translate([body_r*2,0,0]) back();
     translate([-body_r*1.3,-body_r*1.5,0]) lid_center();
     translate([-body_r*3.5,-body_r*2.3,0]) side();
}

display();
//projection(cut = false) flat();


//side();
//livingHinge2D(hingeLength(90,10), side_w/2, th);
//mirror([0,0,0]) livingHinge2D(hingeLength(90,10), side_w/2, th);
//lid_lock();

