//
//  ContentView.swift
//  AGReality
//
//  Created by Oleksii Mykhalchuk on 2/15/23.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)

        context.coordinator.view = arView

        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap)))
        
        let anchor = AnchorEntity(plane: .horizontal)

//        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.3), materials: [SimpleMaterial(color: .yellow, isMetallic: true)])
//        
//        box.generateCollisionShapes(recursive: true)
//
//        anchor.addChild(box)

        arView.scene.anchors.append(anchor)
        
        return arView
        
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
