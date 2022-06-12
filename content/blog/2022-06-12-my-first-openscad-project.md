+++
title = "My first OpenSCAD Project"
author = ["Guilherme Pedrosa"]
date = 2022-06-12T09:55:00-03:00
draft = false
+++

I am trying my hand at carpentry and wanted to do some experimentations with a bookshelf of my own design. This led me to a search for a parametric CAD tool, where I could change determined design variables and have the model updated. OpenSCAD fitted the bill.

In under one hour I went from zero OpenSCAD knowledge to have a working model. The code itself is not optmized, but I was happy with the result. As resources go, I would recommend:

-   [Model a Code Brick by mathcodeprint](https://www.youtube.com/watch?v=ecd_eWPnynk&t=46s)
-   [OpenSCAD Cheatsheet](https://openscad.org/cheatsheet/)

By following them I was able to produce a 3D model from a notebook sketch. Here's the result with the accompanying _.scad_  code:

<a id="orge2739ee"></a>

![](/img/estante2.png)
**Bookshelf model on OpenSCAD**

```nil
//Variáveis paramétricas
pe=70;
h_gaveta=120;
esp_comp=15;
nicho=250;

//Pés
difference(){
    cube([750,300,1450]);
    translate([45,0,0])
    cube([660,300,1450]);
    translate([0,45,0])
    cube([750,210,1450]);
}

// Estantes
for (i=[0:3]){
translate([30,0,pe+250*i])
cube([690,300,15]);
}
translate([30,0,pe+250*3+h_gaveta])
cube([690,300,15]);
translate([30,0,pe+250*4+h_gaveta])
cube([690,300,15]);

//Gaveta
translate([45,0,pe+250*3])
cube([660,15,h_gaveta]);

// Puxador
translate([45+330,0,pe+250*3+h_gaveta/2]){
sphere(r=20);
}
// Apoios laterais
for (i=[0:2]){
translate([22.5,285,pe+esp_comp+i*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);
translate([22.5+660+45,285,pe+esp_comp+i*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);
}

translate([22.5,285,pe+esp_comp+h_gaveta+3*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);
translate([22.5+660+45,285,pe+esp_comp+h_gaveta+3*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);


translate([22.5,285,pe+esp_comp+h_gaveta+4*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);
translate([22.5+660+45,285,pe+esp_comp+h_gaveta+4*nicho+(nicho-esp_comp/2)/2])
rotate([90,0,0])
cylinder(270,15,15);


// Otimizações

//for (i=[0:4]){
//    if (i<3){
//        translate([30,0,pe+250*i])
//    } else {
//        translate([30,0,pe+250*i+h_gaveta])
//    }
//cube([690,300,15]);
//}
```

Note that the model is incomplete. I did not model the drawers completely, as I wanted to nail the dimentions and proportions in order to produce a bill of materials that I could purchase and transport easily. As a caveat, I was not able to retrieve the final quotes from the 3D model. This is something I am willing to explore on another post if I find a solution. The ability Ato export the final dimension is a must for any work on the shop and bring this model to life.
