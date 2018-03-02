//
//  StartScene.swift
//  wacamen
//
//  Created by 小林彩花 on 2018/03/03.
//  Copyright © 2018年 小林彩花. All rights reserved.
//

import SpriteKit

class StartScene: SKScene{
    
    override func didMove(to view: SKView) {
        createButton()
        createLabel()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "start" {
                toGameScene()
            }
        }
    }
    
    func createButton(){
        let button = SKSpriteNode(imageNamed: "standing")
        button.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 4)
        button.zPosition = 0
        button.name = "start"
        self.addChild(button)
    }
    
    func createLabel(){
        let label = SKLabelNode()
        label.text = "Start"
        label.position = CGPoint(x:frame.size.width/2,y:frame.size.height/5)
        label.name = "start"
        label.zPosition = 1
        self.addChild(label)
    }
    
    func toGameScene(){
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view!.presentScene(scene)
    }
}
