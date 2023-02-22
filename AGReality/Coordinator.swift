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

            // create an ancor entity
            let anchor = AnchorEntity(raycastResult: result)

            guard let entity = try? ModelEntity.load(named: "shoe") else { return }

            anchor.addChild(entity)

            // add anchor to the scene
            view.scene.addAnchor(anchor)

        }
    }

}
