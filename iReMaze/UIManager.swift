//
//  UIManager.swift
//  iReMaze
//
//  Created by Timothy Dowling on 2017-11-15.
//  Copyright © 2017 Timothy Dowling. All rights reserved.
//

import SpriteKit

// Maze well need a GUI
class UIManager : SKNode {
    // Get the scene
    let gameScene : SKScene
    
    // Set message strings
    let instructionSTR = "Get from the GREEN dot to the RED dot"
    let gameOverSTR = "YOU WIN!!!"
    
    // Initialize the labels
    let titleLBL = SKLabelNode(text: "MAZE")
    let instructionLBL = SKLabelNode(text: "")
    let exitBTN = SKSpriteNode(imageNamed: "Exit")
    let startOverBTN = SKSpriteNode(imageNamed: "StartOver")
    
    init(scene: SKScene){
        gameScene = scene
        super.init()
        
        // add labels to the scene
        titleLBL.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 220)
        titleLBL.fontSize = 100
        titleLBL.fontName = "Helvetica-bold"
        self.addChild(titleLBL)
        
        instructionLBL.position = CGPoint(x: gameScene.frame.midX, y: 90)
        instructionLBL.text = instructionSTR
        instructionLBL.fontName = "Helvetica"
        self.addChild(instructionLBL)
        
        exitBTN.position = CGPoint(x: 100, y: 50)
        self.addChild(exitBTN)
        
        startOverBTN.position = CGPoint (x: 300, y: 50)
        self.addChild(startOverBTN)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

