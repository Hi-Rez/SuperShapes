//
//  SuperShapeRenderer+Inspector.swift
//  SuperShapes
//
//  Created by Reza Ali on 1/20/21.
//  Copyright © 2021 Reza Ali. All rights reserved.
//

import Satin
import Youi

extension Renderer {
    func setupInspector() {
        var panelOpenStates: [String: Bool] = [:]
        if let inspectorWindow = self.inspectorWindow, let inspector = inspectorWindow.inspectorViewController {
            let panels = inspector.getPanels()
            for panel in panels {
                if let label = panel.parameters?.label {
                    panelOpenStates[label] = panel.open
                }
            }
        }
        
        if inspectorWindow == nil {
            #if os(macOS)
            let inspectorWindow = InspectorWindow("Controls")
            inspectorWindow.setIsVisible(true)
            #elseif os(iOS)
            let inspectorWindow = InspectorWindow("Controls")
            mtkView.addSubview(inspectorWindow.view)
            #endif
            self.inspectorWindow = inspectorWindow
        }
        
        if let inspectorWindow = self.inspectorWindow, let inspectorViewController = inspectorWindow.inspectorViewController {
            if inspectorViewController.getPanels().count > 0 {
                inspectorViewController.removeAllPanels()
            }
            
            inspectorViewController.addPanel(PanelViewController(sceneParams.label, parameters: sceneParams))
            inspectorViewController.addPanel(PanelViewController(params.label, parameters: params))
            
            let panels = inspectorViewController.getPanels()
            for panel in panels {
                if let label = panel.parameters?.label {
                    if let open = panelOpenStates[label] {
                        panel.open = open
                    }
                }
            }
        }
    }

    func updateInspector() {
        if _updateInspector {
            DispatchQueue.main.async { [unowned self] in
                self.setupInspector()
            }
            _updateInspector = false
        }
    }
}
