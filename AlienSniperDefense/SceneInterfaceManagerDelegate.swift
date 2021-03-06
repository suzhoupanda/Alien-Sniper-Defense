//
//  SceneInterfaceManagerDelegate.swift
//  AlienSniperDefense
//
//  Created by Aleksander Makedonski on 3/9/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import Foundation
import SpriteKit


protocol SceneInterfaceManagerDelegate: class{
    
    //The managed scene is not necessary but makes the protocol more readable
    weak var managedScene: SKEffectNode? { get set }
    
    
    func setupIntroMessageBox(levelTitle: String, levelDescription: String, enemyName: String, spawningLimit: Int, minimumKillsForLevelCompletion: Int)
    
   
    
    func setupIntroMessageBox(levelTitle: String, levelDescription: String, enemyName: String, levelTimeLimit: Double, minimumKillsForLevelCompletion: Int)
   
    

}

