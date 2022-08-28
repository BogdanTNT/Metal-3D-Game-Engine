//
//  Shader.metal
//  Metal Rendering Pipeline
//
//  Created by Bogdan Rosca on 17/07/2020.
//  Copyright © 2020 Bogdan Rosca. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;


struct VarfuriIntrare{
    
    float4 pozitie [[attribute(0)]];
    float2 coordonateTexturi [[ attribute(1) ]];
    
};

struct MatriciDeTraducere{
    float4x4 camera;
    float4x4 proiectie;
};

struct DetaliiModel {
    float4x4 matrice;
};

vertex float4 vertex_main(const VarfuriIntrare varfuriIntrare [[ stage_in ]],
                          constant DetaliiModel &detalii [[ buffer(1) ]],
                          constant MatriciDeTraducere &matrici [[ buffer (2) ]]){
    
    float4 pozitie = matrici.proiectie * matrici.camera * detalii.matrice * float4(varfuriIntrare.pozitie);

    return pozitie;
    
}

fragment float4 fragment_main(constant float4 &color [[ buffer(1) ]]) {
    
    
    
    return color;
    
}


