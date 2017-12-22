//
//  CardView.swift
//  21
//
//  Created by 張啟裕 on 2017/12/20.
//  Copyright © 2017年 Justin Chang. All rights reserved.
//

import UIKit
import QuartzCore

class CardView: UIView
{
    var faceLabel = UILabel()
    var dosImage = UIImageView(image: #imageLiteral(resourceName: "poker_dos"))
    var cardInfo:Card
    var visual: Bool
    
    init(frame: CGRect, cardInfo: Card, visual: Bool)
    {
        self.visual = visual
        self.cardInfo = cardInfo
        super.init(frame: frame)
        generateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateUI()
    {
        self.backgroundColor = .white

        faceLabel.frame = self.bounds
        faceLabel.textAlignment = .center
        faceLabel.text = cardInfo.description
        faceLabel.font = UIFont.systemFont(ofSize: 25)
        faceLabel.adjustsFontSizeToFitWidth = true
        if cardInfo.suit == 2 || cardInfo.suit == 3
        {
            faceLabel.textColor = .red
        }
        addSubview(faceLabel)
        
        dosImage.frame = self.bounds
        updateCardStatus()
        addSubview(dosImage)
        
        let longPress = UILongPressGestureRecognizer(target:self,action:#selector(seeLastCard(_:)))
        longPress.minimumPressDuration = 0
        self.addGestureRecognizer(longPress)
    }

    
    @objc func seeLastCard(_ sender: UILongPressGestureRecognizer)
    {
        if visual
        {
            if sender.state == .began
            {
                dosImage.isHidden = true
            }
            if sender.state == .ended
            {
                dosImage.isHidden = false
            }
        }
    }
    
    private func updateCardStatus()
    {
        if cardInfo.status == .face
        {
            dosImage.isHidden = true
        }
        else
        {
            dosImage.isHidden = false
        }
    }
}
