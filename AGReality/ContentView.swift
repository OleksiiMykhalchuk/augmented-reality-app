//
//  ContentView.swift
//  AGReality
//
//  Created by Oleksii Mykhalchuk on 2/15/23.
//

import SwiftUI
import RealityKit
import AVFoundation

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        let anchor = AnchorEntity(plane: .horizontal)

        let modelEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.2), materials: [UnlitMaterial(color: .blue)])

        anchor.addChild(modelEntity)

        arView.scene.addAnchor(anchor)

        return arView
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#endif
