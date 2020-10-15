
$fa=1;      
$fs = 0.4;  

/*
Written by Roger Woollett
 
 I have tried to follow the details in
 chapter 8 of "Wheel and pinion cutting in horology"
 by J Malcolm Wild
 
 Modules
 wheel - generate a wheel withoy crossings
 pinion1 - generate a pinion with 6, 7 or 8 leaves
 pinion2 - generate a pinion with 10 - 16 leaves
*/

// You can create the image here or "use" from another file

wheel(mod=2.0,teeth=42,arbor=7,thickness=3,spokes=5,hub=0.25);
translate([0,0,2.9])
    pinion1(mod=2.0,leaves=7,arbor=7,thickness=10.1);
    
module wheel(mod,teeth,arbor,thickness,spokes = 0,hub = 0.3)
/*
    Create a simple cycloidal clock wheel without crossings
    mod = module
    teeth the numberof teeth
    arbor diameter of central hole for arbor
    thickness should be obvious
    spokes - zero for no crossing
    hub - increase to make the hub bigger
*/
{
    pcr = mod*teeth/2;  // pitch circle radius
    dedendum = 1.57*mod;
    base_radius = pcr - dedendum; 
    tooth_width = 1.57*mod;
    tooth_radius = 1.93*mod;  

    flank_angle = atan(tooth_width/(2*pcr));

    module tooth()
    // create one tooth along x axis at correct
   //  radius
    {
        // tip of tooth
        intersection()
        {
            translate([pcr,tooth_radius - tooth_width/2])
                circle(tooth_radius);
            translate([pcr,-tooth_radius + tooth_width/2])
               circle(tooth_radius);
        }
        
        // base of tooth
        y1 = base_radius*sin(flank_angle);
        y2 = pcr*sin(flank_angle);
        x1 = base_radius*cos(flank_angle);
        x2 = pcr*cos(flank_angle);
        polygon([
        [x1,y1],[x2,y2],
        [x2,-y2],[x1,-y1]
        ]);
        
    }

    module teeth2d()
    // create 2 d wheel outline
    {
        for(i=[0:1:teeth - 1])
        {
            angle = i*360/teeth;

            rotate(a = angle)tooth();
        }
    }
    
    module spoke()
    {
        // proportions can be changed by modifying this code
        width = mod*2;
        length = base_radius - 1;
        angle = 3;
        x = length*sin(angle);
        polygon([[arbor,width],[length,x],
                [length,-x],[arbor,-width]]);
    }
    // now create the wheel with hole for arbor
    linear_extrude(height = thickness)
    {
        teeth2d();
        if(spokes == 0)
        {
            // no spokes
            difference()
            {
                circle(r = base_radius); 
                circle(d = arbor);
            }
        }
        else
        {
            {
                // outer rim
                difference()
                {
                    circle(r = base_radius);
                    circle(r = base_radius*0.9);
                }
                
                // hub with hole for arbor
                difference()
                {
                    circle(r = base_radius*hub);
                    circle(d = arbor);
                }
                for(i=[0:1:spokes - 1])
                {
                    rotate(a = i*360/spokes)spoke();
                }
            }
        }
            
    }
}

module pinion1(mod,leaves,arbor,thickness)
{
    // dedendums depend on num_leaves
    deds = [1.58,1.85,1.90];
       
    pcr = mod*leaves/2;  // pitch circle radius
    dedendum = deds[leaves - 6];
    base_radius = pcr - dedendum; 
    tooth_width = 1.05*mod;
    tooth_radius = 1.05*mod;  

    flank_angle = atan(tooth_width/(2*pcr));

    module tooth()
    // draw one tooth
    {
        intersection()
        {
            translate([pcr,tooth_width/2])
                circle(tooth_radius);
            translate([pcr,-tooth_width/2])
               circle(tooth_radius);
        }
        
        // base of tooth
        y1 = base_radius*sin(flank_angle);
        y2 = pcr*sin(flank_angle);
        x1 = base_radius*cos(flank_angle);
        x2 = pcr*cos(flank_angle);
        polygon([
        [x1,y1],[x2,y2],
        [x2,-y2],[x1,-y1]
        ]);
   
    }
    
    module pinion()
    // put leaves together
    {
         for(i=[0:1:leaves - 1])
        {
            angle = i*360/leaves;

            rotate(a = angle)tooth();
            circle(r = base_radius);
        }
    }
    
    assert((leaves > 5 && leaves < 9),
      ,"num_leaves must be 6, 7 or 8");
    
    linear_extrude(height = thickness)
    difference()
    {
        pinion();
        circle(d = arbor);
    }
}

module pinion2(mod,leaves,arbor,thickness)
// pretty much a copy of pinion1
// with variations to accord with JMW who only 
// recognises 10,12,16 lef pinions
{
    deds = [2.05,2.05,2.1,2.1,2.1,2.1,2.1];
    pcr = mod*leaves/2;  // pitch circle radius
    dedendum = deds[leaves - 10];
    base_radius = pcr - dedendum; 
    tooth_width = 1.25*mod;
    tooth_radius = 0.82*mod;  

    flank_angle = atan(tooth_width/(2*pcr));
    
    module tooth()
    {
        intersection()
        {
            translate([pcr,tooth_radius - tooth_width/2])
                circle(tooth_radius);
            translate([pcr,tooth_width/2 - tooth_radius])
               circle(tooth_radius);
        }
        
        // base of tooth
        y1 = base_radius*sin(flank_angle);
        y2 = pcr*sin(flank_angle);
        x1 = base_radius*cos(flank_angle);
        x2 = pcr*cos(flank_angle);
        polygon([
        [x1,y1],[x2,y2],
        [x2,-y2],[x1,-y1]
        ]);
   
    }
    
    module pinion()
    {
         for(i=[0:1:leaves - 1])
        {
            angle = i*360/leaves;

            rotate(a = angle)tooth();
            circle(r = base_radius);
        }
    }
    
    assert((leaves > 9 && leaves < 17),
        "num_leaves must be between 10 and 16");
    
    linear_extrude(height = thickness)
        difference()
        {
            pinion();
            circle(d = arbor);
        }
    
}

