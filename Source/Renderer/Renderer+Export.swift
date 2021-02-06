//
//  Renderer+Export.swift
//  SuperShapes
//
//  Created by Reza Ali on 1/20/21.
//  Copyright © 2021 Reza Ali. All rights reserved.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

import Satin
import ModelIO

extension Renderer {
    func exportObj() {
        #if os(macOS)
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.showsTagField = false
        panel.nameFieldStringValue = ".obj"
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        panel.begin { result in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue, let url = panel.url {
                self.exportObj(url)
            }
        }
        #endif
    }
    
    func exportObj(_ url: URL) {
        guard let indexBuffer = mesh.geometry.indexBuffer else { return }
        
        let allocator = MDLMeshBufferDataAllocator()
        let asset = MDLAsset(bufferAllocator: allocator)
        
        let geometry = mesh.geometry
        
        let vertexCount = geometry.vertexData.count
        let vertexStride = MemoryLayout<Vertex>.stride
        
        let indexCount = geometry.indexData.count
        let bytesPerIndex = MemoryLayout<UInt32>.size
        
        let byteCountVertices = vertexCount * vertexStride
        let byteCountFaces = indexCount * bytesPerIndex
        
        var vertexData: [Vertex] = []
        for var vertex in geometry.vertexData {
            vertex.position = mesh.worldMatrix * vertex.position
            vertexData.append(vertex)
        }
        
        vertexData.withUnsafeMutableBufferPointer { vertexPointer in
            let mdlVertexBuffer = allocator.newBuffer(with: Data(bytesNoCopy: vertexPointer.baseAddress!, count: byteCountVertices, deallocator: .none), type: .vertex)
            let mdlIndexBuffer = allocator.newBuffer(with: Data(bytesNoCopy: indexBuffer.contents(), count: byteCountFaces, deallocator: .none), type: .index)
                
            let submesh = MDLSubmesh(indexBuffer: mdlIndexBuffer, indexCount: geometry.indexData.count, indexType: .uInt32, geometryType: .triangles, material: nil)
            
            let mesh = MDLMesh(vertexBuffer: mdlVertexBuffer, vertexCount: geometry.vertexData.count, descriptor: SatinModelIOVertexDescriptor(), submeshes: [submesh])
            asset.add(mesh)

            if MDLAsset.canExportFileExtension("obj") {
                print("can export objs")
                do {
                    try asset.export(to: url)
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                fatalError("Can't export OBJ")
            }
        }
    }
}
