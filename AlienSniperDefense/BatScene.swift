//
//  BatScene.swift
//  AlienSniperDefenese
//
//  Created by Aleksander Makedonski on 3/15/17.
//  Copyright © 2017 AlexMakedonski. All rights reserved.
//



import Foundation
import SpriteKit
import GameplayKit
import GameKit

/**
 Randomization of velocity for bat movement is configured through scene-level parameters (minBatComponentVelocity and maxBatComponentVelocity), which are used to initialize a RandomVector in the didUpdatePhysics function; the minimum and maximum number of bats spawned is a controller-level parameter configured via the scene's initializer, which in turn calls the initializer for the controller
 
 **/

class BatScene: BaseScene
{
    
   
    //MARK: ****************** Node-Level Randomization Flag
    var nodeLevelRandomizationIsActive: Bool = false

    //MARK: ******************** Bat-Related Variables
    var batController: BatController!
    
    var minBatComponentVelocity: Double = 0
    var maxBatComponentVelocity: Double = 0
    var adjustedCurrentTime: TimeInterval = 0.00
    
    override var currentNumberOfEnemies: Int{
        didSet{
            if(currentNumberOfEnemies <  0){
                currentNumberOfEnemies = 0
            }
            
        }
    }
    
    override var numberOfEnemiesKilled: Int{
        didSet{
            currentNumberOfEnemies -= (numberOfEnemiesKilled - oldValue)
            
        }
    }
    
    //MARK: ****************** CrossHair LightNode Configuration
    var lightNodeFallOff: CGFloat = 2.0
    

    //MARK: ***************SCENE INITIALIZERS
    convenience init(size: CGSize, levelNumber: Int, levelDescription: String, enemyName: String, playerType: CrossHair.CrossHairType, backgroundMusic: String, numberOfBackgroundObjects: Int, spawnInterval: TimeInterval, initialNumberOfEnemiesSpawned: Int, minBatsSpawned: Int, maxBatsSpawned: Int, minBatComponentVelocity: Double, maxBatComponentVelocity: Double,lightNodeFallOff: CGFloat, maximumBatsAllowedToSpawn: Int, minimumBatsKilledForLevelCompletion: Int, nodeLevelRandomizationIsActive: Bool = false, timeLimit: TimeInterval = 60.00) {
        
      
        //Delegate to designated initializer
        self.init(size: size)
        
        //Set nodeLevelRandomization
        self.nodeLevelRandomizationIsActive = nodeLevelRandomizationIsActive
        
        //Configure Opening/Intro Start Window
        self.levelNumber = levelNumber
        self.levelDescription = levelDescription
        self.enemyName = enemyName
        
        //Configure Player Type and Background Music
        self.playerType = playerType
        self.backGroundMusic = backgroundMusic
        
        //Configure Time Limit for Time Limit Mode
        self.timeLimit = timeLimit
        
        
        //Configure basic AI logic
        self.spawnInterval = spawnInterval
        self.enemiesSpawnedPerInterval = enemiesSpawnedPerInterval
        self.initialNumberOfEnemiesSpawned = initialNumberOfEnemiesSpawned
        self.currentNumberOfEnemies = initialNumberOfEnemiesSpawned
        self.maxBatComponentVelocity = maxBatComponentVelocity
        self.minBatComponentVelocity = minBatComponentVelocity
        self.lightNodeFallOff = lightNodeFallOff
        
        
        //Configure Bat Controller
        self.batController = BatController(hud2: self.hud2, batSpawningInterval: spawnInterval, minBatsSpawned: minBatsSpawned, maxBatsSpawned: maxBatsSpawned)
        
        //Configure Game Rules
        self.maximumNumberOFEnemies = maximumBatsAllowedToSpawn
        self.minimumKillsForLevelCompletion = minimumBatsKilledForLevelCompletion
        
        //Configure background objects
        self.numberOfBackgroundObjects = numberOfBackgroundObjects
        

    }
    


    
    override func didMove(to view: SKView) {
        //Set current track
        currenTrack = .Bat
        
        //Set Current GamePlayMode
        setCurrentGamePlayMode()
        
        //Perform basic scene configuration
        performBasicSceneConfiguration()
        
        
        //Configure background color
        self.backgroundColor = SKColor.black
        
        
    }
    
    
    //MARK: ************** Override performBasicConfiguration() helper method
    
