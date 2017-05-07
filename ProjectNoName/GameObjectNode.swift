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
    
    static let Ball = 0x1 << 1
    static let Platform = 0x1 << 2
    static let Border = 0x1 << 3
}

enum PlatformType: Int {
    case Normal = 0
    case Break
}
