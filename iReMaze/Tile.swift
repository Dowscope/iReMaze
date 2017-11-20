//
//  Tile.swift
//  iReMaze
//
//  Created by Timothy Dowling on 2017-11-15.
//  Copyright © 2017 Timothy Dowling. All rights reserved.
//

import SpriteKit

// Tile Class -- Used to hold information about each tile on the maze.
class Tile {
    // Tiles will have a position on the board.
    let positionOnBoard: CGPoint
    
    // Title will need to know its size
    let tileSize: CGFloat
    
    // Tiles will have a name
    let name: String
    
    // Tiles will need to know if they have been visited before. Initially set to false
    var hasBeenVisited = false
    
    // Flag for current tile
    var isCurrent = false
    
    // Flag for the starting tile
    var isStartingTile = false
    
    // Flag for the end tile
    var isEndTile = false
    
    // Tiles will need to know what walls they have visible. Initally all will be set to true.
    var hasTopWall      = true
    var hasBottomWall   = true
    var hasLeftWall     = true
    var hasRightWall    = true
    
    // Tiles will have certain colors to remember.
    static let FLOOR_COLOUR = SKColor.blue
    static let VISITED_COLOUR = SKColor.purple
    static let WALL_COLOUR = SKColor.white
    static let CURRENT_COLOUR = SKColor.darkGray
    static let START_COLOUR = SKColor.green
    static let END_COLOUR = SKColor.red
    
    // Tiles need visuals
    var floorSprite = SKSpriteNode(imageNamed: "Tile_1111")
    
    var startTile = SKSpriteNode(imageNamed: "StartDot")
    var endTile = SKSpriteNode(imageNamed: "EndDot")
    
    // Class needs an initializer -- Takes in a position and a size from calling class
    init(_ position: CGPoint, _ size: CGFloat){
        positionOnBoard = position
        tileSize = size
        name = "Tile_\(Int(position.x))_\(Int(position.y))"
        
        // Create the floor sprite visual.
        floorSprite.position = CGPoint(x: positionOnBoard.x * tileSize, y: positionOnBoard.y * tileSize)
        floorSprite.size = CGSize(width: tileSize, height: tileSize)
        floorSprite.zPosition = CGFloat(-2)
        floorSprite.anchorPoint = CGPoint.zero
        
        // Initialize the start and end dots
        startTile.position = CGPoint(x: positionOnBoard.x * tileSize + (tileSize/2), y: positionOnBoard.y * tileSize + (tileSize/2))
        startTile.size = CGSize(width: tileSize - 50, height: tileSize - 50)
        startTile.zPosition = (0)
        startTile.isHidden = true
        
        endTile.position = CGPoint(x: positionOnBoard.x * tileSize + (tileSize/2), y: positionOnBoard.y * tileSize + (tileSize/2))
        endTile.size = CGSize(width: tileSize - 50, height: tileSize - 50)
        endTile.zPosition = CGFloat(0)
        startTile.isHidden = true
    }
    
    // Tool used to create a CGPath
    func makePath(startPoint: CGPoint, endPoint: CGPoint) -> CGPath{
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.close()
        
        return path.cgPath
    }
    
    func resetTile() {
        hasBeenVisited = false
        isStartingTile = false
        isCurrent = false
        isEndTile = false
        hasBottomWall = true
        hasTopWall = true
        hasLeftWall = true
        hasRightWall = true
        
        startTile.isHidden = true
        endTile.isHidden = true
    }
    
    func visit() {
        hasBeenVisited = true
        isCurrent = false
        if isStartingTile { return }
    }
    
    func current(){
        isCurrent = true
        if isStartingTile { return }
    }
    
    func drawFloorSprite() {
        var s = "Tile_"
        
        if hasTopWall {
            s += "1"
        } else {
            s += "0"
        }
        if hasRightWall {
            s += "1"
        } else {
            s += "0"
        }
        if hasBottomWall {
            s += "1"
        } else {
            s += "0"
        }
        if hasLeftWall {
            s += "1"
        } else {
            s += "0"
        }
        
        floorSprite.texture = SKTexture(imageNamed: s)
    }
}
