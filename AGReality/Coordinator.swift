//
//  Coordinator.swift
//  AGReality
//
//  Created by Oleksii Mykhalchuk on 2/15/23.
//

import Foundation
import ARKit
import RealityKit

class Coordinator: NSObject {

    weak var view: ARView?

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {

        guard let view = self.view else { return }

        let tapLocation = recognizer.location(in: view)

        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)

        if let result = results.first {

            let anchorEntity = AnchorEntity(raycastResult: result)

            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.1))
            modelEntity.generateCollisionShapes(recursive: true)

            modelEntity.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]


            anchorEntity.addChild(modelEntity)

            view.scene.addAnchor(anchorEntity)

            view.installGestures(.all ,for: modelEntity)


        }
    }

}
