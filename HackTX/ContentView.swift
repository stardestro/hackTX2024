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
import AVKit

struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to Try Again") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}


class SoundManager{
    static let instance = SoundManager()
    
    var player:AVAudioPlayer?
    
    func playCannon(){
        guard let url = Bundle.main.url(forResource: "cannonfire", withExtension: ".mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
        
    }
    func playExplode(){
        guard let url = Bundle.main.url(forResource: "explosion", withExtension: ".mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
        
    }
}

class MusicManager{
    static let instance = MusicManager()
    
    var player:AVAudioPlayer?
    
    func playFunk(){
        guard let url = Bundle.main.url(forResource: "funk", withExtension: ".mp3") else {return}
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        }catch let error{
            print("Error: \(error.localizedDescription)")
        }
        
    }
}


struct ContentView : View {
    
    @State var collisionSubscriptions = [RealityFoundation.EventSubscription]()
    
    @State var rootNode: AnchorEntity = AnchorEntity()
    @State var cameraNode: AnchorEntity = AnchorEntity()
    @State var bullet: ModelEntity = ModelEntity()
    @State var playerswall: ModelEntity = ModelEntity()
    
    @State private var showingSheet = false
    @State private var assignedanchor = true
    
    @State var HighScore: Int = 0
    
    @State var cup = Entity()
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    func spawn(position: SIMD3<Float>) async {
        
        let box = ModelEntity()
//        if let cup = try? ModelEntity.loadModel(named: "SUPASMOL") {
//            let box = ModelEntity()
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = OcclusionMaterial()
        let material = SimpleMaterial(color: .red.withAlphaComponent(0.0), roughness: 0.15, isMetallic: true)
        box.components.set(ModelComponent(mesh: mesh, materials: [material]))
        box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
        box.generateCollisionShapes(recursive: true)
        box.physicsBody?.isAffectedByGravity = false
        box.position = position
//            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
        box.applyLinearImpulse(SIMD3<Float>(0, 0, 0.2), relativeTo: nil)
        alien.registerComponent()
        box.components.set(alien())
        let temp = cup.clone(recursive: true)
        box.addChild(temp)
        rootNode.addChild(box)
//        }
//        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
//        let material = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
//        box.components.set(ModelComponent(mesh: mesh, materials: [material]))
//        box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
//        box.generateCollisionShapes(recursive: true)
//        box.physicsBody?.isAffectedByGravity = false
//        box.position = position
////            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
//        box.applyLinearImpulse(SIMD3<Float>(0, 0, 0.2), relativeTo: nil)
//        alien.registerComponent()
//        box.components.set(alien())
        
//        rootNode.addChild(box)
    }
    
