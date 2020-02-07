//
//  EntityExtension.swift
//  BeerPongAR
//
//  Created by Fabien Hebuterne on 07/02/2020.
//  Copyright © 2020 Fabien Hebuterne. All rights reserved.
//

import RealityKit
import SwiftUI

//-------------------------
//MARK: - Entity Extensions
//-------------------------

extension Entity {
    
    /// Changes The Text Of An Entity
    /// - Parameters:
    ///   - content: String
    func setText(_ content: String){ self.components[ModelComponent] = self.generatedModelComponent(text: content, fontName: "Futura") }
    
    /// Generates A Model Component With The Specified Text
    /// - Parameter text: String
    func generatedModelComponent(text: String, fontName: String) -> ModelComponent{
        
        let customFont: UIFont = UIFont(name: fontName, size: UIFont.systemFontSize).unsafelyUnwrapped
        
        print(customFont)
        //print(MeshResource.Font.familyNames)
        
        let modelComponent: ModelComponent = ModelComponent(
            
            mesh: .generateText(text, extrusionDepth: TextElements().extrusionDepth, font: TextElements().font,
                                containerFrame: .zero, alignment: .center, lineBreakMode: .byTruncatingTail),
            
            materials: [SimpleMaterial(color: TextElements().colour, isMetallic: true)]
            
        )
        
        return modelComponent
    }
    
}

//--------------------
//MARK:- Text Elements
//--------------------

/// The Base Setup Of The MeshResource
struct TextElements{
    let initialText = ""
    let extrusionDepth: Float = 0.01
    let font: MeshResource.Font = MeshResource.Font.systemFont(ofSize: 0.05, weight: .bold)
    let colour: UIColor = .white
}
