//
//  GameObjectNode.swift
//  ProjectNoName
//
//  Created by Julio Hernandez on 12/19/16.
//  Copyright © 2016 Palm Studios. All rights reserved.
//

import UIKit
import SpriteKit

struct CollisionCategoryBitMask {
    
    static let Person = 0x1 << 1
    static let Platform = 0x1 << 2
    static let Border = 0x1 << 3
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}

class GameObjectNode: SKNode {
    
    func collisionWithPlayer(player: SKNode) -> Bool{
        
        return false
    }
    
    func checkNodeRemoval(playerY: CGFloat) {
        if playerY > self.position.y + 300.0 {
            self.removeFromParent()
        }
    }
}

class PlatfromNode: GameObjectNode {
    
    var platfromType: PlatformType!
    
    override func collisionWithPlayer(player: SKNode) -> Bool {
        
        if (player.physicsBody?.velocity.dy)! < CGFloat(0) {
            player.physicsBody?.velocity = CGVector(dx: player.physicsBody!.velocity.dx, dy: 250.0)
        }
        return false
    }
    
}
