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
        self.setunpBackground()
        self.setupPlayer()
        createButton()
    }
    
    // MARK: - touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "button" {
                walkingPlayer()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "button" {
                self.player.removeAllActions()
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
    
    }
  
    func setunpBackground(){
        let backgroundTexture = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
        addChild(backgroundTexture)
        backgroundTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height * 2)
    }
    
    // MARK: - PLAYER
    
    struct Constants{
        static let playerImages = ["standing2","walking","walking2"]
    }
    var player: SKSpriteNode!
    var playerTexture = [SKTexture]()
    
    func setupPlayer(){
        for i in Constants.playerImages{
            let texture = SKTexture(imageNamed: i)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        player = SKSpriteNode(texture: playerTexture[0])
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
        button.position = CGPoint(x:self.frame.width/2, y:self.frame.height/4)
        button.zPosition = 1
        button.name = "button"
        self.addChild(button)
    }
}
