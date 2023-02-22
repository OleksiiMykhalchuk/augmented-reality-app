//
//  Coordinator.swift
//  AGReality
//
//  Created by Oleksii Mykhalchuk on 2/15/23.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coordinator: NSObject {

    weak var view: ARView?
    var cancellable: AnyCancellable?

    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {

        guard let view = self.view else { return }

        guard view.scene.anchors.first(where: { $0.name == "LunarRoverAnchor" }) == nil else {
            return
        }

        let tapLocation = recognizer.location(in: view)

        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)

        if let result = results.first {

            // create an ancor entity
            let anchor = AnchorEntity(raycastResult: result)

            cancellable = ModelEntity.loadAsync(named: "LunarRover")
                .sink { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Unable to load model")
                    }

                    self.cancellable?.cancel()
                } receiveValue: { entity in
                    anchor.name = "LunarRoverAnchor"
                    anchor.addChild(entity)

                }


            // add anchor to the scene
            view.scene.addAnchor(anchor)

        }
    }

    func setup() {

        guard let view = view else {
            return
        }

        let anchor = AnchorEntity(plane: .horizontal)
        let mesh = MeshResource.generateBox(size: 0.3)
        let box = ModelEntity(mesh: mesh)

        let texture = try? TextureResource.load(named: "purple_flower")
        if let texture = texture {
            var material = UnlitMaterial()
            material.color = .init(tint: .white, texture: .init(texture))
            box.model?.materials = [material]
        }
        anchor.addChild(box)
        view.scene.addAnchor(anchor)
    }

}
