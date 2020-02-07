//
//  ViewController.swift
//  BeerPongAR
//
//  Created by Fabien Hebuterne on 04/02/2020.
//  Copyright © 2020 Fabien Hebuterne. All rights reserved.
//

import UIKit
import RealityKit
import ARKit
import SwiftUI

struct ContentView: View {
  var body: some View {
    return ARViewContainer().edgesIgnoringSafeArea(.all)
  }
}

struct ARViewContainer: UIViewRepresentable {
  func makeUIView(context: Context) -> BeerPongARView {

    let arView = BeerPongARView(frame: .zero)
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = .horizontal
    arView.session.run(config, options: [])

    arView.addCoaching()
    
    return arView
  }
  func updateUIView(_ uiView: BeerPongARView, context: Context) {}

}
