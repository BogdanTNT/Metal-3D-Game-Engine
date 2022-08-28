//
//  Prezentare.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 20/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import MetalKit

/// Aceasta clasa contine toate detalii despre scena care o sa fie prezentata.
/// In acest moment este prezentarea redarii unor modele 3d care reprezinta slideuri pt Atestatul la infomatica
class Prezentare: Scena {
    
    var x: Float = 0
    var da: Float = 0
    
    // Alb
    var fundal1: Personaj!
    // cce8f4
    var fundal2: Personaj!
    // a3c1d9
    var fundal3: Personaj!
    var planFundal: Personaj!
    
    var chadCamera: Actor!
    
    var slideuri: [Personaj] = []
    
    override func Pornire() {
        chadCamera = Actor()
        AdaugaUnSubaltern(chadCamera)
        
        fundal1 = Personaj(culoare: SIMD4<Float>(1, 1, 1, 1), model: Primitive.importa(numeFisier: "cce8f4"))
        fundal2 = Personaj(culoare: SIMD4<Float>(204/255, 232/255, 244/255, 1), model: Primitive.importa(numeFisier: "Alb"))
        fundal3 = Personaj(culoare: SIMD4<Float>(163/255, 193/255, 217/255, 1), model: Primitive.importa(numeFisier: "a3c1d9"))
        planFundal = Personaj(culoare: SIMD4<Float>(163/255, 193/255, 217/255, 1), model: Primitive.importa(numeFisier: "Planula3c1d9"))
        
        fundal1.marime *= 500
        fundal2.marime *= 500
        fundal3.marime *= 500
        planFundal.marime *= 500
        
        fundal1.pozitie.y -= 100
        fundal2.pozitie.y -= 100
        fundal3.pozitie.y -= 100
        planFundal.pozitie.y -= 100
        
        AdaugaUnSubaltern(fundal1)
        AdaugaUnSubaltern(fundal2)
        AdaugaUnSubaltern(fundal3)
        AdaugaUnSubaltern(planFundal)
        
        let nimic = Personaj()
        slideuri.append(nimic)
        
        // Importa slideurile
        for i in 1 ... 6 {
            print(i)
            let nume = "S"
            
            let slide = Personaj(model: Primitive.importa(numeFisier: nume + String(i)))//\(i)"))
            slideuri.append(slide)

            AdaugaUnSubaltern(slideuri[i])
        }
        
        // Coloeaza fiecare slide in functie de ce culoare vreau eu
        slideuri[1].culoare = SIMD4<Float>(0.41, 0.41, 0.41, 1)
        slideuri[2].culoare = SIMD4<Float>(0, 0, 0, 1)
        slideuri[3].culoare = SIMD4<Float>(0.098, 0.098, 112/255, 1)
        slideuri[5].culoare = SIMD4<Float>(173/255, 135/255, 98/255, 1)
        slideuri[6].culoare = SIMD4<Float>(1/255, 100/255, 1/255, 1)
        
        // Pentru a nu roti camera-mama, o sa rotesc o camera-parinte care va avea camera-mama ca subaltern
        chadCamera.AdaugaUnSubaltern(camera)
        
        // Potizitia si rotatia initiala a camerei
        let rot:Float
        rot = 175 + 45
        
        chadCamera.rotatie.y -= rot.inGrade
        chadCamera.pozitie.y += 50
    }
    
    override func Updateaza() {
        let viteza:Float = 1
        
        x += 1/60
        
        slideuri[4].culoare = SIMD4<Float>(Mate.rgb(h: (x * 50).truncatingRemainder(dividingBy: 360), s: 0.7, b: 0.85), 1)
        
//        print("Work")
        
        // Controlul camerei video de catre player
        if(Tastatura.ActivitateTasta(.w)){
            chadCamera.pozitie -= chadCamera.inFata
        }
        if(Tastatura.ActivitateTasta(.s)){
            chadCamera.pozitie += chadCamera.inFata
        }
        if(Tastatura.ActivitateTasta(.a)){
            chadCamera.pozitie -= chadCamera.laDreapta
        }
        if(Tastatura.ActivitateTasta(.d)) {
            chadCamera.pozitie += chadCamera.laDreapta
        }
        if(Tastatura.ActivitateTasta(.space)){
            chadCamera.pozitie.y += viteza
        }
        if(Tastatura.ActivitateTasta(.z)){
            chadCamera.pozitie.y -= viteza
        }
        if(Tastatura.ActivitateTasta(.leftArrow)) {
            chadCamera.rotatie.y += deltaTime
        }
        if(Tastatura.ActivitateTasta(.rightArrow)) {
            chadCamera.rotatie.y -= deltaTime
        }
        if(Tastatura.ActivitateTasta(.upArrow)){
            camera.rotatie.x += deltaTime
        }
        if(Tastatura.ActivitateTasta(.downArrow)){
            camera.rotatie.x -= deltaTime
        }
        
    }
    
}





