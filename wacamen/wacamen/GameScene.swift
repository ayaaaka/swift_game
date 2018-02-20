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
    
    //ビットマスク
    struct Bitmask {
        //プレイヤーに設定するカテゴリ
        let Player: UInt32 = (1 << 0)
        //地面に設定するカテゴリ
        let Ground: UInt32  = (1 << 1)
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
    
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
 */
    
    //ジャンプ中フラグ
    fileprivate var jumpFlag = false
    //落下中フラグ
    fileprivate var fallFlag = false
    
    override func update(_ currentTime: TimeInterval) {
        moveTree()
        if(tree[0].position.x == -tree[0].size.width / 2){
            tree.removeFirst()
        }
        
        guard jumpFlag else {
            return
        }
        guard let physicsBody = player.physicsBody else { return }
        physicsBody.applyImpulse(CGVector(dx: 0.0, dy: 60.0))
        moveTree()
        jumpFlag = false;
        fallFlag = true
    }

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
        physicsBody.contactTestBitMask = Bitmask.init().Ground
        //衝突判定の相手を設定
        physicsBody.collisionBitMask = Bitmask.init().Ground
  
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
    fileprivate var tree: Array<SKSpriteNode> = []
    
    func createTree(){
        let random = (Int)(arc4random() % 10) + 1
        tree.append(SKSpriteNode(imageNamed: "tree" + String(random)))
        tree[tree.count - 1].size = CGSize(width: self.frame.size.width / 4, height: self.frame.size.height / 2)
        tree[tree.count - 1].position = CGPoint(x: self.frame.size.width + tree[tree.count - 1].size.width / 2, y: self.frame.size.height / 2 + 45)
        tree[tree.count - 1].zPosition = 1
        self.addChild(tree[tree.count - 1])
    }
    
    func moveTree(){
        for i in 0 ... tree.count - 1{
            tree[i].position.x -= 5
            if(tree[i].position.x == self.frame.size.width / 2){
                createTree()
            }
        }
    }
    
    // MARK: - PHYSICS
    
    
    //衝突の検知
    func didBegin(_ contact: SKPhysicsContact) {
        //ゲームオーバーの時に抜け出す処理
        //
        
        let rawPlayerType = Bitmask.init().Player
        guard (contact.bodyA.categoryBitMask & rawPlayerType) == rawPlayerType ||
            (contact.bodyB.categoryBitMask & rawPlayerType) == rawPlayerType else {
            return
        }
        fallFlag = false
    }
}
