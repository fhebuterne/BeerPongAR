//
//  BeerPongARView+Translation.swift
//  BeerPongAR
//
//  Created by Fabien Hebuterne on 07/02/2020.
//  Copyright © 2020 Fabien Hebuterne. All rights reserved.
//

import RealityKit
import ARKit
import Combine

extension BeerPongARView {
    
    @objc
    func handleTranslation(_ recognizer: EntityTranslationGestureRecognizer) {
        if recognizer.state == .ended || recognizer.state == .cancelled {
            // Disable the gesture recognizer and return to dynamic physics so that any in-motion physics movements continue to play.
            recognizer.isEnabled = false
            gestureStartLocation = nil
            ball.physicsBody?.mode = .dynamic
            return
        }
        
        // Store the touch location and don't process velocity if this is the first touch.
        guard let gestureCurrentLocation = recognizer.translation(in: nil) else { return }
        guard let gestureStartLocation = self.gestureStartLocation else {
            self.gestureStartLocation = gestureCurrentLocation
            return
        }
        
        // Calculate the gesture's current distance from its physical start location in the real world.
        let delta = gestureStartLocation - gestureCurrentLocation
        let distance = ((delta.x * delta.x) + (delta.y * delta.y) + (delta.z * delta.z)).squareRoot()
        
        // If the current gesture location has moved more than 0.5m from where the gesture started, ignore any
        // further translation from this gesture, and return to dynamic physics to play out the remaining motion.
        if distance > 0.5 {
            self.gestureStartLocation = nil
            ball.physicsBody?.mode = .dynamic
            return
        }
        
        // Set the current physics body movement mode to kinetic since the gesture is still active, and
        // update the ball's velocity to match the velocity of the gesture in the real world.
        ball.physicsBody?.mode = .kinematic
        let realVelocity = recognizer.velocity(in: nil)
        let ballParentVelocity = ball.parent!.convert(direction: realVelocity, from: nil)
        var clampedX = ballParentVelocity.x
        var clampedZ = ballParentVelocity.z
        
        let ballVelocityMaxX : Float = 0.7
        let ballVelocityMinX : Float = -0.7
        
        // Clamp the x velocity to not move the ball too far to the left or right.
        if clampedX > ballVelocityMaxX {
            clampedX = ballVelocityMaxX
        } else if clampedX < ballVelocityMinX {
            clampedX = ballVelocityMinX
        }
        
        let ballVelocityMaxZ : Float = 0.1
        let ballVelocityMinZ : Float = -3.0
        
        // Clamp the z velocity towards the pins in the negative z direction only.
        if clampedZ > ballVelocityMaxZ {
            clampedZ = ballVelocityMaxZ
        } else if clampedZ < ballVelocityMinZ {
            clampedZ = ballVelocityMinZ
        }
        
        
        let clampedVelocity: SIMD3<Float> = [clampedX, 1.5, clampedZ]
        
        ball.physicsMotion?.linearVelocity = clampedVelocity
    }
}
