//
//  Powersystem.swift
//  HackTX
//
//  Created by Hussain Alkatheri on 11/2/24.
//

//@available(iOS 15.0, *)
//class ChangeMeshAndColorSystem: System {
//    static let query = EntityQuery(where:
//                                  .has(ModelComponent.self) &&
//                                  .has(PhysicsBodyComponent.self))
//    
//    required init(scene: Scene) {
//        print("RealityKit's first System is activated")
//    }
//    func update(context: SceneUpdateContext) {
//        context.scene.performQuery(Self.query).forEach { entity in
//            guard let entity = entity as? ModelEntity
//            else { return }
//            entity.model?.mesh = .generateSphere(radius: 0.1)
//            var material = PhysicallyBasedMaterial()
//            material.baseColor.tint = .systemOrange
//            entity.model?.materials = [material]
//        }
//    }
//}

import RealityKit

class alien: Component {
    // Optionally, put any needed state here.
}

class lazar: Component {
    // Optionally, put any needed state here.
}


class Powersystem: System {


    // Define a query to return all entities with a MyComponent.
    private static let query = EntityQuery(where: .has(PhysicsBodyComponent.self))


    // Initializer is required. Use an empty implementation if there's no setup needed.
    required init(scene: Scene) { }


    // Iterate through all entities containing a MyComponent.
    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            // Make per-update changes to each entity here.
//            entity.force
            
        }
    }
}
