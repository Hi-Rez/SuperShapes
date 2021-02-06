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
import Youi

class Renderer: Forge.Renderer, ObservableObject {
    var inspectorWindow: InspectorWindow?
    var _updateInspector: Bool = true
    
    var observers: [NSKeyValueObservation] = []
    
    var updateGeometry = true

    lazy var wireframeParam: BoolParameter = {
        var param = BoolParameter("Wireframe", false, .toggle, { [unowned self] value in
            self.mesh.triangleFillMode = value ? .lines : .fill
        })
        return param
    }()
    
    
    var bgColorParam = Float4Parameter("Background", [0, 0, 0, 1], .colorpicker)
    
    var resParam = IntParameter("Resolution", 300, 3, 300, .slider)
    var r1Param = FloatParameter("R1", 1.0, 0, 2, .inputfield)
    var a1Param = FloatParameter("A1", 1.0, 0.0, 5.0, .slider)
    var b1Param = FloatParameter("B1", 1.0, 0.0, 5.0, .slider)
    var m1Param = FloatParameter("M1", 6, 0, 20, .slider)
    var n11Param = FloatParameter("N11", 1.0, 0.0, 100.0, .slider)
    var n21Param = FloatParameter("N21", 1.0, 0.0, 100.0, .slider)
    var n31Param = FloatParameter("N31", 1.0, 0.0, 100.0, .slider)
    var r2Param = FloatParameter("R2", 1.0, 0, 2, .slider)
    var a2Param = FloatParameter("A2", 1.0, 0.0, 5.0, .slider)
    var b2Param = FloatParameter("B2", 1.0, 0.0, 5.0, .slider)
    var m2Param = FloatParameter("M2", 0.0, 0, 20, .slider)
    var n12Param = FloatParameter("N12", 1.0, 0.0, 100.0, .slider)
    var n22Param = FloatParameter("N22", 1.0, 0.0, 100.0, .slider)
    var n32Param = FloatParameter("N32", 1.0, 0.0, 100.0, .slider)

    lazy var sceneParams: ParameterGroup = {
        var params = ParameterGroup("Scene Controls")
        params.append(bgColorParam)
        return params
    }()
    
    lazy var params: ParameterGroup = {
        var params = ParameterGroup("Shape Controls")
        params.append(wireframeParam)
        params.append(resParam)
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
        let pos = simd_make_float3(4.0, 2.5, 4.0)
        let camera = PerspectiveCamera(position: pos, near: 0.001, far: 200.0)
        camera.label = "Perspective Camera"
        camera.fov = 30

        camera.orientation = simd_quatf(from: Satin.worldForwardDirection, to: simd_normalize(pos))

        let forward = simd_normalize(camera.forwardDirection)
        let worldUp = Satin.worldUpDirection
        let right = -simd_normalize(simd_cross(forward, worldUp))
        let angle = acos(simd_dot(simd_normalize(camera.rightDirection), right))

        camera.orientation = simd_quatf(angle: angle, axis: forward) * camera.orientation
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
        metalKitView.sampleCount = 4
        metalKitView.depthStencilPixelFormat = .depth32Float
        metalKitView.preferredFramesPerSecond = 60
    }
    
    override func setup() {
        updateAppearance()
        setupObservers()
    }
        
    func setupGeometry() {
        let res = Int32(resParam.value)
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
            res, res)
        mesh.geometry = Geometry(&geoData)
        freeGeometryData(&geoData)
    }
    
    func setupObservers() {
        for param in params.params {
            if let p = param as? FloatParameter {
                observers.append(p.observe(\.value) { [unowned self] _, _ in
                    self.updateGeometry = true
                })
            }
            else if let p = param as? IntParameter {
                observers.append(p.observe(\.value) { [unowned self] _, _ in
                    self.updateGeometry = true
                })
            }
        }
        
        
        let bgColorCb: (Float4Parameter, NSKeyValueObservedChange<Float>) -> Void = { [unowned self] _, _ in
            self.updateBackgroundColor()
        }
        observers.append(bgColorParam.observe(\.x, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.y, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.z, changeHandler: bgColorCb))
        observers.append(bgColorParam.observe(\.w, changeHandler: bgColorCb))
    }
    
    func updateBackgroundColor()
    {
        let c = self.bgColorParam.value
        let red = Double(c.x)
        let green = Double(c.y)
        let blue = Double(c.z)
        let alpha = Double(c.w)
        let clearColor: MTLClearColor = .init(red: red, green: green, blue: blue, alpha: alpha)
        self.renderer.clearColor = clearColor
    }
    
    override func updateAppearance() {
        switch appearance {
        case .dark:
            bgColorParam.value = [0.125, 0.125, 0.125, 1.0]
        case .light:
            bgColorParam.value = [0.875, 0.875, 0.875, 1.0]
        }
    }
    
    
    
    override func update() {
        if updateGeometry {
            setupGeometry()
            updateGeometry = false
        }
        
        
        updateInspector()
        cameraController.update()
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
