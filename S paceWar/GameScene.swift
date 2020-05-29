//
//  GameScene.swift
//  S paceWar
//
//  Created by Fulcherberguer, Fernanda on 2020-05-27.
//  Copyright © 2020 Fulcherberguer, Fernanda. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    //Add player
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    //Add sound when you fire the bullet, out of any function so there won't be any dely on the sound
    let bulletSound = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
    //Create game area
    var gameArea = CGRect()
    
    override init(size: CGSize) {
        
        //Create playable width of the game
        let maxAspectRatio: CGFloat = 14.0/9.0
        let playableWidth = size.height / maxAspectRatio
        //Create Margin for the gamescene
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    
    
    
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
        
        //Determine size of the player
        player.setScale(0.27)
        //Position of the player
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        //Give the player a layer
        player.zPosition = 2
        //Add player asset
        self.addChild(player)
        
         
        
    }
    
    //Create a new funtion for the bullet
    func fireBullet()  {
        
        //Add the bullet
        let bullet = SKSpriteNode(imageNamed: "bullet")
        //Determine the size of the bullet
        bullet.setScale(0.10)
        //Match bullet position to the player
        bullet.position = player.position
        //Give bullet a layer
        bullet.zPosition = 1
        //Add bullet asset
        self.addChild(bullet)
        
        //Move the bullet
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1.50)
        //Delete bullet once it reaches the point
        let deleteBullet = SKAction.removeFromParent()
        //Create a sequence
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        //Make the sequence run
        bullet.run(bulletSequence)
        
    }

    
    //Tap to fire the bullet
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireBullet()
    }
    
    //Give movement to the player
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            //Location that we are touching in the scene
            let pointOfTouch = touch.location(in: self)
            //Where we were touching in the scene
            let previousPointOfTouch = touch.previousLocation(in: self)
             //How much we have dragged left or right
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            //Move the player
            player.position.x += amountDragged
            
             // Check if player is in playable area
             // Too far right
             if player.position.x >= gameArea.maxX - player.size.width/2 {
                 player.position.x = gameArea.maxX - player.size.width/2
             }
             // Too far left
             if player.position.x <= gameArea.minX + player.size.width/2 {
                 player.position.x = gameArea.minX + player.size.width/2
                
             }
            
        
            
    }
    
    
    
    
}
 
 
}
