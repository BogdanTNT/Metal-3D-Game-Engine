//
//  Scena.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 16/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import MetalKit

/// Reprezinta scena ca un intreg (camera video, personajele care o sa fie afisate, dar si alti actori care se ocupa cu alte componente ale teatrului)
class Scena: Actor {
    var camera = Cameraman()
    
    init() {
        super.init()
    }
    
    /// Unica functie care este apelata la fiecare reimprospatare de ecran (la fiecare frame nou)
    public func PuneInMiscareScena(encoder: MTLRenderCommandEncoder) {
        Updt()
        Reda(encoder: encoder)
    }
    
    
    override func Updt() {
        matrici.matriceCamera = camera.matriceaCamerei
        matrici.matriceProiectie = camera.matriceProiectie
        
        super.Updt()
    }
    
    override func Updateaza() {
       
        super.Updateaza()
    }
    
    var matrici = MatriceScena()
    
    
    
    override func Reda(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBytes(&matrici, length: MatriceScena.stride, index: 2)
         super.Reda(encoder: encoder)
    }
    
}
