//
//  Actor.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 16/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import MetalKit

class Actor {
    /// Numele general al actorului
    var nume: String
    /// Starea de participare la sceneta
    var activ: Bool
    /// Timpul dintre doua frameuri
    let deltaTime:Float = 1/60
    
    /// Pozitia actorului
    var pozitie: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
    /// Rotatia actorului
    var rotatie: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
    /// Marimea actorului
    var marime: SIMD3<Float> = SIMD3<Float>(1, 1, 1)
    
    
    /// FORWARD VECTOR - vectorul care indica directia planului sagitar al personajlui
    var inFata: SIMD3<Float> {
        return normalize([sin(rotatie.y), 0, cos(rotatie.y)])
    }
    /// RIGHT VECTOR - vectorul care indica directia planului frontal
    var laDreapta: SIMD3<Float> {
        return [inFata.z, inFata.y, -inFata.x]
    }
    /// UP VECTOR - vectorul care indica directia planului transversal
    var inSus: SIMD3<Float>{
        return [inFata.z, -inFata.y, inFata.x]
    }
    
    
    /// Lista de actori pe care acest actor ii controleaza
    var subalterni: [Actor] = []
    
    /// Matricea parintelui (daca are unul)
    var sef = matrix_identity_float4x4
    
    var matriceModel = Matricee()
    
    var matriceaModelului: matrix_float4x4
    {
        var matrice = matrix_identity_float4x4
        matrice.Pozitie(directie: pozitie)
        matrice.Rotatie(unghi: rotatie.x, axa: AxaX)
        matrice.Rotatie(unghi: rotatie.y, axa: AxaY)
        matrice.Rotatie(unghi: rotatie.z, axa: AxaZ)
        matrice.Marime(axa: marime)
        return matrix_multiply(sef, matrice)
    }
    
    /// Roteste actorul pe XYZ
    func Roteste(x: Float, y: Float, z: Float) {
        var matrice = matrix_identity_float4x4
        matrice.Rotatie(unghi: rotatie.x, axa: AxaX)
        matrice.Rotatie(unghi: rotatie.y, axa: AxaY)
        matrice.Rotatie(unghi: rotatie.z, axa: AxaZ)
        matriceModel.matrice *= matrice
    }
    
    /// Initializeaza actorul
    init(nume: String = "Johnny Sins",
         activ: Bool = true) {
        self.nume = nume
        self.activ = activ
    }
    
    /// Asta trebuie folosta pentru a apela schimbari la inceputul programului
    func Pornire() { }
    
    /// Functie apelata intern la inceputul programului
    func ApelLaInceputulProgramului() {
        if(activ) {
            Pornire()
            matriceModel.matrice = self.matriceaModelului
            for subaltern in subalterni {
                subaltern.ApelLaInceputulProgramului()
            }
        }
        
    }
    
    /// Adauga un actor (child) care sa fie controlat de acest actor (parent)
    func AdaugaUnSubaltern(_ subaltern: Actor){
        subalterni.append(subaltern)
    }
    
    /// Functie folosita extern pentru a apela schimbari in timpul programului (dependent de frame-rate)
    func Updateaza() { }
    
    /// Functie interna ce ruleaza la fiecare reimprospatare de ecran (dependent de frame-rate)
    func Updt() {
        if(activ) {
            Updateaza()
            matriceModel.matrice = self.matriceaModelului
            for subaltern in subalterni {
                subaltern.sef = self.matriceaModelului
                subaltern.Updt()
            }
        }
        
    }
    
    /// Transmite actorul la placa video sa fie afisat pe ecran.
    func Reda(encoder: MTLRenderCommandEncoder) {
        if(activ) {
            for subaltern in subalterni {
                subaltern.Reda(encoder: encoder)
            }
        }
        
    }
}


// Shortcuturi pentru a determina spatiul necesar de diferite tipuri de variabile.
protocol marime{ }
extension marime{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ cantitate: Int)->Int{
        return MemoryLayout<Self>.size * cantitate
    }
    
    static func stride(_ cantitate: Int)->Int{
        return MemoryLayout<Self>.stride * cantitate
    }
}

extension Float: marime { }
extension SIMD2: marime { }
extension SIMD3: marime { }
extension SIMD4: marime { }

struct Vertex: marime{
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

struct Matricee: marime{
    var matrice = matrix_identity_float4x4
}

struct MatriceScena:marime {
    var matriceCamera = matrix_identity_float4x4
    var matriceProiectie = matrix_identity_float4x4
}

