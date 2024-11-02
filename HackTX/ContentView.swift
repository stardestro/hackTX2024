//
//  ContentView.swift
//  HackTX
//
//  Created by Sevastian Aguilera on 11/2/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {

    var body: some View {
        RealityView { content in

            // Create a cube model
//            let model = Entity()
            let model = ModelEntity()
            let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
            let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
            model.components.set(ModelComponent(mesh: mesh, materials: [material]))
//            model.
            model.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
            model.generateCollisionShapes(recursive: true)
            model.physicsBody?.isAffectedByGravity = false
            model.position = [0, 0.1, -0.3]
//            let shape = ShapeResource.generateBox(size: [0.1,0.1,0.1])
//            model.components.set(CollisionComponent(shapes: [shape]))
//            var physicspart = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
//            physicspart.isAffectedByGravity = false
//            model.components.set(physicspart)
//            model.physicsMotion = PhysicsMotionComponent()
            
//            model.components.set(PhysicsBodyComponent())
//            model.physicsBody?.isAffectedByGravity = true
            
//            model.physicsBody = physicspart
            // Create horizontal plane anchor for the content
            let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
//            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "apriltag.jpg"))
//            anchor.addChild(model)
//            let anchor = AnchorEntity(.camera)
            
            let impulseStrength = SIMD3<Float>(0, 0, 1)
            let impulseDirection = SIMD3<Float>(0, 0, 1)
//            model.applyLinearImpulse(impulseStrength * impulseDirection, relativeTo: model)
            model.applyLinearImpulse(SIMD3<Float>(0, 0, 0.2), relativeTo: model)
            anchor.addChild(model)
            
//            model.components.physic

            // Add the horizontal plane anchor to the scene
            content.add(anchor)
            
//            model.transform.translation = [0,0,-0.5]

            content.camera = .spatialTracking
            
//            model.modelDebugOptions = ModelDebugOptionsComponent(visualizationMode: .normal)

        }
        .edgesIgnoringSafeArea(.all)
    }

}

#Preview {
    ContentView()
}
