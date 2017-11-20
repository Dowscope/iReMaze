//
//  MenuScene.swift
//  iReMaze
//
//  Created by Timothy Dowling on 2017-11-19.
//  Copyright © 2017 Timothy Dowling. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    var startLBL = SKLabelNode()
    var creditsLBL = SKLabelNode()
    
    var plusLBL = SKLabelNode()
    var minusLBL = SKLabelNode()
    var columnsLBL = SKLabelNode()
    
    var numOfColumns: Int = 10
    
    let sceneTrans = SKTransition.doorsOpenHorizontal(withDuration: 2.0)
    
    override func didMove(to view: SKView) {
        startLBL = self.childNode(withName: "startLBL") as! SKLabelNode
        creditsLBL = self.childNode(withName: "creditsLBL") as! SKLabelNode
        plusLBL = self.childNode(withName: "plusLBL") as! SKLabelNode
        minusLBL = self.childNode(withName: "minusLBL") as! SKLabelNode
        columnsLBL = self.childNode(withName: "columnsLBL") as! SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            
            if startLBL.contains(location) {
                let sceneToMoveTo = GameScene(size: self.size)
                GameScene.amountOfTiles = CGFloat(numOfColumns)
                sceneToMoveTo.scaleMode = self.scaleMode
                self.removeFromParent()
                self.view!.presentScene(sceneToMoveTo, transition: sceneTrans)
            }
            if plusLBL.contains(location) {
                if numOfColumns < 30 {
                    numOfColumns += 1
                }
            }
            if minusLBL.contains(location) {
                if numOfColumns > 5 {
                    numOfColumns -= 1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        columnsLBL.text = "\(numOfColumns)"
    }
}
