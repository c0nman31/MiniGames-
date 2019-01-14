//
//  GameScene_sim.swift
//  MiniGames!
//
//  Created by Pete Connor on 6/24/18.
//  Copyright © 2018 c0nman. All rights reserved.
//

import SpriteKit

enum GameState_sim {
    case touchToBegin
    case memorizing
    case tapping
    case gameOver
}

class GameScene_sim: SKScene, SKPhysicsContactDelegate {
    
    weak var gameVC: GameViewController2?
    
    var isGamePaused = false
    var pauseButton = SKSpriteNode()
    var gameState: GameState_sim?
    
    var scoreLabel1 = SKSpriteNode(imageNamed: "num0")
    var scoreLabel2 = SKSpriteNode(imageNamed: "num0")
    var scoreLabel3 = SKSpriteNode(imageNamed: "num0")
    var blurr1 = SKSpriteNode(imageNamed: "BlueNum0")
    var blurr2 = SKSpriteNode(imageNamed: "BlueNum0")
    var blurr3 = SKSpriteNode(imageNamed: "BlueNum0")
    
    var ones = 0
    var tens = 0
    var hundreds = 0
    var score = 0 {
        didSet {
            ones += 1
            if score % 100 == 0 {
                ones = 0
                tens = 0
                hundreds += 1
                scoreLabel2.texture = SKTexture(imageNamed: "num\(tens)")
                blurr2.texture = SKTexture(imageNamed: "BlueNum\(tens)")
                scoreLabel1.texture = SKTexture(imageNamed: "num\(hundreds)")
                blurr1.texture = SKTexture(imageNamed: "BlueNum\(hundreds)")
            }
            
            if score % 10 == 0 && score % 100 != 0 {
                ones = 0
                tens += 1
                scoreLabel2.texture = SKTexture(imageNamed: "num\(tens)")
                blurr2.texture = SKTexture(imageNamed: "BlueNum\(tens)")
                
                
            }
            scoreLabel3.texture = SKTexture(imageNamed: "num\(ones)")
            blurr3.texture = SKTexture(imageNamed: "BlueNum\(ones)")
            
            if score >= 999 {
                scoreLabel1.texture = SKTexture(imageNamed: "num9")
                blurr1.texture = SKTexture(imageNamed: "BlueNum9")
                
                scoreLabel2.texture = SKTexture(imageNamed: "num9")
                blurr2.texture = SKTexture(imageNamed: "BlueNum9")
                
                scoreLabel3.texture = SKTexture(imageNamed: "num9")
                blurr3.texture = SKTexture(imageNamed: "BlueNum9")
            }
        }
    }
    
    var buttonSequence = [SKSpriteNode]()
    var buttonCount = 0
    var buttonIndex = 0
    var actionButton = SKSpriteNode(imageNamed: "PlayWhite")
    var actionButtonBlurr = SKSpriteNode(imageNamed: "PlayGreenBlurr")

    
    
