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
    
    static let Ball: UInt32 = 0x1 << 0
    static let Platform: UInt32 = 0x1 << 1
    static let Border: UInt32 = 0x1 << 2
}
