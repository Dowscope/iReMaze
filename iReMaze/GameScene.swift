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

// Tile Class -- Used to hold information about each tile on the maze.
class Tile {
    // Tiles will have a position on the board.
    let positionOnBoard: CGPoint
    
    // Title will need to know its size
    let tileSize: CGFloat
    
    // Tiles will need to know if they have been visited before. Initially set to false
    var hasBeenVisited: Bool = false
    
    // Tiles will need to know what walls they have visible. Initally all will be set to true.
    var hasTopWall      = true
    var hasBottomWall   = true
    var hasLeftWall     = true
    var hasRightWall    = true
    
    // Tiles will have certain colors to remember.
    static let FLOOR_COLOUR = SKColor.blue
    static let VISITED_COLOUR = SKColor.purple
    static let WALL_COLOUR = SKColor.white
    
    // Tiles need visuals
    let floorGFX : SKShapeNode
    var topWallGFX = SKShapeNode()
    var bottomWallGFX = SKShapeNode()
    var leftWallGFX = SKShapeNode()
    var rightWallGFX = SKShapeNode()
    
    // Class needs an initializer -- Takes in a position and a size from calling class
    init(_ position: CGPoint, _ size: CGFloat){
        positionOnBoard = position
        tileSize = size
        
        // Create the floor visual
        floorGFX = SKShapeNode(rect: CGRect(x: positionOnBoard.x * size, y: positionOnBoard.y * size, width: size, height: size))
        floorGFX.fillColor = Tile.FLOOR_COLOUR
        floorGFX.lineWidth = 0
        
        // Create the top wall visual
        topWallGFX = SKShapeNode(path: makePath(startPoint: CGPoint(x: positionOnBoard.x * size, y: positionOnBoard.y * size + size), endPoint: CGPoint(x: (positionOnBoard.x * size) + size, y: positionOnBoard.y * size + size)))
        topWallGFX.fillColor = Tile.WALL_COLOUR
        topWallGFX.lineWidth = 2
        
        // Create the bottom wall visual
        bottomWallGFX = SKShapeNode(path: makePath(startPoint: CGPoint(x: positionOnBoard.x * size, y: positionOnBoard.y * size), endPoint: CGPoint(x: (positionOnBoard.x * size) + size, y: positionOnBoard.y * size)))
        bottomWallGFX.fillColor = Tile.WALL_COLOUR
        bottomWallGFX.lineWidth = 2
        
        // Create the left wall visual
        leftWallGFX = SKShapeNode(path: makePath(startPoint: CGPoint(x: positionOnBoard.x * size, y: positionOnBoard.y * size), endPoint: CGPoint(x: positionOnBoard.x * size, y: positionOnBoard.y * size + size)))
        leftWallGFX.fillColor = Tile.WALL_COLOUR
        leftWallGFX.lineWidth = 2
        
        // Create the right wall visual
        rightWallGFX = SKShapeNode(path: makePath(startPoint: CGPoint(x: positionOnBoard.x * size + size, y: positionOnBoard.y * size), endPoint: CGPoint(x: (positionOnBoard.x * size) + size, y: positionOnBoard.y * size + size)))
        rightWallGFX.fillColor = Tile.WALL_COLOUR
        rightWallGFX.lineWidth = 2
    }
    
    // Tool used to create a CGPath
    func makePath(startPoint: CGPoint, endPoint: CGPoint) -> CGPath{
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.close()
        
        return path.cgPath
    }
    
    func visit() {
        hasBeenVisited = true
        floorGFX.fillColor = Tile.VISITED_COLOUR
    }
}

class GameScene: SKScene {
    
    // Create an array to hold all the TILES of the maze
    var tileContainer = [Tile]()
    
    // Set amount of tiles wanted
    let amountOfTiles: CGFloat = 5
    
    // Initialize the size of the tiles
    var tileSize: CGFloat = 0
    
    override func didMove(to view: SKView) {
        // Set the tile size need to achieve the amount of tiles.
        tileSize = frame.width / amountOfTiles
        
        // Correct where the 0,0 coord is located.
        anchorPoint = CGPoint(x: 0, y: 0.25)
        
        // Load the tile container full of tiles.
        for y in 0..<Int(amountOfTiles) {
            for x in 0..<Int(amountOfTiles) {
                let tile = Tile(CGPoint(x: CGFloat(x), y: CGFloat(y)), tileSize)
                addChild(tile.floorGFX)
                addChild(tile.topWallGFX)
                addChild(tile.bottomWallGFX)
                addChild(tile.leftWallGFX)
                addChild(tile.rightWallGFX)
                
                tileContainer.insert(tile, at: (x + y * Int(amountOfTiles)))
            }
        }
    }
    
}
