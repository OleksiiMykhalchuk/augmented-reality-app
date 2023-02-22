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

        guard let url = Bundle.main.url(forResource: "production ID_3818213", withExtension: "mp4") else {
            print("Video is not found")
            return arView
        }

        let player = AVPlayer(url: url)

        let material = VideoMaterial(avPlayer: player)

        material.controller.audioInputMode = .spatial

        let modelEntity = ModelEntity(mesh: MeshResource.generatePlane(width: 0.5, depth: 0.5), materials: [material])

        player.play()

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
