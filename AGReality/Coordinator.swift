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
        let mesh = MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.3, cornerRadius: 0, splitFaces: true)
        let box = ModelEntity(mesh: mesh)
        cancellable = TextureResource.loadAsync(named: "lola")
            .append(TextureResource.loadAsync(named: "purple_flower"))
            .append(TextureResource.loadAsync(named: "cover.jpg"))
            .append(TextureResource.loadAsync(named: "DSC_0003.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0117.JPG"))
            .append(TextureResource.loadAsync(named: "DSC_0171.JPG"))
            .collect()
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    print("error: \(error)")
                }
                self?.cancellable?.cancel()
            } receiveValue: { textures in
                var materials: [UnlitMaterial] = []

                textures.forEach { texture in
                    var material = UnlitMaterial()
                    material.color = .init(tint: .white, texture: .init(texture))
                    materials.append(material)
                }
                box.model?.materials = materials
                anchor.addChild(box)
                view.scene.addAnchor(anchor)
            }

    }

}
