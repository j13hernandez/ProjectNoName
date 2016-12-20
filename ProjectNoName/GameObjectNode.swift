//
//  GameObjectNode.swift
//  ProjectNoName
//
//  Created by Julio Hernandez on 12/19/16.
//  Copyright © 2016 Palm Studios. All rights reserved.
//

import UIKit
import SpriteKit

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
