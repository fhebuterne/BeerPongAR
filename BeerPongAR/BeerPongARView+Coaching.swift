//
//  BeerPongARView.swift
//  BeerPongAR
//
//  Created by Fabien Hebuterne on 06/02/2020.
//  Copyright © 2020 Fabien Hebuterne. All rights reserved.
//

import ARKit
import UIKit

extension BeerPongARView: ARCoachingOverlayViewDelegate {
  func addCoaching() {
    self.coachingOverlay.delegate = self
    self.coachingOverlay.session = self.session
    self.coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    /// - Tag: CoachingGoal
    self.coachingOverlay.goal = .horizontalPlane
    self.addSubview(self.coachingOverlay)
  }

  public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
    coachingOverlayView.activatesAutomatically = false
    self.addScene()
  }
}