class Test: Scena {
    var nrSlideuri = 16
    var slideulActual = 1
    
    var x: Float = 0
    var da: Float = 0
    
    // Alb
    var fundal1: Personaj!
    // cce8f4
    var fundal2: Personaj!
    // a3c1d9
    var fundal3: Personaj!
    var planFundal: Personaj!
    
    var chadCamera: Actor!
    
    var slideuri: [Personaj] = []
    
    override func Pornire() {
        chadCamera = Actor()
        AdaugaUnSubaltern(chadCamera)
        
        fundal1 = Personaj(culoare: SIMD4<Float>(1, 1, 1, 1), model: Primitive.importa(numeFisier: "cce8f4"))
        fundal2 = Personaj(culoare: SIMD4<Float>(204/255, 232/255, 244/255, 1), model: Primitive.importa(numeFisier: "Alb"))
        fundal3 = Personaj(culoare: SIMD4<Float>(163/255, 193/255, 217/255, 1), model: Primitive.importa(numeFisier: "a3c1d9"))
        planFundal = Personaj(culoare: SIMD4<Float>(163/255, 193/255, 217/255, 1), model: Primitive.importa(numeFisier: "Planula3c1d9"))
        
        fundal1.marime *= 50
        fundal2.marime *= 50
        fundal3.marime *= 50
        planFundal.marime *= 50
        
//        fundal1.pozitie.y += 30
//        fundal2.pozitie.y += 30
//        fundal3.pozitie.y += 30
//        planFundal.pozitie.y += 30
        
        AdaugaUnSubaltern(fundal1)
        AdaugaUnSubaltern(fundal2)
        AdaugaUnSubaltern(fundal3)
        AdaugaUnSubaltern(planFundal)
        
        let nimic = Personaj()
        slideuri.append(nimic)
        
        for i in 1 ... nrSlideuri {
            print(i)
            let slide = Personaj(model: Primitive.importa(numeFisier: "Slide1"))//\(i)"))
            slideuri.append(slide)
            slideuri[i].rotatie.y = (Float)(90 * (i - 1)).inRadiani
            
            if(i < 5) {
                slideuri[i].activ = true
            } else {
                slideuri[i].activ = false
            }
            
            AdaugaUnSubaltern(slideuri[i])
        }
        chadCamera.AdaugaUnSubaltern(camera)
//        camera.pozitie.y = 55
        
//        let masina = Personaj(model: Primitive.importa(numeFisier: "f1_high"))
        
        
    }
    
    override func Updateaza() {
        
        let viteza:Float = 1
        
        x += 1/60
        
        if(Tastatura.ActivitateTasta(.space))
        {
            da += 90
            slideulActual += 1
            if(slideulActual > 4){
                slideuri[slideulActual].activ = true
                slideuri[slideulActual - 4].activ = false
            }
        }

        
        
        if(Tastatura.ActivitateTasta(.w)){
            chadCamera.pozitie -= chadCamera.inFata
        }
        if(Tastatura.ActivitateTasta(.s)){
            chadCamera.pozitie += chadCamera.inFata
        }
        if(Tastatura.ActivitateTasta(.a)){
            chadCamera.pozitie -= chadCamera.laDreapta
        }
        if(Tastatura.ActivitateTasta(.d)) {
            chadCamera.pozitie += chadCamera.laDreapta
        }
        if(Tastatura.ActivitateTasta(.space)){
            chadCamera.pozitie.y += viteza
        }
        if(Tastatura.ActivitateTasta(.z)){
            chadCamera.pozitie.y -= viteza
        }
        if(Tastatura.ActivitateTasta(.leftArrow)) {
            chadCamera.rotatie.y += deltaTime
        }
        if(Tastatura.ActivitateTasta(.rightArrow)) {
            chadCamera.rotatie.y -= deltaTime
        }
        if(Tastatura.ActivitateTasta(.upArrow)){
            camera.rotatie.x += deltaTime
        }
        if(Tastatura.ActivitateTasta(.downArrow)){
            camera.rotatie.x -= deltaTime
        }
        
        slideuri[slideulActual].culoare = SIMD4<Float>(Mate.rgb(h: (x * 50).truncatingRemainder(dividingBy: 360), s: 0.7, b: 1), 1)

    }
}
