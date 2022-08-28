//
//  Camera.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 16/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import MetalKit

/// "Camera video" prin care vedem totul
class Cameraman: Actor {
    
    var matriceaCamerei: matrix_float4x4
    {
        var matrice = matrix_identity_float4x4
        matrice.Pozitie(directie: pozitie)
        matrice.Rotatie(unghi: self.rotatie.x, axa: AxaX)
        matrice.Rotatie(unghi: self.rotatie.y, axa: AxaY)
        matrice.Rotatie(unghi: self.rotatie.z, axa: AxaZ)
        return matriceaModelului.inverse
    }
    
    var matriceProiectie: matrix_float4x4 {
        return matrix_float4x4.Perspectiva(grade: 55,
                                           latimePeInaltime: Deseneaza.latimePeIntaltime,
                                           laApropiere: 0.1,
                                           laDepartare: 1000)
    }
    
    init() {
        super.init(nume: "Polaroid")
    }

}
