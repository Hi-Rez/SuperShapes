//
//  VisualEffectView.swift
//  SuperShapes
//
//  Created by Reza Ali on 1/20/21.
//  Copyright © 2021 Reza Ali. All rights reserved.
//

import SwiftUI
#if os(macOS)
import Cocoa
import AppKit

struct VisualEffectView: NSViewRepresentable
{
    var material: NSVisualEffectView.Material = .sidebar
    var blendingMode: NSVisualEffectView.BlendingMode  = .withinWindow
    var isEmphasized: Bool = true

    func makeNSView(context: Self.Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Self.Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.isEmphasized = isEmphasized
    }
}
#elseif os(iOS)

struct VisualEffectView: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

#endif

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        VisualEffectView().frame(width: 100, height: 100)
    }
}


