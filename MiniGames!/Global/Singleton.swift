//
//  Shared.swift
//  BrickBreaker
//
//  Created by Pete Connor on 4/12/18.
//  Copyright © 2018 c0nman. All rights reserved.

import Foundation

class Singleton: NSObject {
    static let shared: Singleton = Singleton()
    
    var gameItems = ["collide", "evade", "bounce", "flash", "shoot", "match"]
        
    var appID = "ca-app-pub-3940256099942544/2934735716"
    
    private override init() {
        super.init()
    }
}
