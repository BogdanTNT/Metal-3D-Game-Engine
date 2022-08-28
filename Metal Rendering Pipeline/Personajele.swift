//
//  Personajele.swift
//  Proiect Atestat Metal
//
//  Created by Bogdan Rosca on 16/05/2021.
//  Copyright © 2021 Bogdan Rosca. All rights reserved.
//

import Foundation
import MetalKit

/// Aceste personaje sunt deobicei actorii care includ un model 3d
class Personaj: Actor {
    
    // Detalii personalizabile despre personaj
    /// Culoare model 3D
    var culoare: SIMD4<Float>
    var varfuri: MDLMesh!
    var spatiuConsumatDeVarfuri: MTLBuffer!
    /// Shaderul folosit pentru a procesa fiecare punct al modelului
    var vertex_main: String = "vertex_main"
    /// Shaderul folosit pentru a procesa fiecare pixel pe care modelul 3D il acopera
    var fragment_main: String = "fragment_main"
    
    // Lucruri necesare ca actorul sa fie afisat de placa video
    var detalii: MTLRenderPipelineState!
    var adancime: MTLDepthStencilState!
    var numarDeVarfuri: Int!
    var vertices: [SIMD3<Float>] = [[0, 0, 0.5]]
    var model3D: MTKMesh!
    
    override func Updateaza() {
        
    }
    
    init(culoare: SIMD4<Float> = SIMD4<Float>(1, 0, 0, 1),
        model: MDLMesh = Primitive.nimic(dispozitiv: Deseneaza.dispozitiv)) {
        
        self.culoare = culoare
        self.varfuri = model
        
        
        // Transforma modelul 3d standard intr-un document special care poate fi citit de placa video 
        do{
            model3D = try MTKMesh(mesh: varfuri, device: Deseneaza.dispozitiv)
        } catch let error{
            print(error.localizedDescription)
        }
        
        super.init()
    }
    
    override func ApelLaInceputulProgramului() {
        spatiuConsumatDeVarfuri = model3D.vertexBuffers[0].buffer
        
        // Atribuie shaderele pentru model
        let biblioteca = Deseneaza.dispozitiv.makeDefaultLibrary()
        // Seteaza functia de vertex
        let functiePerPunct = biblioteca?.makeFunction(name: vertex_main)
        // Seteaza functia de fragment / pixel
        let functiePerPixel = biblioteca?.makeFunction(name: fragment_main)
        
        
        // Impacheteaza obiectele care o sa fie trimise la placa video
        let detaliiObiect = MTLRenderPipelineDescriptor()
        detaliiObiect.vertexFunction = functiePerPunct
        detaliiObiect.fragmentFunction = functiePerPixel
        detaliiObiect.vertexDescriptor =
            MTKMetalVertexDescriptorFromModelIO(model3D.vertexDescriptor)
        detaliiObiect.colorAttachments[0].pixelFormat = Deseneaza.view.colorPixelFormat
        detaliiObiect.depthAttachmentPixelFormat = .depth32Float
        
        
        
        do{
            detalii = try Deseneaza.dispozitiv.makeRenderPipelineState(descriptor: detaliiObiect)
        } catch let error{
            print("Aici")
            fatalError(error.localizedDescription)
        }
        
        // Setare speciala pentru a putea calcula adancimea
        // Setarea spune ca daca un obiect pozitionat in spatele unui perete, dar calculat dupa acesta, trebuie sa fie ascuns
        let adancimeInitial = MTLDepthStencilDescriptor()
        adancimeInitial.isDepthWriteEnabled = true
        adancimeInitial.depthCompareFunction = .less
        adancime = Deseneaza.dispozitiv.makeDepthStencilState(descriptor: adancimeInitial)
        
        numarDeVarfuri = model3D.vertexCount
        
        super.ApelLaInceputulProgramului()
    }
    
    override func Reda(encoder: MTLRenderCommandEncoder) {
        encoder.pushDebugGroup("Deseneaza \(nume)")
        
        // Compreseaza pachetu care o sa mearga catre placa video
        encoder.setRenderPipelineState(detalii)
        encoder.setDepthStencilState(adancime)
        
        encoder.setVertexBuffer(spatiuConsumatDeVarfuri, offset: 0, index: 0)
        
        encoder.setVertexBytes(&matriceModel, length: Matricee.stride, index: 1)
        
        culoare.w = 0
        encoder.setFragmentBytes(&culoare, length: SIMD4<Float>.stride, index: 1)
        
        for subalterni in model3D.submeshes {
            encoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: subalterni.indexCount,
                                                indexType: subalterni.indexType,
                                                indexBuffer: subalterni.indexBuffer.buffer,
                                                indexBufferOffset: subalterni.indexBuffer.offset)
        }
        encoder.popDebugGroup()
        
        super.Reda(encoder: encoder)
    }
    
}
