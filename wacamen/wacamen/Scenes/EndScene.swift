//
//  EndScene.swift
//  wacamen
//
//  Created by 小林彩花 on 2018/03/03.
//  Copyright © 2018年 小林彩花. All rights reserved.
//

import SpriteKit

class EndScene: SKScene{
    
    override func didMove(to view: SKView) {
        createRetryLabel()
        createGoBackStartSceneLabel()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first as UITouch? {
            let location = touch.location(in: self)
            if self.atPoint(location).name == "retry" {
                toGameScene()
            }
            if self.atPoint(location).name == "goBackStart" {
                toStartScene()
            }
        }
    }
    
    func createRetryLabel(){
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Retry!"
        label.color = UIColor.lightGray
        label.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 5 * 3)
        label.name = "retry"
        self.addChild(label)
    }
    
    func createGoBackStartSceneLabel(){
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "GoBackStart"
        label.color = UIColor.lightGray
        label.position = CGPoint(x:self.frame.width / 2, y:self.frame.height / 5 * 2)
        label.name = "goBackStart"
        self.addChild(label)
    }
    
    func toGameScene(){
        let scene = GameScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view!.presentScene(scene)
    }
    
    func toStartScene(){
        let scene = StartScene(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.view!.presentScene(scene)
    }
}
