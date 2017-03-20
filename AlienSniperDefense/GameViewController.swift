//
//  GameViewController.swift
//  AlienSniperDefense
//
//  Created by Aleksander Makedonski on 3/16/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SoundLoader.preloadSounds()

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        
        
            let pathAnimationConfiguration = PathAnimationConfiguration(d1: 50, d2: 50, d3: 50, d4: 50, d5: 50)
        
    
        let ufoScene = UFOLevelLoader.getLevel1(difficultyLevel: .Easy)
        let ufoScene2 = UFOScene(size: self.view.bounds.size, levelNumber: 1, levelDescription: "Get those UFOs", enemyName: "UFO", crossHairType: .BlueLarge, backgroundMusic: BackgroundMusic.CheerfulAnnoyance, numberOfBackgroundObjects: 4, spawnInterval: 10.0, initialNumberOfEnemiesSpawned: 2, minUFOSpawnedPerInterval: 0, maxUFOSpawnedPerInterval: 5, minimumKillsForLevelCompletion: 10, maximumAllowableSpawnedUFO: 30, pathAnimationConfiguration: pathAnimationConfiguration)
        
        let batScene = BatScene(size: self.view.bounds.size, levelNumber: 1, levelDescription: "Kill the bats", enemyName: "Bat", playerType: .BlueLarge, backgroundMusic: BackgroundMusic.CheerfulAnnoyance, numberOfBackgroundObjects: 3, spawnInterval: 10.0, initialNumberOfEnemiesSpawned: 1, minBatsSpawned: 0, maxBatsSpawned: 5, minBatComponentVelocity: 60.00, maxBatComponentVelocity: 80.00, lightNodeFallOff: 2.00, maximumBatsAllowedToSpawn: 40, minimumBatsKilledForLevelCompletion: 5)
        
        let randomVectorConfiguration = RandomVectorConfiguration(minimumVectorYComponent: -80.0, maximumVectorYComponent: 80.0, minimumVectorXComponent: -80.0, maximumVectorXComponent: 80.0)
        
        let wingmanScene = WingmanScene(size: self.view.bounds.size, levelNumber: 1, levelDescription: "Kill all the wingman", enemyName: "Wingman", playerType: .BlueLarge, backgroundMusic: BackgroundMusic.CheerfulAnnoyance, numberOfBackgroundObjects: 3, hideInterval: 5.00, spawnInterval: 10.00, initialNumberOfEnemiesSpawned: 5, enemiesSpawnedPerInterval: 5, randomVectorConfigurationForUpdate: randomVectorConfiguration, maximumEnemiesAllowed: 30, minimumKillsForLevelCompletion: 5)
        
        let stealthShipScene = StealthShipSceneLevelLoader.loadLevel1(difficultyLevel: .Easy)
        let flyingAlienScene = FlyingAlienScene(size: self.view.bounds.size, levelNumber: 1, levelDescription: "Shoot all the flying Alines", enemyName: "Flying Alines", crosshairType: .BlueLarge, backgroundMusic: BackgroundMusic.CheerfulAnnoyance, fieldActionInterval: 5.00, numberOfBackgroundObjects: 2, spawnInterval: 5.00, enemiesSpawnedPerInterval: 2, initialNumberOfEnemiesSpawned: 2, maximumNumberOfEnemiesAllowed: 20, minimumKillsForLevelCompletion: 10, randomVectorConfiguration: randomVectorConfiguration)
        
        let menuScene = MenuScene(size: self.view.bounds.size)
        let trackScene = TrackScene(size: self.view.bounds.size)
        let instructionScene = InstructionScene(size: self.view.bounds.size, selectedTrackType: .Wingman)
        
        
        let stealthShipScene1 = StealthShipScene(size: self.view.bounds.size, levelNumber: 1, levelDescription: "Shoot all the stealth ships", enemyName: "Stealth Ships", playerType: .BlueLarge, backgroundMusic: BackgroundMusic.CheerfulAnnoyance, numberOfBackgroundObjects: 3, spawnInterval: 5.0, initialNumberOfEnemiesSpawned: 2, enemiesSpawnedPerInterval: 5, spaceShipTravelSpeed: 5.00, spaceShipTransitionInterval: 5.00, maximumNumberOfEnemiesAllowed: 20, minimumKillsForLevelCompletion: 10)
        
            // Set the scale mode to scale to fit the window
            ufoScene.scaleMode = .aspectFill
            batScene.scaleMode = .aspectFill
            wingmanScene.scaleMode = .aspectFill
            stealthShipScene.scaleMode = .aspectFill
            flyingAlienScene.scaleMode = .aspectFill
            trackScene.scaleMode = .aspectFill
            menuScene.scaleMode = .aspectFill
            instructionScene.scaleMode = .aspectFill
            stealthShipScene1.scaleMode = .aspectFill
        
            let summaryScene = SummaryScene(size: self.view.bounds.size, selectedTrackType: .Bat)
        
        
            let medalScene = MedalScene(size: self.view
                .bounds.size, medalType: .Gold)
        
            // Present the scene
            if let view = self.view as! SKView? {
                view.presentScene(menuScene)
                    
                view.ignoresSiblingOrder = true
                    
                view.showsFPS = true
                view.showsNodeCount = true
                }
        
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