    override func performBasicSceneConfiguration() {
        //Register NSNotifications for Pause and Resume Method
        registerNotifications()
        
        //Configure pause button
        configurePauseButton()
        
        //Set current game state to running
        currentGameState = .Running
        
        //Set anchor point of current scene to center
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = SKColor.black
        self.frameCount = 0.00
        
        //Configure SceneInterfaceManagerDelegate
        sceneInterfaceManagerDelegate = SceneInterfaceManager(newManagedScene: self)
        
        let tempTexta = NSLocalizedString("Level ", comment: "")
        
        var tempTextb: String
        
        if(tempTexta == "等级 "){
            switch(levelNumber){
            case 1:
                tempTextb = tempTexta.appending("-")
                break
            case 2:
                tempTextb = tempTexta.appending("二")
                break
            case 3:
                tempTextb = tempTexta.appending("三")
                break
            case 4:
                tempTextb = tempTexta.appending("四")
                break
            case 5:
                tempTextb = tempTexta.appending("五")
                break
            default:
                tempTextb = tempTexta.appending("零")
                break
            }
        } else {
            tempTextb = tempTexta.appending("\(levelNumber)")
            
        }
        

        if(currentGameSettings.getGamePlayMode() == .valueTimeLimit){
            sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: tempTextb, levelDescription: self.levelDescription, enemyName: "Bat", levelTimeLimit: self.timeLimit, minimumKillsForLevelCompletion: self.minimumKillsForLevelCompletion)
            
                configureTimerButton()
        }else{
            sceneInterfaceManagerDelegate.setupIntroMessageBox(levelTitle: tempTextb, levelDescription: self.levelDescription, enemyName: "Bat", spawningLimit: self.maximumNumberOFEnemies, minimumKillsForLevelCompletion: self.minimumKillsForLevelCompletion)
        }
        

        
        //Configure particle emitter for background
        let emitterPath = Bundle.main.path(forResource: "StarryNight", ofType: "sks")!
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath) as! SKEmitterNode
        emitterNode.particleColor = SKColor.orange
        emitterNode.targetNode = self
        emitterNode.move(toParent: self)
        
        
        //Configure player
        player = CrossHair(crossHairType: .BlueLarge)
        player.zPosition = 15
        let lightNode = player.childNode(withName: NodeNames.CrossHairLight) as! SKLightNode
        lightNode.falloff = self.lightNodeFallOff
        self.addChild(player)

        //Configure explosion animation
        configureExplosionAnimation()
        
        //Configure Background music
        BackgroundMusic.configureBackgroundMusicFrom(fileNamed: BackgroundMusic.MissionPlausible, forParentNode: self)
        
        //Spawn Background Objects
        spawnBackgroundObjects(numberOfBackgroundObjects: self.numberOfBackgroundObjects, scaledByFactorOf: 0.40)
        
        //Configure initial HUD display
        currentNumberOfEnemies = 0
        numberOfEnemiesKilled = 0
        hud2.setNumberOfEnemiesKilledTo(numberKilled: numberOfEnemiesKilled)
        hud2.setNumberOfEnemiesTo(numberOfEnemies: currentNumberOfEnemies)
        self.addChild(hud2)

        //Configure Pause State Buttons
        setupPauseStateButtons()
        
        //Configure Record Buttons
        setupRecordButtons()
    }

    
    
    //MARK: *************** GAME LOOP FUNCTIONS
    
    override func didSimulatePhysics() {
        
        var randomVector = RandomVector(yComponentMin: self.minBatComponentVelocity, yComponentMax: self.maxBatComponentVelocity, xComponentMin: self.minBatComponentVelocity, xComponentMax: self.maxBatComponentVelocity)
        
        randomVector.randomizeXComponentSign()
        randomVector.randomizeYComponentSign()
        
        
        for node in self.children{
            if let bat = node as? Bat{
                checkForRepositioning()
                bat.physicsBody?.velocity = randomVector.getVector()
            }
        }
 
        
    }
    
    override func didEvaluateActions() {
        if(self.nodeLevelRandomizationIsActive){
            for node in self.children{
                if let node = node as? Bat{
                    checkForRepositioning()
                    node.updatePhysicsWithUniformRandom()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if(!gameHasStarted) { frameCount = 0 }
        
        frameCount += currentTime - lastUpdateTime
        
        if(!gameHasStarted){
            adjustedCurrentTime = 0
        } else {
            adjustedCurrentTime = currentTime
        }
        //Update bat controller to spawn bats at regular intervals
        batController.update(forParentNode: self, currentTime: adjustedCurrentTime)
        
        
        //Update the player's position
        player.update()
        
        lastUpdateTime = currentTime

        
    }
    
    

    
    
    //MARK: ******************* USER INPUT HANDLERS
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesMoved(touches, with: event)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        let touch = touches.first! as UITouch
        let touchLocation = touch.location(in: self)
        
        
        
        for node in nodes(at: touchLocation){
            
            if player.contains(touchLocation){
                
                player.run(shootingSound)
                
                if let node = node as? Bat{
                    
                    

                    let removalStatus = node.userData?.value(forKey: "isBeingRemoved")
                    

                    if(removalStatus != nil), let removalStatus = removalStatus as? Bool, removalStatus == true{
                        return
                    } else {
                    
                    node.userData = NSMutableDictionary()
                    node.userData?.setValue(true, forKey: "isBeingRemoved")
                        
                    node.run(SKAction.sequence([
                     
                        SKAction.run {
                            node.respondToHit()
                            self.numberOfEnemiesKilled += 1
                            
                            //Bat Controller keeps track of the total number of bats on screen
                            self.hud2.setNumberOfEnemiesTo(numberOfEnemies: self.currentNumberOfEnemies)
                            self.hud2.setNumberOfEnemiesKilledTo(numberKilled: self.numberOfEnemiesKilled)
                            
                        }
                        
                       
                    ]))
                    
                    
                    }
            
                }
            }
            
            
          
        }
        
    }
    
    
    private func reduceCurrentNumberOfEnemiesBy(numberKilled: Int){
        if(currentNumberOfEnemies < 0){
            currentNumberOfEnemies = 0
        } else {
            currentNumberOfEnemies -= numberKilled
        }
    }
  
}


extension BatScene{
    
    
    func checkForRepositioning(){
        for node in self.children{
            if let bat = node as? Bat{
                if(bat.position.x < -ScreenSizeFloatConstants.HalfScreenWidth*0.8 || bat.position.x > ScreenSizeFloatConstants.HalfScreenHeight*0.8){
                    bat.setPosition()
                }
                
                if(bat.position.y < -ScreenSizeFloatConstants.HalfScreenHeight*0.8 || bat.position.y > ScreenSizeFloatConstants.HalfScreenHeight*0.8){
                    bat.setPosition()
                }
            }
        }
    }
    

    
    
}

extension BatScene{
    
    override func loadNextLevel() {
        
        let mainTransition = SKTransition.crossFade(withDuration: 2.00)
        var nextLevelDifficulty: BatSceneLevelLoader.DifficultyLevel
        var batScene: BatScene?
        
        switch(currentGameSettings.getGameDifficulty()){
            case .valueHard:
                nextLevelDifficulty = .Hard
                break
            case .valueMedium:
                nextLevelDifficulty = .Medium
                break
            case .valueEasy:
                nextLevelDifficulty = .Easy
                break
        }
        
        switch(levelNumber){
            case 1:
                //Report to GameCenter progress towards track completion
                /** FUTURE VERSIONS
                let achievement = (GameSettings.sharedInstance.getGamePlayMode() == .valueMinimumKills) ? GKAchievement(identifier: "CompletedBatTrack_MinimumKillsMode") : GKAchievement(identifier: "CompletedBatTrack_TimeLimitMode")
                achievement.percentComplete = 0.20
                GameViewController.reportProgressTowardsAnAchievement(achievement: achievement)
                **/
                
                batScene = BatSceneLevelLoader.getLevel2Scene(size: self.size, difficultyLevel: nextLevelDifficulty)
                break
        case 2:
            //Report to GameCenter progress towards track completion
            /** FUTURE VERSIONS
            let achievement = (GameSettings.sharedInstance.getGamePlayMode() == .valueMinimumKills) ? GKAchievement(identifier: "CompletedBatTrack_MinimumKillsMode") : GKAchievement(identifier: "CompletedBatTrack_TimeLimitMode")
            
            achievement.percentComplete = 0.40
            
            GameViewController.reportProgressTowardsAnAchievement(achievement: achievement)
            **/
            
            batScene = BatSceneLevelLoader.getLevel3Scene(size: self.size, difficultyLevel: nextLevelDifficulty)
            break
        case 3:
            //Report to GameCenter progress towards track completion
            /** FUTURE VERSIONS 
            let achievement = (GameSettings.sharedInstance.getGamePlayMode() == .valueMinimumKills) ? GKAchievement(identifier: "CompletedBatTrack_MinimumKillsMode") : GKAchievement(identifier: "CompletedBatTrack_TimeLimitMode")
            
            achievement.percentComplete = 0.60
            
            GameViewController.reportProgressTowardsAnAchievement(achievement: achievement)
            **/
            
            batScene = BatSceneLevelLoader.getLevel4Scene(size: self.size, difficultyLevel: nextLevelDifficulty)
            break
        case 4:
            //Report to GameCenter progress towards track completion
            /** FUTURE VERSIONS
            let achievement = (GameSettings.sharedInstance.getGamePlayMode() == .valueMinimumKills) ? GKAchievement(identifier: "CompletedBatTrack_MinimumKillsMode") : GKAchievement(identifier: "CompletedBatTrack_TimeLimitMode")
            
            achievement.percentComplete = 0.80
            
            GameViewController.reportProgressTowardsAnAchievement(achievement: achievement)
            **/
            batScene = BatSceneLevelLoader.getLevel5Scene(size: self.size, difficultyLevel: nextLevelDifficulty)
            break
        case 5:
            //Report to GameCenter progress towards track completion
            /** FUTURE VERSIONS
            let achievement = (GameSettings.sharedInstance.getGamePlayMode() == .valueMinimumKills) ? GKAchievement(identifier: "CompletedBatTrack_MinimumKillsMode") : GKAchievement(identifier: "CompletedBatTrack_TimeLimitMode")
            
            achievement.percentComplete = 1.00
            
            GameViewController.reportProgressTowardsAnAchievement(achievement: achievement)
            **/
            
            //Load player stats summary scene
            let summaryScene = SummaryScene(size: self.size, selectedTrackType: SummaryScene.TrackType.Bat)
            self.view?.presentScene(summaryScene, transition: mainTransition)
            break
        default:
            break
        }
        
        if let batScene = batScene{
            self.view?.presentScene(batScene, transition: mainTransition)
        }
    }
    
    override func reloadCurrentLevel() {
        
        let transition = SKTransition.crossFade(withDuration: 2.00)
        var batScene: BatScene?
        
        var currentLevelDifficulty: BatSceneLevelLoader.DifficultyLevel
        
        switch(currentGameSettings.getGameDifficulty()){
        case .valueHard:
            currentLevelDifficulty = .Hard
            break
        case .valueMedium:
            currentLevelDifficulty = .Medium
            break
        case .valueEasy:
            currentLevelDifficulty = .Easy
            break
        }
        
        
        switch(levelNumber){
        case 1:
            batScene = BatSceneLevelLoader.getLevel1Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        case 2:
             batScene = BatSceneLevelLoader.getLevel2Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        case 3:
             batScene = BatSceneLevelLoader.getLevel3Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        case 4:
             batScene = BatSceneLevelLoader.getLevel4Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        case 5:
             batScene = BatSceneLevelLoader.getLevel5Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        default:
            batScene = BatSceneLevelLoader.getLevel1Scene(size: self.size, difficultyLevel: currentLevelDifficulty)
            break
        }
        
        if let batScene = batScene{
            self.view?.presentScene(batScene, transition: transition)
        }
    }
    
}
