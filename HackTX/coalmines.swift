//
//  coalmines.swift
//  HackTX
//
//  Created by Hussain Alkatheri on 11/2/24.
//

import Foundation
import RealityKit
import Combine

struct coalspawner: Component {
    // Optionally, put any needed state here.
    var previousDate: Date?
}


class coalSpawnersystem: System {


    // Define a query to return all entities with a MyComponent.
    private static let query = EntityQuery(where: .has(coalspawner.self))


    // Initializer is required. Use an empty implementation if there's no setup needed.
    required init(scene: Scene) { }


    // Iterate through all entities containing a MyComponent.
    func update(context: SceneUpdateContext) {
        for entity in context.entities(
            matching: Self.query,
            updatingSystemWhen: .rendering
        ) {
            // Make per-update changes to each entity here.
//            if(entity.components.previousDate < Date()){
//
//            }
            
        }
    }
}


class spawner: NSObject
{
    private var anchor: AnchorEntity!
    
    func spawnloadtimer()
    {
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(spawnload), userInfo: nil, repeats: true)
    }
    
    @objc func spawnload(){
        let box = ModelEntity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        box.components.set(ModelComponent(mesh: mesh, materials: [material]))
        box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
        box.generateCollisionShapes(recursive: true)
        box.physicsBody?.isAffectedByGravity = false
        box.position = [0, 0.5, 0]
//            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
        box.applyLinearImpulse(SIMD3<Float>(0, 0, -0.2), relativeTo: nil)
        
        anchor.addChild(box)
    }
}