    override func didMove(to view: SKView) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameScene_sim.pauseGame), name: NSNotification.Name(rawValue: "PauseGame"), object: nil)
        
        self.physicsWorld.contactDelegate = self

        addBackButton()
        addScoreLabels()
        addActionButton()
        
        
        gameState = .touchToBegin
    }
    
    func addButton() {
        var button = SKSpriteNode(imageNamed: "Disc")
        // button.size = CGSize(width: 30, height: 30)
        var randomX = Int(arc4random_uniform(UInt32(650)) + 50)
        var randomY = Int(arc4random_uniform(UInt32(1150)) + 50)
        button.position = CGPoint(x: randomX, y: randomY)
        button.alpha = 0.2
        button.name = "button\(buttonCount)"
        buttonCount += 1
        buttonSequence.append(button)
        addChild(button)
        
        var randomBlurr = Int(arc4random_uniform(3))
        var buttonBlurr = SKSpriteNode()
        
        switch randomBlurr {
        case 0:
            buttonBlurr = SKSpriteNode(imageNamed: "BlueDiscBlurr")
        case 1:
            buttonBlurr = SKSpriteNode(imageNamed: "GreenDiscBlurr")
        case 2:
            buttonBlurr = SKSpriteNode(imageNamed: "RedDiscBlurr")
        default:
            buttonBlurr = SKSpriteNode(imageNamed: "BlueDiscBlurr")
        }
        
        button.addChild(buttonBlurr)
        buttonBlurr.zPosition = -1
    }
    
    func addScoreLabels() {
        scoreLabel1.zPosition = 3
        scoreLabel1.position = CGPoint(x: self.size.width/2 - scoreLabel1.size.width - 20, y: 1334 - scoreLabel1.size.height/2 - 40)
        scoreLabel2.zPosition = 3
        scoreLabel2.position = CGPoint(x: self.size.width/2, y: 1334 - scoreLabel2.size.height/2 - 40)
        scoreLabel3.zPosition = 3
        scoreLabel3.position = CGPoint(x: self.size.width/2 + scoreLabel3.size.width + 20, y: 1334 - scoreLabel3.size.height/2 - 40)
        addChild(scoreLabel1)
        addChild(scoreLabel2)
        addChild(scoreLabel3)
        
        scoreLabel1.addChild(blurr1)
        scoreLabel2.addChild(blurr2)
        scoreLabel3.addChild(blurr3)
        
        blurr1.zPosition = -1
        blurr2.zPosition = -1
        blurr3.zPosition = -1
    }
    
    func addActionButton() {
        //actionButton.text = "Play Sequence"
        actionButton.position = CGPoint(x: self.size.width/2, y: 100)
        actionButton.name = "actionButton"
        self.actionButton.size = actionButton.texture!.size()
        self.actionButtonBlurr.size = actionButtonBlurr.texture!.size()
        self.addChild(actionButton)
        
        actionButton.addChild(actionButtonBlurr)
        actionButtonBlurr.zPosition = -1
    }
    
   func animateButtons() {
        addButton()
        for i in 0..<buttonSequence.count {
            
            let initialWait = SKAction.wait(forDuration: TimeInterval(0.5))
            
            let iWait = SKAction.wait(forDuration: TimeInterval(1 * CGFloat(i)))
            
            let alphaAction = SKAction.run {
                self.buttonSequence[i].alpha = 1
            }
            alphaAction.timingMode = .easeIn
            
            let waitAction = SKAction.wait(forDuration: TimeInterval(0.5))
            
            let alphaBack = SKAction.run {
                self.buttonSequence[i].alpha = 0.2
            }
            alphaBack.timingMode = .easeOut
            
            let finalAction = SKAction.run {
                if i == self.buttonSequence.count - 1 {
                    self.gameState = .tapping
                    self.actionButton.texture = SKTexture(imageNamed: "Repeat")
                    self.actionButtonBlurr.texture = SKTexture(imageNamed: "RepeatBlurr")
                    self.actionButton.size = self.actionButton.texture!.size()
                    self.actionButtonBlurr.size = self.actionButtonBlurr.texture!.size()
                    self.isUserInteractionEnabled = true
                }
            }
            
            buttonSequence[i].run(SKAction.sequence([initialWait, iWait, alphaAction, waitAction, alphaBack]))
            
            let finalWait = SKAction.wait(forDuration: TimeInterval(CGFloat(buttonSequence.count)))
            
            self.run(SKAction.sequence([SKAction.wait(forDuration: 0.25), finalWait, waitAction, finalAction]))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "BackButton" {
                let menuScene = MenuScene(fileNamed: "MenuScene")
                menuScene?.scaleMode = .aspectFit
                menuScene?.gameName = "sim"
                menuScene?.gameVC = gameVC
                
                
                self.view?.presentScene(menuScene!, transition: SKTransition.doorway(withDuration: 1))
            }
            
            if gameState == .touchToBegin {
                if atPoint(location).name == "actionButton" {
                    gameState = .memorizing
                    self.actionButton.texture = SKTexture(imageNamed: "Memorize")
                    self.actionButtonBlurr.texture = SKTexture(imageNamed: "MemorizeBlurr")
                    self.actionButton.size = actionButton.texture!.size()
                    self.actionButtonBlurr.size = actionButtonBlurr.texture!.size()
                    self.isUserInteractionEnabled = false
                    animateButtons()
                }
            }
            
            if atPoint(location).name == "PauseButton" {
                if isGamePaused == false {
                    pauseGame()
                } else {
                    isGamePaused = false
                    self.isPaused = false
                    pauseButton.texture = SKTexture(imageNamed: "PauseButtonWhite")
                    self.speed = 1.0
                    self.physicsWorld.speed = 1.0
                }
            }
            
            if gameState == .tapping {
                
                for i in 0..<buttonSequence.count {
                    if atPoint(location).name == buttonSequence[i].name {
                        
                        let alphaAction = SKAction.run {
                            self.buttonSequence[i].alpha = 1
                        }
                        buttonSequence[i].run(alphaAction, withKey: "alphaAction")
                    }
                }
                
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState == .tapping {
            if let touch = touches.first {
                let location = touch.location(in: self)
                
                if gameState == .tapping || gameState == .touchToBegin || gameState == .gameOver {
                    for i in 0..<buttonSequence.count {
                        buttonSequence[i].alpha = 0.2
                    }
                }
            
            if atPoint(location).name == buttonSequence[buttonIndex].name {
                buttonIndex += 1
                if buttonIndex < buttonSequence.count {
                } else {
                    gameState = .touchToBegin
                    //actionButton.text = "Correct!"
                    self.actionButton.texture = SKTexture(imageNamed: "Correct")
                    self.actionButtonBlurr.texture = SKTexture(imageNamed: "CorrectBlurr")
                    self.actionButton.size = actionButton.texture!.size()
                    self.actionButtonBlurr.size = actionButtonBlurr.texture!.size()
                    buttonIndex = 0
                    let wait = SKAction.wait(forDuration: 0.75)
                    let run = SKAction.run {
                        //self.actionButton.text = "Play Sequence"
                        self.actionButton.texture = SKTexture(imageNamed: "PlayWhite")
                        self.actionButtonBlurr.texture = SKTexture(imageNamed: "PlayGreenBlurr")
                        self.actionButton.size = self.actionButton.texture!.size()
                        self.actionButtonBlurr.size = self.actionButtonBlurr.texture!.size()
                        self.score += 1
                    }
                    self.run(SKAction.sequence([wait, run]))
                }
            } else if atPoint(location).name != buttonSequence[buttonIndex].name {
                gameOver()
            }
            
            if gameState == .gameOver {
                if atPoint(location).name == "actionButton" {
                    //actionButton.text = "Play Sequence"
                    self.actionButton.texture = SKTexture(imageNamed: "PlayWhite")
                    self.actionButtonBlurr.texture = SKTexture(imageNamed: "PlayGreenBlurr")
                    self.actionButton.size = actionButton.texture!.size()
                    self.actionButtonBlurr.size = actionButtonBlurr.texture!.size()
                    gameState = .touchToBegin
                }
            }
        }
        }
    }
    
    @objc func pauseGame() {
        //timeCheck = 1
        self.isPaused = true
        isGamePaused = true
        pauseButton.texture = SKTexture(imageNamed: "PlayButtonWhite")
        self.speed = 0.0
        self.physicsWorld.speed = 0.0
    }
    
    func gameOver() {
        
        UserDefaults.standard.set(score, forKey: "RecentScore_sim")
        if score > UserDefaults.standard.integer(forKey: "HighScore_sim") {
            UserDefaults.standard.set(score, forKey: "HighScore_sim")
        }
        
        if let view = self.view as SKView? {
            let scene = MenuScene(fileNamed: "MenuScene")
            scene?.scaleMode = .aspectFit
            scene?.gameName = "sim"
            scene?.gameVC = self.gameVC
            view.presentScene(scene)
        }
        
    }
    
    func addBackButton() {
        let backButton = SKSpriteNode(texture: SKTexture(imageNamed: "BackButton"))
        backButton.name = "BackButton"
        //backButton.size = CGSize(width: 32.3, height: 75)
        backButton.zPosition = 6
        addChild(backButton)
        
        let backButtonBlurr = SKSpriteNode(imageNamed: "BlueBackButtonBlurr")
        //ZbackButtonBlurr.size = CGSize(width: 67.2, height: 115.8)
        backButton.addChild(backButtonBlurr)
        backButtonBlurr.zPosition = -1
        
        backButton.position = CGPoint(x: 0 + backButtonBlurr.size.width/2 + 25, y: 1334 - backButtonBlurr.size.height/2 - 25)
        
    }
    
    func addPauseButton() {
        pauseButton = SKSpriteNode(texture: SKTexture(imageNamed: "PauseButtonWhite"))
        pauseButton.name = "PauseButton"
        pauseButton.size.width = frame.size.width/10
        pauseButton.size.height = pauseButton.size.width
        pauseButton.position = CGPoint(x: frame.maxX - pauseButton.size.width/2, y: frame.maxY - pauseButton.size.height/2 - 40)
        pauseButton.zPosition = 6
        addChild(pauseButton)
    }
}

