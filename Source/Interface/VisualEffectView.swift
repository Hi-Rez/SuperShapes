//
//  Blur.swift
//  SuperShapes
//
//  Created by Reza Ali on 9/7/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import Cocoa
import AppKit
import SwiftUI

import SwiftUI

struct VisualEffectView: NSViewRepresentable
{
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

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
    }
}
