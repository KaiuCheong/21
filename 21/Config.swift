//
//  Config.swift
//  21
//
//  Created by 張啟裕 on 2017/12/20.
//  Copyright © 2017年 Justin Chang. All rights reserved.
//

import UIKit
import Foundation

struct Config
{
    //裝置
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let variable = screenWidth / 375

    //紙牌
    static let cardViewWidth = screenWidth / 8
    static let cardViewHeight = cardViewWidth * 8.8 / 6.3
    static let cardViewInterval = (screenWidth - cardViewWidth * 5) / 6
}


struct Color
{
    static let mainColor = UIColor(red: 1, green: 1, blue: 0, alpha: 1)
}
