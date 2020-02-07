//
//  BeerPongARView.swift
//  BeerPongAR
//
//  Created by Fabien Hebuterne on 06/02/2020.
//  Copyright © 2020 Fabien Hebuterne. All rights reserved.
//

import RealityKit
import ARKit
import Combine

class BeerPongARView: ARView {
    let coachingOverlay = ARCoachingOverlayView()
    var sceneLoaded: BaseBeerPong.Scène? = nil
    var collisionEventStreams = [AnyCancellable]()
    var score = 0
    
    /// An entity gesture recognizer that translates swipe movements to ball velocity.
    var gestureRecognizer: EntityTranslationGestureRecognizer?
    
    /// The world location at which the current translate gesture began.
    var gestureStartLocation: SIMD3<Float>?
    
    var ball: (Entity & HasPhysics) {
        self.sceneLoaded?.ballObject as! Entity & HasPhysics
    }
    
    deinit {
        collisionEventStreams.removeAll()
    }
    
    func addScene() {
        if let sceneBase = try? BaseBeerPong.loadScène() {
            self.sceneLoaded = sceneBase
            
            //self.sceneLoaded?.gob1?.generateCollisionShapes(recursive: true)
            
            self.sceneLoaded?.actions.touchCupWithBall.onAction = { _ in
                self.score = self.score+1
                self.sceneLoaded?.labelCupInValue?.setText(String(self.score))
            }
            
            if let ball = sceneBase.ballObject as? Entity & HasCollision {
                let gestureRecognizers = self.installGestures([.translation], for: ball)
                
                if let gestureRecognizer = gestureRecognizers.first as? EntityTranslationGestureRecognizer {
                    
                    // Disable default translation.
                    gestureRecognizer.removeTarget(nil, action: nil)
                    gestureRecognizer.addTarget(self, action: #selector(self.handleTranslation))
                    
                    self.scene.subscribe(to: CollisionEvents.Began.self) { event in
                        self.resetBallPosition(ball: self.ball, gestureRecognizers: gestureRecognizers)
                    }.store(in: &collisionEventStreams)
                    
                    self.scene.subscribe(to: CollisionEvents.Updated.self) { event in
                        self.resetBallPosition(ball: self.ball, gestureRecognizers: gestureRecognizers)
                    }.store(in: &collisionEventStreams)
                
                    self.scene.subscribe(to: CollisionEvents.Ended.self) { event in
                        self.resetBallPosition(ball: self.ball, gestureRecognizers: gestureRecognizers)
                    }.store(in: &collisionEventStreams)
                }
            }
            
            self.scene.anchors.append(sceneBase)
        }
    }
    
    func resetBallPosition(ball: Entity, gestureRecognizers: [EntityGestureRecognizer]) {
        let velocity = self.ball.physicsMotion?.linearVelocity ?? [0, 0, 0]
        if simd_norm_inf(velocity) < 0.1 {
            let ball = ball as! HasPhysicsBody
            ball.physicsBody?.mode = .static
            ball.setPosition(simd_float3.init(), relativeTo: nil)
            ball.physicsBody?.mode = .kinematic
            gestureRecognizers.first?.isEnabled = true
        }
    }
}
