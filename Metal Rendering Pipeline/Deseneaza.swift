//
//  Deseneaza.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 17/07/2020.
//  Copyright © 2020 Bogdan Rosca. All rights reserved.
//

import Foundation
import MetalKit
import simd

class Deseneaza: NSObject{
    
    public static var marimeEcran = SIMD2<Float>(0,0)
    public static var latimePeIntaltime: Float {
        return marimeEcran.x / marimeEcran.y
    }
    
    /// Dispozitivul pe care ruleaza acest program
    static var dispozitiv: MTLDevice!
    
    /// Lista cu detalii pentru a reda pe ecran
    static var pachetScena: MTLCommandQueue!
    
    static var view: MTKView!
    
    static var viewCon: ViewController!
    
    var prezentare = Prezentare()
    
    init(metalView: MTKView){
        Deseneaza.marimeEcran = SIMD2<Float>(Float(metalView.bounds.width), Float(metalView.bounds.height))
        
        // Creat referinta dispozitiv si lista de lucruri de redat
        guard
            let dispozitiv = MTLCreateSystemDefaultDevice(),
            let pachetScena = dispozitiv.makeCommandQueue()
        else
        {
            fatalError("Procesorul video a cedat ( ͡° ͜ʖ ͡°)")
        }
        
        Deseneaza.dispozitiv = dispozitiv
        Deseneaza.pachetScena = pachetScena
        metalView.device = dispozitiv
        Deseneaza.view = metalView
        
        metalView.depthStencilPixelFormat = .depth32Float
        
        prezentare.ApelLaInceputulProgramului()
        
        super.init()
        
        // Setarea culorii fundalului in RGBA
        metalView.clearColor = MTLClearColor(red: 55/255, green: 185/255, blue: 227/255, alpha: 1.0)
        metalView.delegate = self
    }
    
}

extension Deseneaza: MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize){
        Deseneaza.marimeEcran = SIMD2<Float>(Float(view.bounds.width), Float(view.bounds.height))
    }
    
    func draw(in view:MTKView){
        
        // Se creaza curierul
        guard
            let curierulCareTinePachetul = Deseneaza.pachetScena.makeCommandBuffer(),
            let detaliiObiectFinal = curierulCareTinePachetul.makeRenderCommandEncoder(descriptor: view.currentRenderPassDescriptor!)
        else {
            return
        }
        
        prezentare.PuneInMiscareScena(encoder: detaliiObiectFinal)
        
        detaliiObiectFinal.endEncoding()
        
        // Deseneaza pe ecran
        guard let drawable = view.currentDrawable else{
            return
        }
        
        curierulCareTinePachetul.present(drawable)
        curierulCareTinePachetul.commit()
    }

}
// Motivatia alegerii proiectului
// Apicabilitatea proiectului
// Titlu e heading 1
// Subtitlu e heading 2