    var body: some View {
        ZStack{
            RealityView { content in
                cup = try! await Entity(named: "ruh")
                let radians = 90 * Float.pi / 180
                
                cup.orientation += simd_quatf(angle: radians, axis: SIMD3<Float>(1,0,0))
                cup.scale = SIMD3<Float>(0.4,0.4,0.4)
                cup.position = cup.position + [-0.05, -0.04, 0]
                MusicManager.instance.playFunk()
                lazar.registerComponent()
                rootNode = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
                
//                rootNode = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds:     [0.1, 0.1]))
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
                let box = ModelEntity()
                let mesh = MeshResource.generateBox(size: 0.005, cornerRadius: 0.000005)
                let material = SimpleMaterial(color: .red.withAlphaComponent(0.7), roughness: 0.15, isMetallic: true)
                box.components.set(ModelComponent(mesh: mesh, materials: [material]))
//                box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
//                box.generateCollisionShapes(recursive: true)
//                box.physicsBody?.isAffectedByGravity = false
                box.position = [0, 0, -0.1]
    //            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
//                box.applyLinearImpulse(SIMD3<Float>(0, 0, -0.2), relativeTo: nil)

                cameraNode.addChild(box)
                
                var ship = Entity()
                ship = try! await Entity(named: "ship")
                
    //            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
//                box.applyLinearImpulse(SIMD3<Float>(0, 0, -0.2), relativeTo: nil)
                
                ship.transform.rotation += simd_quatf(angle: radians, axis: SIMD3<Float>(0,1.2,0))
                
                ship.position = [-0.02, -0.03, -0.2]
//                ship.orientation += simd_quatf(angle: radians, axis: SIMD3<Float>(1,1,0))
                cameraNode.addChild(ship)
                
                
                
                playerswall = ModelEntity()
                let floorMesh = MeshResource.generatePlane(width: 10, height: 10, cornerRadius: 0.005)
//                let floorMesh = MeshResource.generatePlane(width: 1, depth: 1)
//                let floorMaterial = SimpleMaterial(color: .gray, roughness: 0.15, isMetallic: true)
                let floorMaterialhidden = SimpleMaterial(color: .red.withAlphaComponent(0.0), roughness: 0.15, isMetallic: true)
                playerswall.components.set(ModelComponent(mesh: floorMesh, materials: [floorMaterialhidden]))
                playerswall.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(staticFriction: 0.1, dynamicFriction: 0.1, restitution: 0.1), mode: .static)
                playerswall.generateCollisionShapes(recursive: true)
//                floor.position = [0, -0.5, 0.5]
                playerswall.position = cameraNode.position(relativeTo: rootNode) + [0, 0, cameraNode.position(relativeTo: rootNode).z + 0.2]
                playerswall.components.set(playerwall())
    //            let floorAnchor = AnchorEntity(.plane(alignment: .horizontal))
                
                rootNode.addChild(playerswall)
                
                collisionSubscriptions.append(content.subscribe(to: CollisionEvents.Began.self, { event in
                    //                    box.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
                    if(event.entityA.components.has(alien.self) && event.entityB.components.has(lazar.self)){
                        rootNode.removeChild(event.entityA)
                        rootNode.removeChild(event.entityB)
                        SoundManager.instance.playExplode()
                        HighScore += 1
                        
                    }
                    if(event.entityA.components.has(asteriod.self) && event.entityB.components.has(lazar.self)){
                        rootNode.removeChild(event.entityB)
                        SoundManager.instance.playExplode()
                    }
                    if(event.entityA.components.has(playerwall.self) && event.entityB.components.has(alien.self)){
                        showingSheet = true
                        rootNode.children.removeAll { entity in
                            entity.components.has(alien.self)
                        }
                        SoundManager.instance.playExplode()
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
                content.renderingEffects.motionBlur = .disabled
                content.renderingEffects.cameraGrain = .disabled
                
            }
            VStack
            {
                HStack{
                    if(!assignedanchor){
                        Text("Look for the Aliens")
                            .foregroundStyle(.white, .black)
                            .frame(width: 150, height: 50)
                            .background(Color.blue.opacity(0.8))
                            .cornerRadius(15)
                            .safeAreaPadding()
                            .offset(y: +50)
                    }
                    Spacer()
                    Text(HighScore, format: .number)
                        .foregroundStyle(.white, .black)
                        .frame(width: 50, height: 50)
                        .background(Color.blue.opacity(0.8))
                        .cornerRadius(15)
                        .safeAreaPadding()
                        .offset(y: +50)
                }
                
                Spacer()
                Button {
                    
                    SoundManager.instance.playCannon()
                    
                    let box = ModelEntity()
                    let mesh = MeshResource.generateBox(size: 0.025, cornerRadius: 0.005)
                    let material = SimpleMaterial(color: .red, roughness: 0.15, isMetallic: true)
                    box.components.set(ModelComponent(mesh: mesh, materials: [material]))
                    box.physicsBody = PhysicsBodyComponent(massProperties: .default, material: .generate(), mode: .dynamic)
                    box.generateCollisionShapes(recursive: true)
                    box.physicsBody?.isAffectedByGravity = false
                    //                box.position = [0, 0, -0.2]
                    //            let anchor = AnchorEntity(.image(group: "AR Resources" , name: "tag"))
                    
                    
                    
                    box.position = cameraNode.position(relativeTo: rootNode)
                    box.orientation = cameraNode.orientation(relativeTo: rootNode)
                    // TODO do matrix math to fix impulse
                    box.applyLinearImpulse(SIMD3<Float>(0, 0, -1), relativeTo: box)
//                    box.applyLinearImpulse(SIMD3<Float>(0, 0, -1), relativeTo: nil)
                    box.components.set(lazar())
                    rootNode.addChild(box)
                    print("SHOT")
                } label: {
                    Text("Shoot")
                        .foregroundStyle(.white, .black)
                        .frame(width: 200, height: 175)
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(15)
                }
            }
            .sheet(isPresented: $showingSheet) {
                Text("HIGHSCORE: \(HighScore)")
                    .font(.title)
                    .padding()
//                    .background(.black)
                Button("Press to Try Again") {
                    showingSheet = false
                    rootNode.children.removeAll { entity in
                        entity.components.has(alien.self)
                    }
                    HighScore = 0
                }
                .font(.title)
                .padding()
                .background(.black)
            }
            .onReceive(timer) { input in
//                [0, 0.5, -1]
                Task{
                    for i in 1...3{
                        for j in 1...3{
                            if(Bool.random()){
                                await spawn(position: [(Float(j)*0.2 + Float.random(in: 0.0..<0.1))-0.5, ((Float(i)*0.2) + Float.random(in: 0.0..<0.1)), -2])
                            }
                        }
                    }
                }
                
                // update wall to behind player
                playerswall.position = cameraNode.position(relativeTo: rootNode) + [0, 0, cameraNode.position(relativeTo: rootNode).z + 0.1]
                
                if (rootNode.isActive && assignedanchor) {
                    rootNode.anchor?.reanchor(.world(transform: rootNode.transform.matrix), preservingWorldTransform: true)
                    assignedanchor = false
                }
                
            }
        }
        
        .edgesIgnoringSafeArea(.all)
        
        
    }

}

#Preview {
    ContentView()
}
