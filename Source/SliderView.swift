//
//  SliderView.swift
//  sui
//
//  Created by Reza Ali on 9/6/20.
//  Copyright © 2020 Reza Ali. All rights reserved.
//

import SwiftUI

import Satin
import Youi

struct SliderView: NSViewControllerRepresentable {
    var parameter: FloatParameter
    
    func makeNSViewController(context: Self.Context) -> Self.NSViewControllerType {
        let vc = SliderViewController()
        vc.parameter = parameter
        return vc
    }

    func updateNSViewController(_ nsViewController: Self.NSViewControllerType, context:  Self.Context) {
        print("Update SliderView")
    }

    typealias NSViewControllerType = Youi.SliderViewController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: SliderView
        init(_ parent: SliderView) {
            self.parent = parent
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView(parameter: FloatParameter("Testing", 0.5))
    }
}

