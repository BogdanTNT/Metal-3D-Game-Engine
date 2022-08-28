//
//  Primitive.swift
//  Metal Rendering Pipeline
//
//  Created by Bogdan Rosca on 17/07/2020.
//  Copyright © 2020 Bogdan Rosca. All rights reserved.
//

import Foundation
import MetalKit

/// Creaza/Importa modele 3D
class Primitive{
    /// Creaza un cub saracios
    static func creazaCub(dispozitiv: MTLDevice, marime: Float) -> MDLMesh{
        let spatiuAlocat = MTKMeshBufferAllocator(device: dispozitiv)
        
        let mesh = MDLMesh(boxWithExtent: [marime, marime, marime], segments: [1, 1, 1], inwardNormals: false, geometryType: .triangles, allocator: spatiuAlocat)
        
        return mesh
    }
    
    /// Creaza o sfera saracacioasa
    static func creazaSfera(dispozitiv: MTLDevice, marime: Float, segmente: UInt32) -> MDLMesh{
        let spatiuAlocat = MTKMeshBufferAllocator(device: dispozitiv)
        
        let mesh = MDLMesh(sphereWithExtent: [marime, marime, marime], segments: [segmente, segmente], inwardNormals: false, geometryType: .triangles, allocator: spatiuAlocat)
        
        return mesh
    }
    
    /// Creaza nimic, e un fel de a spune
    static func nimic(dispozitiv: MTLDevice) -> MDLMesh{
        let spatiuAlocat = MTKMeshBufferAllocator(device: dispozitiv)
        
        let mesh = MDLMesh(bufferAllocator: spatiuAlocat)
        
        return mesh
    }
    
    /// Importa un fisier cu un model 3D din proiect.
    static func importa(numeFisier: String = "f1_high") -> MDLMesh{
        guard
            let adresaObiect = Bundle.main.url(forResource: numeFisier, withExtension: "obj")
        else
        {
            print(numeFisier)
            fatalError()
        }
        
        let detaliiObiect =  MTLVertexDescriptor()
        
        //Pozitie
        detaliiObiect.attributes[0].format = .float3
        detaliiObiect.attributes[0].offset = 0
        detaliiObiect.attributes[0].bufferIndex = 0
        
        detaliiObiect.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(detaliiObiect)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let alocator = MTKMeshBufferAllocator(device: Deseneaza.dispozitiv)
        
        let obiect = MDLAsset(url: adresaObiect,
                             vertexDescriptor: meshDescriptor,
                             bufferAllocator: alocator)
        let mdlMesh = obiect.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        return mdlMesh
    }
    
}
