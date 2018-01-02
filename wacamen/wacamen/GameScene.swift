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

class GameScene: SKScene {

    override func didMove(to view: SKView) {
        self.setupBackground()
        self.setupPlayer()
        createButton()
        createTree()
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "rightButton" {
                walkingPlayer()
                flag = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.removeAllActions()
        player.texture = SKTexture(imageNamed: "standing2")
        flag = false
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(flag){
            
            for i in 0 ... tree.count - 1{
                tree[i].position.x -= 5
                if(tree[i].position.x == self.frame.size.width / 2){
                    createTree()
                }
            }
            if(tree[0].position.x == -tree[0].size.width / 2){
                tree.removeFirst()
            }
        }
    }
  
    func setupBackground(){
        let backgroundTexture = SKSpriteNode(imageNamed: "background")
        addChild(backgroundTexture)
        backgroundTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height * 2)
        
        let floarTexture = SKSpriteNode(imageNamed: "floar")
        addChild(floarTexture)
        floarTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height / 1.4)
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
        self.addChild(player)
    }
    
    func walkingPlayer(){
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        let loopAnimation = SKAction.repeatForever(playerAnimation)
        player.run(loopAnimation)
    }
    
    // MARK: - BUTTON
    func createButton(){
        let button = SKSpriteNode(imageNamed: "rightButton")
        button.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 4)
        button.zPosition = 1
        button.name = "rightButton"
        self.addChild(button)
    }
    
    // MARK: - TREE
    var tree: Array<SKSpriteNode> = []
    var flag = false
    
    func createTree(){
        let random = (Int)(arc4random() % 10) + 1
        tree.append(SKSpriteNode(imageNamed: "tree" + String(random)))
        tree[tree.count - 1].size = CGSize(width: self.frame.size.width / 4, height: self.frame.size.height / 2)
        tree[tree.count - 1].position = CGPoint(x: self.frame.size.width + tree[tree.count - 1].size.width / 2, y: self.frame.size.height / 2 + 45)
        tree[tree.count - 1].zPosition = 1
        self.addChild(tree[tree.count - 1])
    }
}
