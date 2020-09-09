//
//  MetalView.swift
//  sui
//
//  Created by Reza Ali on 9/4/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import SwiftUI

import Forge
import MetalKit

struct MetalView: NSViewControllerRepresentable {
    var renderer: SuperShapeRenderer
    typealias NSViewControllerType = Forge.ViewController
    
    func makeNSViewController(context: Self.Context) -> Self.NSViewControllerType {
        let vc = Forge.ViewController(nibName: .init("ViewController"), bundle: Bundle(for: Forge.ViewController.self))
        print("Making Renderer")
        vc.renderer = renderer
        return vc
    }
    
    func updateNSViewController(_ nsViewController: Self.NSViewControllerType, context: Self.Context) {
        print("Update MetalView")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: MetalView
        init(_ parent: MetalView) {
            self.parent = parent
        }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView(renderer: SuperShapeRenderer())
    }
}
