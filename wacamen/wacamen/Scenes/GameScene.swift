//
//  GameScene.swift
//  wacamen
//
//  Created by 小林彩花 on 2017/11/17.
//  Copyright © 2017年 小林彩花. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct Bitmask {
        let Player: UInt32 = (1 << 0)
        let Ground: UInt32  = (1 << 1)
        let Obstacle: UInt32 = (1 << 2)
    }

    override func didMove(to view: SKView) {
        //物理設定
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        //衝突情報を自分で受け取る
        self.physicsWorld.contactDelegate = self
        
        self.setupBackground()
        self.setupPlayer()
        createButton()
        createTree()
        
        //少し待つように実装する
        walkingPlayer()
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "button" {
                jumpPlayer()
            }
        }
    }

    fileprivate var jumpFlag = false
    fileprivate var fallFlag = false
    
    override func update(_ currentTime: TimeInterval) {
        moveTree()
        if(treeArray[0].position.x == -treeArray[0].size.width / 2){
            treeArray.removeFirst()
        }
        obstacleCount = obstacleCount - 1
        if obstacleCount == 0 {
            createObstacle()
            obstacleCount = (Int)(arc4random() % 100 ) + 60
        }
        moveObstacle()
        guard jumpFlag else { return }
        guard let physicsBody = player.physicsBody else { return }
        physicsBody.applyImpulse(CGVector(dx: 0.0, dy: 60.0))
        moveTree()
        jumpFlag = false
        fallFlag = true
    }

    //MARK: - background & floor
    func setupBackground(){
        let backgroundTexture = SKSpriteNode(imageNamed: "background")
        addChild(backgroundTexture)
        backgroundTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height * 2)
        
        let floarTexture = SKSpriteNode(imageNamed: "floar")
        addChild(floarTexture)
        floarTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height / 1.4)
        floarTexture.physicsBody = SKPhysicsBody(texture: floarTexture.texture!, size: floarTexture.size)
        guard let physicsBody = floarTexture.physicsBody else { return }
        physicsBody.isDynamic = false
        //ビットマスクを設定
        physicsBody.categoryBitMask = Bitmask.init().Ground
    }
    
    // MARK: - PLAYER
    struct Constants{
        static let playerImages = ["walking","walking2"]
    }
    var player: SKSpriteNode!
    var playerTexture = [SKTexture]()
    
    func setupPlayer(){
        for i in Constants.playerImages{
            let texture = SKTexture(imageNamed: i)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        player = SKSpriteNode(imageNamed: "standing2")
        player.zPosition = 2
        player.size = CGSize(width: player.size.width / 4, height: player.size.height / 4)
        player.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        guard let physicsBody = player.physicsBody else { return }
        physicsBody.allowsRotation = false
        //ビットマスクを設定
        physicsBody.categoryBitMask = Bitmask.init().Player
        physicsBody.contactTestBitMask = Bitmask.init().Obstacle
        physicsBody.contactTestBitMask = Bitmask.init().Ground
        self.addChild(player)
    }
    
    func walkingPlayer(){
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        let loopAnimation = SKAction.repeatForever(playerAnimation)
        player.run(loopAnimation)
    }
    
    func jumpPlayer(){
        guard !jumpFlag && !fallFlag else {
            return
        }
        jumpFlag = true
    }
    
    // MARK: - BUTTON
    func createButton(){
        let button = SKSpriteNode(imageNamed: "rightButton")
        button.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 4)
        button.zPosition = 1
        button.name = "button"
        self.addChild(button)
    }
    
    // MARK: - TREE
    fileprivate var treeArray: Array<SKSpriteNode> = []
    
    func createTree(){
        let random = (Int)(arc4random() % 10) + 1
        treeArray.append(SKSpriteNode(imageNamed: "tree" + String(random)))
        treeArray[treeArray.count - 1].size = CGSize(width: self.frame.size.width / 4, height: self.frame.size.height / 2)
        treeArray[treeArray.count - 1].position = CGPoint(x: self.frame.size.width + treeArray[treeArray.count - 1].size.width / 2, y: self.frame.size.height / 2 + 45)
        treeArray[treeArray.count - 1].zPosition = 1
        self.addChild(treeArray[treeArray.count - 1])
    }
    
    func moveTree(){
        for i in 0 ... treeArray.count - 1{
            treeArray[i].position.x -= 5
            if(treeArray[i].position.x == self.frame.size.width / 2){
                createTree()
            }
        }
    }
    
    //MARK: - Obstacle
    fileprivate var obstacleCount: Int = 30
    fileprivate var obstacleArray: Array<SKSpriteNode> = []
    
    func createObstacle(){
        let obstacle = SKSpriteNode(imageNamed: "obstacle")
        obstacleArray.append(obstacle)
        self.addChild(obstacle)

        obstacle.size = CGSize(width: 50, height: 50)
        obstacle.position = CGPoint(x: self.frame.size.width, y: self.frame.size.height / 2 - 30)
        obstacle.zPosition = 2
        
        guard let texture = obstacle.texture else { return }
        obstacle.physicsBody = SKPhysicsBody(texture: texture, size: obstacle.size)
        guard let physicsBody = obstacle.physicsBody else { return }
        physicsBody.allowsRotation = false
        physicsBody.categoryBitMask = Bitmask.init().Obstacle
        physicsBody.contactTestBitMask = Bitmask.init().Player
    }
    
    func moveObstacle(){
        obstacleArray.forEach {
            $0.position.x -= 8
        }
        guard obstacleArray.count > 0 else { return }
        if obstacleArray[0].position.x < -obstacleArray[0].size.width {
            obstacleArray.removeFirst()
        }
    }
   
    // MARK: - PHYSICS
    var viewController: UIViewController?
    //衝突の検知
    func didBegin(_ contact: SKPhysicsContact) {
        //ゲームオーバーの時に抜け出す処理
        let player_ground = Bitmask.init().Player | Bitmask.init().Ground
        let player_obstacle = Bitmask.init().Player | Bitmask.init().Obstacle
        let collisionCheck = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if player_obstacle == collisionCheck {
        }
        
        guard player_ground == collisionCheck else {
            return
        }
        fallFlag = false
    }
}
