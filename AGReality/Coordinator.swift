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

        let tapLocation = recognizer.location(in: view)

        let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)

        if let result = results.first {

            // create an ancor entity
            let anchor = AnchorEntity(raycastResult: result)

            cancellable = ModelEntity.loadAsync(named: "shoe")
                .append(ModelEntity.loadAsync(named: "teapot"))
                .collect()
                .sink { loadCompletion in
                    if case let .failure(error) = loadCompletion {
                        print("Unable to load model")
                    }

                    self.cancellable?.cancel()
                } receiveValue: { entities in

                    var x: Float = 0.0

                    entities.forEach {
                        $0.position = simd_make_float3(x,0,0)
                        anchor.addChild($0)
                        x += 0.3
                    }

                }


            // add anchor to the scene
            view.scene.addAnchor(anchor)

        }
    }

}
