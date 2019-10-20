
th = 4; //matrialtykkelse
min_th = 2;
head_r = 50;
eye_r = head_r/5;
nose_w = head_r/3;
body_r = 70;
foot_r = head_r/2;

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
module display()
{
     front();
     translate([0,0,th]) hode();
     translate([0,-head_r/3,th*2]) nose();
     translate([foot_r*1.2, -head_r*2.25,th]) foot();
     mirror([1,0,0]) translate([foot_r*1.2, -head_r*2.25,th]) foot();
}
display();

