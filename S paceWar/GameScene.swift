//
//  GameScene.swift
//  S paceWar
//
//  Created by Fulcherberguer, Fernanda on 2020-05-27.
//  Copyright © 2020 Fulcherberguer, Fernanda. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //Create backgroud
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        
        //Define size of the background
        background.size = self.size
        //Define the position of the background
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        //Be the bottom layer
        background.zPosition = 0
        //Add background
        self.addChild(background)
        
        //Add player asset
        let player = SKSpriteNode(imageNamed: "playerShip")
        //Determine size of the player
        player.setScale(0.27)
        //Position of the player
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        //Give the player a layer
        player.zPosition = 2
        //Add player asset
        self.addChild(player)
        
        
        
        
    }
    
}
 
 
