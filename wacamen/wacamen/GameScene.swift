//
//  GameScene.swift
//  wacamen
//
//  Created by 小林彩花 on 2017/11/17.
//  Copyright © 2017年 小林彩花. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    struct Constants{
        static let playerImages = ["standing2","walking","walking2"]
    }
    var player: SKSpriteNode!

    override func didMove(to view: SKView) {
        
        
        self.setunpBackground()
        self.setupPlayer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    //背景画像を読み込む
    func setunpBackground(){
        let backgroundTexture = SKSpriteNode(texture: SKTexture(imageNamed: "background"))
        addChild(backgroundTexture)
        backgroundTexture.size = CGSize(width: self.frame.size.width * 2, height: self.frame.size.height * 2)
    }
    
    func setupPlayer(){
        var playerTexture = [SKTexture]()
        
        for i in Constants.playerImages{
            let texture = SKTexture(imageNamed: i)
            texture.filteringMode = .linear
            playerTexture.append(texture)
        }
        
        let playerAnimation = SKAction.animate(with: playerTexture, timePerFrame: 0.2)
        let loopAnimation = SKAction.repeatForever(playerAnimation)
        
        player = SKSpriteNode(texture: playerTexture[0])
        player.size = CGSize(width: player.size.width / 4, height: player.size.height / 4)
        player.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        player.run(loopAnimation)
        
        self.addChild(player)
    }
    
 
}
