//
//  GameScene.swift
//  iReMaze
//
//  Created by Timothy Dowling on 2017-11-04.
//  Copyright © 2017 Timothy Dowling. All rights reserved.
//

// This is a maze generater created by me which could possibly be used in the future for
// games.  The computer will generate a maze procedurely.

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // Initialize the UI
    var uiManager: UIManager!
    
    // Create a camera node to hold the maze and the ui
    let mainCamera = SKCameraNode()
    
    // Create an array to hold all the TILES of the maze
    var tileContainer = [Tile]()
    
    // Set amount of tiles wanted
    let amountOfTiles: CGFloat = 10
    
    // RWe need a start index
    var startingTile: Int = 0
    
    // Initialize the size of the tiles
    var tileSize: CGFloat = 0
    
    // Create an array to hold the visited tiles
    var visitedTiles = [Tile]()
    
    // Create a current tile
    var currentTile: Tile?
    
    // Set a flag for map ceation completed
    var isMapCreated = false
    
    // Set Flag for game over.
    var isGameOver = false
    
    // Toggle Flag on/off
    var toggleSW = false
    
    // Set the first tile to the starting tile.
    var previousTile: Tile!
    
    // Initialize the clock
    var timer: TimeInterval = 0
    var runTimer = false
    var lastTime: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        
        // Set the tile size need to achieve the amount of tiles.
        tileSize = frame.width / amountOfTiles
        
        // Correct where the 0,0 coord is located.
        anchorPoint = CGPoint(x: 0, y: 0)
        
        mainCamera.position = CGPoint(x: 0, y: 300)
        addChild(mainCamera)
        
        // Load the tile container full of tiles.
        for y in 0..<Int(amountOfTiles) {
            for x in 0..<Int(amountOfTiles) {
                let tile = Tile(CGPoint(x: CGFloat(x), y: CGFloat(y)), tileSize)
                //mainCamera.addChild(tile.floorGFX)
                mainCamera.addChild(tile.topWallGFX)
                mainCamera.addChild(tile.bottomWallGFX)
                mainCamera.addChild(tile.leftWallGFX)
                mainCamera.addChild(tile.rightWallGFX)
                
                mainCamera.addChild(tile.floorSprite)
                
                mainCamera.addChild(tile.startTile)
                mainCamera.addChild(tile.endTile)
                
                tileContainer.insert(tile, at: (x + y * Int(amountOfTiles)))
            }
        }
        
        // Add the UIManager to the scene
        uiManager = UIManager(scene: self)
        uiManager.position = CGPoint(x: 0, y: 175)
        addChild(uiManager)
        
        // Create a game board
        newBoard()
    }
    
    func newBoard() {
        for tile in tileContainer {
            tile.resetTile()
        }
        
        isGameOver = false
        uiManager.instructionLBL.text = uiManager.instructionSTR
        
        startingTile = Int(arc4random_uniform(UInt32(amountOfTiles*amountOfTiles)))
        
        currentTile = tileContainer[startingTile]
        currentTile?.current()
        currentTile?.floorGFX.fillColor = Tile.START_COLOUR
        currentTile?.isStartingTile = true
        
        // Set the previous tile to the starting tile
        previousTile = tileContainer[startingTile]
        
        isMapCreated = false
        createBoard()
        
        drawTiles()
        
        runTimer = true
    }
    
    func createBoard() {
        while isMapCreated == false {
            if let nextTile = findNextNeighbour() {
                currentTile?.visit()
                visitedTiles.append(currentTile!)
                
                // Remove the walls between the two tiles
                let x = (currentTile?.positionOnBoard.x)! - nextTile.positionOnBoard.x
                let y = (currentTile?.positionOnBoard.y)! - nextTile.positionOnBoard.y
                
                if x > 0 {
                    currentTile?.leftWallGFX.isHidden = true
                    currentTile?.hasLeftWall = false
                    nextTile.rightWallGFX.isHidden = true
                    nextTile.hasRightWall = false
                }
                else if x < 0 {
                    currentTile?.rightWallGFX.isHidden = true
                    currentTile?.hasRightWall = false
                    nextTile.leftWallGFX.isHidden = true
                    nextTile.hasLeftWall = false
                }
                else if y < 0 {
                    currentTile?.topWallGFX.isHidden = true
                    currentTile?.hasTopWall = false
                    nextTile.bottomWallGFX.isHidden = true
                    nextTile.hasBottomWall = false
                }
                else {
                    currentTile?.bottomWallGFX.isHidden = true
                    currentTile?.hasBottomWall = false
                    nextTile.topWallGFX.isHidden = true
                    nextTile.hasTopWall = false
                }
                
                currentTile = nextTile
                currentTile?.current()
            }else {
                currentTile?.visit()
                if visitedTiles.isEmpty {
                    isMapCreated = true
                    setExitTile()
                    return
                }
                currentTile = visitedTiles.popLast()
                currentTile?.current()
            }
        }
    }
    
    func drawTiles() {
        for tile in tileContainer {
            tile.drawFloorSprite()
            if tile.isStartingTile {
                tile.startTile.isHidden = false
            }
            if tile.isEndTile {
                tile.endTile.isHidden = false
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        if isMapCreated == false {
            createBoard()
            timer = 0
            runTimer = true
        }else {
            if runTimer {
                if lastTime == 0 {
                    lastTime = currentTime
                }else {
                    let delta = currentTime - lastTime
                    timer += delta
                }
            }
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let uiLocation = touch.location(in: uiManager)
            
            if uiManager.exitBTN.contains(uiLocation) {
                exit(0)
            }
            
            if uiManager.startOverBTN.contains(uiLocation) {
                newBoard()
            }
            
            if uiManager.toggleBTN.contains(uiLocation) {
                if toggleSW {
                    for tile in tileContainer {
                        tile.floorSprite.isHidden = false
                    }
                    toggleSW = false
                }
                else {
                    for tile in tileContainer {
                        tile.floorSprite.isHidden = true
                    }
                    toggleSW = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if isMapCreated && !isGameOver{
                let mazeLocation = touch.location(in: mainCamera)
                
                for tile in tileContainer {
                    if tile.floorGFX.contains(mazeLocation) {
                        if tile.isEndTile {
                            gameOver()
                        }
                        if isNextTile(previousTile, tile) {
                            tile.startTile.isHidden = false
                            previousTile = tile
                        }
                        break
                    }
                }
            }
        }
    }
    
    func isNextTile(_ previousTile: Tile, _ nextTile: Tile) -> Bool{
        if previousTile.positionOnBoard.x - 1 == nextTile.positionOnBoard.x &&
            previousTile.positionOnBoard.y == nextTile.positionOnBoard.y{
            if previousTile.hasLeftWall {
                return false
            }
            return true
        }
        else if previousTile.positionOnBoard.x + 1 == nextTile.positionOnBoard.x &&
            previousTile.positionOnBoard.y == nextTile.positionOnBoard.y{
            if previousTile.hasRightWall {
                return false
            }
            return true
        }
        else if previousTile.positionOnBoard.y - 1 == nextTile.positionOnBoard.y  &&
            previousTile.positionOnBoard.x == nextTile.positionOnBoard.x{
            if previousTile.hasBottomWall {
                return false
            }
            return true
        }
        else if previousTile.positionOnBoard.y + 1 == nextTile.positionOnBoard.y  &&
            previousTile.positionOnBoard.x == nextTile.positionOnBoard.x{
            if previousTile.hasTopWall {
                return false
            }
            return true
        }
        return false
    }
    
    func gameOver() {
        isGameOver = true
        runTimer = false
        uiManager.instructionLBL.text = "\(uiManager.gameOverSTR) It took you \(timer)"
    }
    
    
    
    func setExitTile() {
        // Setting the exit tile.  0 = top left -> go clock-wise
        let random = Int(arc4random_uniform(4))
        var s : String
        
        switch random {
        case 0:
            s = "Tile_0_\(Int(amountOfTiles) - 1)"
        case 1:
            s = "Tile_\(Int(amountOfTiles) - 1)_\(Int(amountOfTiles) - 1)"
        case 2:
            s = "Tile_\(Int(amountOfTiles) - 1)_0"
        default:
            s = "Tile_0_0"
        }
        
        let tile = getTile(at: s)
        tile?.floorGFX.fillColor = Tile.END_COLOUR
        tile?.isEndTile = true
    }
    
    func findNextNeighbour() -> Tile? {
        // Get the position of the current tile on the board.
        let locationOfCurrentTile = (currentTile?.positionOnBoard)!
        
        // Create some tmp variables
        var topTile: Tile?
        var bottomTile: Tile?
        var leftTile: Tile?
        var rightTile: Tile?
        
        // Create an array to hold the non nil tiles
        var tempArray = [Tile?]()
        
        // Get the surrounding tiles of the current tile
        if locationOfCurrentTile.x < amountOfTiles - 1 {
            let s = "Tile_\(Int(locationOfCurrentTile.x) + 1)_\(Int(locationOfCurrentTile.y))"
            rightTile = getTile(at: s)
            if (rightTile?.hasBeenVisited)! && rightTile != nil {
                rightTile = nil
            }
            if rightTile != nil {
                tempArray.append(rightTile)
            }
        }
        
        if locationOfCurrentTile.x > 0 {
            let s = "Tile_\(Int(locationOfCurrentTile.x) - 1)_\(Int(locationOfCurrentTile.y))"
            leftTile = getTile(at: s)
            if (leftTile?.hasBeenVisited)! && leftTile != nil {
                leftTile = nil
            }
            if leftTile != nil {
                tempArray.append(leftTile)
            }
        }
        
        if locationOfCurrentTile.y < amountOfTiles - 1 {
            let s = "Tile_\(Int(locationOfCurrentTile.x))_\(Int(locationOfCurrentTile.y) + 1)"
            topTile = getTile(at: s)
            if (topTile?.hasBeenVisited)! && topTile != nil {
                topTile = nil
            }
            if topTile != nil {
                tempArray.append(topTile)
            }
        }
        
        if locationOfCurrentTile.y > 0 {
            let s = "Tile_\(Int(locationOfCurrentTile.x))_\(Int(locationOfCurrentTile.y) - 1)"
            bottomTile = getTile(at: s)
            if (bottomTile?.hasBeenVisited)! && bottomTile != nil {
                bottomTile = nil
            }
            if bottomTile != nil {
                tempArray.append(bottomTile)
            }
        }
        
        if tempArray.isEmpty {
            return nil
        }
        
        let randomIndex = Int(arc4random_uniform(UInt32(tempArray.count)))
        
        let tile = tempArray[randomIndex]
        
        return tile
    }
    
    func getTile(at location: String) -> Tile? {
        for tile in tileContainer {
            if tile.name == location {
                return tile
            }
        }
        return nil
    }
    
}
