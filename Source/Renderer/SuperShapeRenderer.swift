//
//  SuperShapeRenderer.swift
//  SuperShapes
//
//  Created by Reza Ali on 9/4/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Metal
import MetalKit

import Forge
import Satin

class SuperShapeRenderer: Forge.Renderer {
    var updateGeometry = true

    var r1Param = FloatParameter("R1", 1.0, 0, 2)
    var a1Param = FloatParameter("A1", 1.0, 0.0, 5.0)
    var b1Param = FloatParameter("B1", 1.0, 0.0, 5.0)
    var m1Param = FloatParameter("M1", 6, 0, 20)
    var n11Param = FloatParameter("N11", 1.0, 0.0, 100.0)
    var n21Param = FloatParameter("N21", 1.0, 0.0, 100.0)
    var n31Param = FloatParameter("N31", 1.0, 0.0, 100.0)
    var r2Param = FloatParameter("R2", 1.0, 0, 2)
    var a2Param = FloatParameter("A2", 1.0, 0.0, 5.0)
    var b2Param = FloatParameter("B2", 1.0, 0.0, 5.0)
    var m2Param = FloatParameter("M2", 0.0, 0, 20)
    var n12Param = FloatParameter("N12", 1.0, 0.0, 100.0)
    var n22Param = FloatParameter("N22", 1.0, 0.0, 100.0)
    var n32Param = FloatParameter("N32", 1.0, 0.0, 100.0)

    lazy var params: [FloatParameter] = {
        var params: [FloatParameter] = []
        params.append(r1Param)
        params.append(a1Param)
        params.append(b1Param)
        params.append(m1Param)
        params.append(n11Param)
        params.append(n21Param)
        params.append(n31Param)
        params.append(r2Param)
        params.append(a2Param)
        params.append(b2Param)
        params.append(m2Param)
        params.append(n12Param)
        params.append(n22Param)
        params.append(n32Param)        
        return params
    }()
    
    lazy var mesh: Mesh = {
        let mesh = Mesh(geometry: Geometry(), material: BasicDiffuseMaterial(0.7))
        mesh.cullMode = .none
        return mesh
    }()
    
    lazy var scene: Object = {
        let scene = Object()
        scene.add(mesh)
        return scene
    }()
    
    lazy var context: Context = {
        Context(device, sampleCount, colorPixelFormat, depthPixelFormat, stencilPixelFormat)
    }()
    
    lazy var camera: PerspectiveCamera = {
        let camera = PerspectiveCamera()
        camera.position = simd_make_float3(0.0, 0.0, 5.0)
        camera.near = 0.001
        camera.far = 100.0
        return camera
    }()
    
    lazy var cameraController: PerspectiveCameraController = {
        PerspectiveCameraController(camera: camera, view: mtkView)
    }()
    
    lazy var renderer: Satin.Renderer = {
        let renderer = Satin.Renderer(context: context, scene: scene, camera: camera)
        renderer.setClearColor([0.25, 0.25, 0.25, 1])
        return renderer
    }()
        
    override func setupMtkView(_ metalKitView: MTKView) {
        metalKitView.isPaused = false
        metalKitView.sampleCount = 8
        metalKitView.depthStencilPixelFormat = .depth32Float
        metalKitView.preferredFramesPerSecond = 60
    }
    
    override func setup() {
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAppearance),
            name: Notification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
        
        updateAppearance()
        setupObservers()
    }
    
    var observers: [NSKeyValueObservation] = []
        
    func setupGeometry() {
        var geoData = generateSuperShapeGeometryData(
            r1Param.value,
            a1Param.value,
            b1Param.value,
            m1Param.value,
            n11Param.value,
            n21Param.value,
            n31Param.value,
            r2Param.value,
            a2Param.value,
            b2Param.value,
            m2Param.value,
            n12Param.value,
            n22Param.value,
            n32Param.value,
            300, 300)
        mesh.geometry = Geometry(&geoData)
        freeGeometryData(&geoData)
    }
    
    func setupObservers() {
        for param in params {
            observers.append(param.observe(\.value) { [unowned self] _, _ in
                self.updateGeometry = true
            })
        }
    }
        
    @objc func updateAppearance() {
        if let _ = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") {
            renderer.setClearColor([0.125, 0.125, 0.125, 1.0])
        }
        else {
            renderer.setClearColor([0.875, 0.875, 0.875, 1.0])
        }
    }
    
    override func update() {
        if updateGeometry {
            setupGeometry()
            updateGeometry = false
        }
        
        cameraController.update()
        renderer.update()
    }
    
    override func draw(_ view: MTKView, _ commandBuffer: MTLCommandBuffer) {
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        renderer.draw(renderPassDescriptor: renderPassDescriptor, commandBuffer: commandBuffer)
    }
    
    override func resize(_ size: (width: Float, height: Float)) {
        camera.aspect = size.width / size.height
        renderer.resize(size)
    }
}
