//
//  ContentView.swift
//  HackTX
//
//  Created by Sevastian Aguilera on 11/2/24.
//

import SwiftUI
import RealityKit
import Combine
import ARKit




struct ContentView : View {
    
    @State var collisionSubscriptions = [RealityFoundation.EventSubscription]()
    
    @State var rootNode: Entity = Entity()
    @State var cameraNode: AnchorEntity = AnchorEntity()
    @State var bullet: ModelEntity = ModelEntity()
    
    
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func spawn(position: SIMD3<Float>) {
        let box = ModelEntity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
        box.components.set(ModelComponent(mesh: mesh, materials: [material]))
        box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
        box.generateCollisionShapes(recursive: true)
        box.physicsBody?.isAffectedByGravity = false
        box.position = position
//            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
        box.applyLinearImpulse(SIMD3<Float>(0, 0, 0.2), relativeTo: nil)
        alien.registerComponent()
        box.components.set(alien())
        
        rootNode.addChild(box)
    }
    
    var body: some View {
        VStack{
            RealityView { content in
                lazar.registerComponent()
//                rootNode = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
                rootNode = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds:     [0.1, 0.1]))
                cameraNode = AnchorEntity(.camera)
                
//                let deathbox = ModelEntity()
//                let deathmesh = MeshResource.generateBox(size: 0.3, cornerRadius: 0.005)
//                let deathmaterial = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//                deathbox.components.set(ModelComponent(mesh: deathmesh, materials: [deathmaterial]))
////                deathbox.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .static)
//                deathbox.collision = CollisionComponent(shapes: [ShapeResource.generateBox(width: 0.1, height: 0.1, depth: 0.1)], mode: .trigger)
//                deathbox.generateCollisionShapes(recursive: true)
//                deathbox.physicsBody?.isAffectedByGravity = false
//                deathbox.position = [0, 0.5, -3]
                
    //            deathbox.applyLinearImpulse(SIMD3<Float>(0, 0, 0.1), relativeTo: nil)
                
//                rootNode.addChild(deathbox)
//
//                let box = ModelEntity()
//                let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//                let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//                box.components.set(ModelComponent(mesh: mesh, materials: [material]))
//                box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
//                box.generateCollisionShapes(recursive: true)
//                box.physicsBody?.isAffectedByGravity = false
//                box.position = [0, 0.5, 0]
//    //            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
//                box.applyLinearImpulse(SIMD3<Float>(0, 0, -0.2), relativeTo: nil)
//                
//                rootNode.addChild(box)
                
                
                
//                let floor = ModelEntity()
//    //            let floorMesh = MeshResource.generatePlane(width: 1, height: 1, cornerRadius: 0.005)
//                let floorMesh = MeshResource.generatePlane(width: 1, depth: 1)
//                let floorMaterial = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//                floor.components.set(ModelComponent(mesh: floorMesh, materials: [floorMaterial]))
//                floor.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(staticFriction: 0.1, dynamicFriction: 0.1, restitution: 0.1), mode: .static)
//                floor.generateCollisionShapes(recursive: true)
//    //            let floorAnchor = AnchorEntity(.plane(alignment: .horizontal))
//                rootNode.addChild(floor)
                
                collisionSubscriptions.append(content.subscribe(to: CollisionEvents.Began.self, { event in
//                    box.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
                    if(event.entityA.components.has(alien.self) && event.entityB.components.has(lazar.self)){
                        rootNode.removeChild(event.entityA)
                        rootNode.removeChild(event.entityB)
                    }
                }))
                // Add the horizontal plane anchor to the scene
                content.add(rootNode)
                
                content.add(cameraNode)
                
    //            model.transform.translation = [0,0,-0.5]
                
                collisionSubscriptions.append(content.subscribe(to: CollisionEvents.Ended.self, { event in
//                    box.model?.materials = [SimpleMaterial(color: .red, isMetallic: true)]
//                    if(deathbox != event.entityA){
//                        rootNode.removeChild(event.entityA)
//                    }
//                    if(deathbox != event.entityB){
//                        rootNode.removeChild(event.entityB)
//                    }
                    
//                    if(event.entityA.components.has(PhysicsBodyComponent.self)){
//                        
//                    }
                }))
                
                content.camera = .spatialTracking
                
            }
            Button {
                let box = ModelEntity()
                let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
                let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
                box.components.set(ModelComponent(mesh: mesh, materials: [material]))
                box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
                box.generateCollisionShapes(recursive: true)
                box.physicsBody?.isAffectedByGravity = false
//                box.position = [0, 0, -0.2]
    //            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
                
                
                
                box.position = cameraNode.position(relativeTo: rootNode) + [0, 0, -0.2]
                box.orientation = cameraNode.orientation(relativeTo: rootNode)
                // TODO do matrix math to fix impulse
                box.applyLinearImpulse(SIMD3<Float>(0, 0, -1), relativeTo: nil)
                box.components.set(lazar())
                rootNode.addChild(box)
                print("SHOT")
            } label: {
                Text("Shoot")
            }
            .onReceive(timer) { input in
//                [0, 0.5, -1]
                for i in 1...3{
                    for j in 1...3{
                        spawn(position: [(Float(j)*0.2)-0.5, ((Float(i)*0.2)), -2])
                    }
                }
                
            }
        }
        
//        .edgesIgnoringSafeArea(.all)
        
        
    }

}

#Preview {
    ContentView()
}
