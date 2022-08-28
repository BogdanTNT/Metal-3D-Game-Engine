//
//  AlgebraLiniara.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 16/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import MetalKit

// Presupunand ca X este dreapta - stanga
// Y este sus - jos
// Z este fata - spate

public var AxaX: SIMD3<Float> {
    return SIMD3<Float>(1, 0, 0)
}

public var AxaY: SIMD3<Float> {
    return SIMD3<Float>(0, 1, 0)
}

public var AxaZ: SIMD3<Float> {
    return SIMD3<Float>(0, 0, 1)
}

extension Float {
    /// Transfroma din unghi in radiani (din unghi in valoare numerica) pi (~3,14) -> 180 grade
    var inRadiani: Float {
        return(self / 180) * Float.pi
    }
    
    /// Transforma din radiani in grade (din valoare numerica in unghi) 180 -> pi (~3,14)
    var inGrade: Float {
        return self * ( 180 / Float.pi)
    }
    
    /// Functie care alege aleator un numar intre 0 si 1
    static var AleatoriuIntreZeroSiUnu: Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }
}


extension matrix_float4x4 {
    mutating func Pozitie(directie: SIMD3<Float>) {
        var rezultat = matrix_identity_float4x4
        
        let x = directie.x
        let y = directie.y
        let z = directie.z
        
        rezultat.columns = (
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(x, y, z, 1)
        )
        
        self = matrix_multiply(self, rezultat)
    }
    
    mutating func Marime(axa: SIMD3<Float>) {
        var rezultat = matrix_identity_float4x4
        
        let x = axa.x
        let y = axa.y
        let z = axa.z
        
        rezultat.columns = (
            SIMD4<Float>(x, 0, 0, 0),
            SIMD4<Float>(0, y, 0, 0),
            SIMD4<Float>(0, 0, z, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        self = matrix_multiply(self, rezultat)
    }
    
    mutating func Rotatie(unghi: Float, axa: SIMD3<Float>) {
        var rezultat = matrix_identity_float4x4
        
        let x = axa.x
        let y = axa.y
        let z = axa.z
        
        let c = cos(unghi)
        let s = sin(unghi)
        
        let mc = 1 - c
        
        let r1c1 = x * x * mc + c
        let r2c1 = x * y * mc + z * s
        let r3c1 = x * z * mc - y * s
        
        let r1c2 = y * x * mc - z * s
        let r2c2 = y * y * mc + c
        let r3c2 = y * z * mc + x * s
        
        let r1c3 = z * x * mc + y * s
        let r2c3 = z * y * mc - x * s
        let r3c3 = z * z * mc + c
        
        rezultat.columns = (
            SIMD4<Float>(r1c1, r2c1, r3c1, 0),
            SIMD4<Float>(r1c2, r2c2, r3c2, 0),
            SIMD4<Float>(r1c3, r2c3, r3c3, 0),
            SIMD4<Float>(0, 0, 0, 1)
        )
        
        self = matrix_multiply(self, rezultat)
    }
    
    //https://gamedev.stackexchange.com/questions/120338/what-does-a-perspective-projection-matrix-look-like-in-opengl\
    static func Perspectiva(grade: Float, latimePeInaltime: Float, laApropiere: Float, laDepartare: Float)->matrix_float4x4 {
        let fov = grade.inRadiani
        
        let t: Float = tan(fov / 2)
        
        let x: Float = 1 / (latimePeInaltime * t)
        let y: Float = 1 / t
        let z: Float = -((laDepartare + laApropiere) / (laDepartare - laApropiere))
        let w: Float = -((2 * laDepartare * laApropiere) / (laDepartare - laApropiere))
        
        var rezultat = matrix_identity_float4x4
        rezultat.columns = (
            SIMD4<Float>(x,  0,  0,   0),
            SIMD4<Float>(0,  y,  0,   0),
            SIMD4<Float>(0,  0,  z,  -1),
            SIMD4<Float>(0,  0,  w,   0)
        )
        return rezultat
    }
}

class Mate {
    /// lerp
    static func Intre(a: Float, b: Float, t: Float) -> Float{
        return a + (b - a) * t
    }
    
    
    /// Cea mai buna functie pe care am conceput-o.
    /// Transforma o paleta de culori din HSB/HSV (Hue, Saturation, Brightness) in RGB pentru a putea ii zice placii video cum sa coloreze ceva
    static func rgb(h: Float, s: Float, b: Float) -> SIMD3<Float> {
        if s == 0 { return  SIMD3<Float>(b, b, b) }
        
        let unghi = (h >= 360 ? 0 : h)
        
        // In ce cadran se afla culoarea (presupunand ca cercul de culori are 6 cadrane :)))
        let sector = unghi / 60
        let i = floor(sector)
        let f = sector - i
        
        // Calculeaza valoarile de pigment.
        let p = b * (1 - s)
        let q = b * (1 - (s * f))
        let t = b * (1 - (s * (1 - f)))
        
        // In functie de cadran, rezulta combinatia corecta de culori
        switch(i) {
        case 0:
            return SIMD3<Float>(b, t, p)
        case 1:
            return SIMD3<Float>(q, b, p)
        case 2:
            return SIMD3<Float>(p, b, t)
        case 3:
            return SIMD3<Float>(p, q, b)
        case 4:
            return SIMD3<Float>(t, p, b)
        default:
            return SIMD3<Float>(b, p, q)
        }
    
    }
}
