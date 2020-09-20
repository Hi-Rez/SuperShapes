//
//  ContentView.swift
//  SuperShapes
//
//  Created by Reza Ali on 9/4/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Satin
import SwiftUI

struct ContentView: View {    
    @State var controlsVisible = false
    @State var controlsOffset = CGSize.zero
    
    var metalView: MetalView
    var renderer: SuperShapeRenderer
    
    var animation: Animation = .spring(response: 0.35, dampingFraction: 0.6, blendDuration: 0)
    
    var drag: some Gesture {
        print("creating drag gestures")
        return DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                self.renderer.cameraController.disable()
                print("V-Dragged Change: \(value)")
                self.controlsOffset = value.translation
            }
            .onEnded { value in
                print("V-Dragged Ended: \(value)")
                self.renderer.cameraController.enable()
                if self.controlsOffset.width < -25 {
                    self.controlsVisible = false
                }
                self.controlsOffset = .zero
            }
    }
    
    init() {
        print("Creating MetalView")
        renderer = SuperShapeRenderer()
        metalView = MetalView(renderer: renderer)
    }
    
    var body: some View {
        ZStack {
            self.metalView.edgesIgnoringSafeArea(.all).frame(minWidth: 512, minHeight: 512)
            
            // Controls Button
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    TransparentButton(image: Image("Slider_Small"), imageSize: 24) {
                        print("Expose Controls")
                        self.controlsVisible.toggle()
                    }
                    .opacity(controlsVisible ? 0.5 : 1.0)
                    .offset(x: controlsOffset.width)
                    .animation(animation)
                    Spacer()
                }
                .offset(x: controlsVisible ? 240 + 16 : 0)
                .background(Color.white.opacity(0.001))
                Spacer()
            }
            .padding()
            .zIndex(1.0)
            
            // Actual Controls
            ZStack {
                HStack {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 0) {
                            
                                Text("Supershape Controls")
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
//                                    .background(Color.green)
                            
                            Divider()
                            ForEach(renderer.params, id: \.label) { item in
                                Group {
                                    SliderView(parameter: item).frame(height: 48)
//                                        .background(Color.blue)
                                    Divider()
                                }
                            }
                        }
                        .gesture(drag)
                    }
                    .onHover(perform: { hover in
                        if hover {
                            self.renderer.cameraController.disable()
                        }
                        else {
                            self.renderer.cameraController.enable()
                        }
                    })
                    .frame(maxWidth: 240)
                    .background(
                        VisualEffectView(
                            material: .headerView,
                            blendingMode: .withinWindow
                        )
                    )
                    .cornerRadius(8)
                    .offset(x: controlsVisible ? 0 : -240 - 32)
                    .offset(x: controlsOffset.width)
                    .animation(animation)
                    Spacer()
                }
                .padding()
            }
            
            // Share
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    TransparentButton(image: Image("Share_Small"), imageSize: 24, imageOffsetY: -1.0) {
                        print("Implement Exporting")
                    }
                }
                .padding()
            }.zIndex(2.0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TransparentButton: View {
    var action: (() -> Void)?
    var image: Image
    var imageSize: CGFloat
    var imageOffsetX: CGFloat = 0.0
    var imageOffsetY: CGFloat
    
    init(image: Image, imageSize: CGFloat, imageOffsetX: CGFloat = 0.0, imageOffsetY: CGFloat = 0.0, action: (() -> Void)?) {
        self.image = image
        self.imageSize = imageSize
        self.imageOffsetX = imageOffsetX
        self.imageOffsetY = imageOffsetY
        self.action = action
    }
    
    var body: some View {
        Button(action: ((action != nil) ? action! : {})) {
            self.image
                .resizable()
                .offset(x: self.imageOffsetX, y: self.imageOffsetY)
                .aspectRatio(contentMode: .fit)
                .frame(width: self.imageSize, height: self.imageSize)
                .foregroundColor(Color.white)
        }
        .frame(width: 44, height: 44)
        .buttonStyle(BorderlessButtonStyle())
        .background(Color("Button"))
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.66), radius: 16, x: 0, y: 4)
    }
}
