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
        let box = ModelEntity(mesh: MeshResource.generateBox(size: 0.2), materials: [OcclusionMaterial()])
        box.generateCollisionShapes(recursive: true)
        view.installGestures(.all,for: box)

        cancellable = ModelEntity.loadAsync(named: "robot")
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("Unable to load the model \(error)")
                }
                self?.cancellable?.cancel()
            } receiveValue: { entity in
                anchor.addChild(entity)
            }

        anchor.addChild(box)
        view.scene.addAnchor(anchor)
    }

}
