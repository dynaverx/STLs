
$fn=64;

//rotate_extrude(angle=180,convexity=2){import("Subaru_Logo_alt.stl");}


 linear_extrude(height = 4, center = false)
 import("Subaru.stl");



width=85;
length=60;
height=4;
socket_width=32;
socket_length=28;
socket_height=50;
rounding_r=3;
socket_offset_from_base=14;




module roundedcube(xdim ,ydim ,zdim, rdim){
hull(){
translate([rdim,rdim,0])cylinder(r=rdim,h=zdim);
translate([xdim-rdim,rdim,0])cylinder(r=rdim,h=zdim);
translate([rdim,ydim-rdim,0])cylinder(r=rdim,h=zdim);
translate([xdim-rdim,ydim-rdim,0])cylinder(r=rdim,h=zdim);
}
}



//rotate([0,180,0])
//translate([-76.5,25,-1])
//linear_extrude(height=3) offset(0)  text("SUBARU", size=12, font="Arial");

roundedcube(width,length,height,rounding_r);





translate([width/2-socket_length/2,socket_offset_from_base,0])
cube([socket_length,socket_width,socket_height]);

translate([width/2-socket_length/2,1,0])
cube([socket_length,13,25]);

translate([width/2-socket_length/2,32+13+1,0])
cube([socket_length,13,25]);
   
//translate([width/2-socket_length/2,1,25])
//roundedcube(28,20,25,5);


translate([width/2-socket_length/2,59-24,37.5])
rotate([0,90,0])
roundedcube(28,20,28,12);


W=28;
L=20;
H=2;
wall=1.2;

translate([width/2,45,32])
rotate([90,0,0])
difference()
{
hull() {    
            translate([0,(L-W)/2,0]) sphere(d=W); 
            translate([0,(W-L)/2,0]) sphere(d=W);    
    }
     translate([-L,-L,H/2])cube([L*2,L*2,W]);
     translate([-L,-L,-H/2])cube([L*2,L*2,W]);   
}


W1=28;
L1=20;
H1=2;

translate([width/2,15,32])
rotate([90,0,180])
difference()
{
hull() {    
            translate([0,(L1-W1)/2,0]) sphere(d=W1); 
            translate([0,(W1-L1)/2,0]) sphere(d=W1);    
    }
     translate([-L1,-L1,H1/2])cube([L1*2,L1*2,W1]);
     translate([-L1,-L1,-H1/2])cube([L1*2,L1*2,W1]);   
}

difference(){
    
rotate([90,0,90])
translate([width/2-socket_length/2-9,18,0])
translate([12,-18,20])
roundedcube(9,50,9,5);
   
    translate([21,32,0])
    cube(size=[8,8,50]);
    
    }
    
    translate([85,72,0])   
rotate([0,0,180])  
    
    difference(){
    
rotate([90,0,90])
translate([width/2-socket_length/2-9,18,0])
translate([12,-18,20])
roundedcube(9,50,9,5);
   
    translate([21,32,0])
    cube(size=[8,8,50]);
    
    }

translate([20,25,4])
cube([14,22,12]);
    
translate([51,25,4])
cube([14,22,12]);
   
/*    
   translate([20,35,18]) 
    rotate([90,49,90])
    //changing the color
color("green"){
    
    // cylinder with radius of 3
    cylinder(r=10, h=9, $fn=3);
}
*/

    


difference(){
        
translate([31.5,12,50])
cube([22,20,32]);
    

        color("green"){
     translate([31.5,16,78])
    cube([23,11,6]);
    }
    
    translate([31.5,27,87])
    rotate([90,92,90])
color("green"){
    
    // cylinder with radius of 3
    cylinder(r=10, h=25, $fn=3);
}
    translate([31.5,18,77])
    cube([23,10,4]);
    
    translate([31.5,17,88])
    rotate([90,92,90])
    //changing the color
color("green"){
    
    // cylinder with radius of 3
    cylinder(r=10, h=25, $fn=3);
}
    
    rotate([0,90,0])
    translate([-74,22,27])
    cylinder(28,7,7);

    translate([31.5,12,50])
    cube([22,2,16]);

    translate([31.5,30,50])
    cube([22,2,16]);
    }
