width=198.043+2.5;
length=103.163;
height=6.3501+3;
top=6.3501+0.5;
left_offset=3.2;//3.186;
l_w=14.395;

union(){
difference(){


difference(){
cube([width,length,height],center=true);
cube([width-(2*l_w),length-(2*top),height],center=true);}

translate([0,-l_w,0])
cube([width-(2*l_w),length-(2*top),height],center=true);
}
translate([-(width-(2*l_w))/2.0,-left_offset,0])
cube([left_offset,length-(top),height],center=true);
}

