$fa=1;      
$fs = 0.4;  
/* 
    written by Roger Woollett
    
    This code follows as closely as I can details
    in Ivan Law's book "Gears and gear cutting".
    It will almost certailnly need to be modified
    to decrease the tooth radius and increase dedendum
    in order to get 3d printed gears to mesh.
*/

// the gear required, thickness and bore in mm
involute(dp = 20,pa = 14.5,teeth = 30,
            thickness = 5,bore = 6);


// the code 
module involute(dp,pa,teeth,thickness,bore) 
{
    pcr = 12.7*teeth/dp; // pitch circle radius in mm
    bcr = pcr*cos(pa); // base circle radius
    tooth_radius = pcr*sin(pa); // reduce this to narrow tooth
    addendum = 25.4/dp;
    dedendum = 25.2/dp;   // increase this by "f" 
                          //but I cannot find value for f
   
    module tooth()
    // 2d single tooth (not cropped)
    {
         tooth_angle = 90/teeth;
        // half the angle subtended by a tooth
 
        y = bcr*sin(pa - tooth_angle);

        intersection()
        {
            translate([bcr,y])circle(r = tooth_radius);
            translate([bcr,-y])circle(r = tooth_radius);
        }
    }
    
    module teeth()
    // lay out the teeth
    {
        for(i = [0:1:teeth-1])
        {
            rotate(a = i*360/teeth)tooth();
        }
    }
    
    module wheel2d()
    // 2d layout for the gear
    {
        difference()
        {
            teeth();
            // crop the tips of the teeth
            difference()
            {
                circle(r = pcr+ 3*addendum);
                circle(r = pcr + addendum);
            }
        }
        
        // add the centre of the gear with hole for shaft
        difference()
        {
            circle(r = pcr - dedendum);
            circle(d = bore);
        }
    }
    
    // finally draw the gear
    linear_extrude(height = thickness)wheel2d();
}
