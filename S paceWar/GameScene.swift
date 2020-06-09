//
//  GameScene.swift
//  S paceWar
//
//  Created by Fulcherberguer, Fernanda on 2020-05-27.
//  Copyright © 2020 Fulcherberguer, Fernanda. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //Add player
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    //Add sound when you fire the bullet, out of any function so there won't be any dely on the sound
    let bulletSound = SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false)
    
    //Add sound to the explosion
    let explosionSound = SKAction.playSoundFileNamed("smart-bomb.wav", waitForCompletion: false)
    
    
    
    //Make them interact with specific things
    struct physicsCategories {
        static let None : UInt32 = 0
        static let Player : UInt32 = 0b1 //1
        static let Bullet : UInt32 = 0b10 //2
        static let Enemy : UInt32 = 0b100 //4
         
    }
    
    
    //Create enemyship
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    //Setting up the infromation for a random number
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
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
        
        //Be able to have contact in the scene
        self.physicsWorld.contactDelegate = self
        
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
        player.setScale(0.65)
        //Position of the player
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        //Give the player a layer
        player.zPosition = 2
        //Add phisics to the player
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //Don't let it be afected by gravity
        player.physicsBody!.affectedByGravity = false
        //Give player interaction
        player.physicsBody!.categoryBitMask = physicsCategories.Player
        //No colision
        player.physicsBody!.collisionBitMask = physicsCategories.None
        //Have contact with the enemy
        player.physicsBody!.contactTestBitMask = physicsCategories.Enemy
        //Add player asset
        self.addChild(player)
        
        //Start Sequence
        startNewLevel()
        
    }
    
    //Run when there is contact
    func didBegin(_ contact: SKPhysicsContact) {
        
        //Declare bodies
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //If any contacs happens
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        
    //If it not happens flip it
        else{
            
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //If the player hits the enemy
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Enemy{
            
            
            
            //Only do this when there is a node
            if body1.node != nil{
            //When it hits the player do the Explosion
            spwanExplosion(spawnPosition: body1.node!.position)
            }
            
            
            //Only do this when there is a node
            if body2.node != nil {
            //When it hits the enemy do th explosion
            spwanExplosion(spawnPosition: body2.node!.position)
            }
        
            //If the hit happens delete the player and the enemy
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
        ///If the bullet hits the enemy
        if body1.categoryBitMask == physicsCategories.Bullet && body2.categoryBitMask == physicsCategories.Enemy && body2.node?.position.y ?? 0 > self.size.height {
            
            
            //Only do this when there is a node
            if body2.node != nil {
            //If the bullet an enemy hit
            spwanExplosion(spawnPosition: body2.node!.position)
        }
            
            //If the hit happens delete the bullet and the enemy
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            
        }
        
     }
    
    //Everytime you kill a enemy a explosion will happen
    func spwanExplosion(spawnPosition: CGPoint){
        
        //Add asset
        let explosion = SKSpriteNode(imageNamed: "explosion")
        //Set starting position
        explosion.position = spawnPosition
        //Give it a layer
        explosion.zPosition = 3
        //Set scale
        explosion.setScale(0)
        //Add asset
        self.addChild(explosion)
        
        //Make explosion bigger
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        //Fade out
        let fadeOut = SKAction.fadeOut(withDuration:  0.1)
        //Delete explosion
        let delete = SKAction.removeFromParent()
        
        //Run as a sequence
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        //Run the sequence
        explosion.run(explosionSequence)
        
        
        
        
        
        
        
        
        
    }
    
  
    
    //Make enemy come by themselves
    func startNewLevel(){
        let spawn = SKAction.run(spawnEnemy)
        //Wait for the next flow
        let waitToSpawn = SKAction.wait(forDuration: 1)
        //Create Sequence
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        //Keep doing the sequence
        let spawnForever = SKAction.repeatForever(spawnSequence)
        //Run the sequence on the game scene
        self.run(spawnForever)
        
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
        //Add phisics to the player
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        //Don't let it be afected by gravity
        bullet.physicsBody!.affectedByGravity = false
        //Give bullet interaction
        bullet.physicsBody!.categoryBitMask = physicsCategories.Bullet
        //No colision
        bullet.physicsBody!.collisionBitMask = physicsCategories.None
        //Have contact with the enemy
        bullet.physicsBody!.contactTestBitMask = physicsCategories.Enemy
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

    //Create enemyship 
    func spawnEnemy(){
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        //Where the enemy will move to
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        //Where the enemy ship will begin
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        //Where the enemy ship will stop
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //Add enemy asset
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        //Set enemy size
        enemy.setScale(0.35)
        //POsition of the enemy
        enemy.position = startPoint
        //Give enemy a layer
        enemy.zPosition = 2
        //Add phisics to the player
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        //Don't let it be afected by gravity
        enemy.physicsBody!.affectedByGravity = false
        //Give bullet interaction
        enemy.physicsBody!.categoryBitMask = physicsCategories.Enemy
        //No colision
        enemy.physicsBody!.collisionBitMask = physicsCategories.None
        //Have contact with the player and the bullet
        enemy.physicsBody!.contactTestBitMask = physicsCategories.Player | physicsCategories.Bullet
        //Add player asset
        self.addChild(enemy)
        
        //Make enemy move to its end position
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        //Delete enemy after it goes to the endpoint
        let deleteEnemy = SKAction.removeFromParent()
        //Continues that sequence everytime
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        //Run the sequence
        enemy.run(enemySequence)
        
        //Figure out the difference between the two points
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        //Make enemy rotate to face the player
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
        
       
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

