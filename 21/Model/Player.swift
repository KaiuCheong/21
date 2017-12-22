//
//  Player.swift
//  21
//
//  Created by 張啟裕 on 2017/12/20.
//  Copyright © 2017年 Justin Chang. All rights reserved.
//

import Foundation
import AudioToolbox

//MARK:Player Object
protocol PlayerDelegate
{
    func handleBusting(player:Player)
}

class Player
{
    var isMaker: Bool
    var isBusting: Bool = false
    var delegate: PlayerDelegate?
    var cards = [Card]()
    {
        didSet {
            print(countingAllCardPoint())
        }
    }
    var openCardAmount: Int
    {
        return countingOpenCardPoint()
    }
    
    var allCardAmount: Int
    {
        return countingAllCardPoint()
    }
    
    //計算點數（全部的牌）
    private func countingAllCardPoint() -> Int
    {
        var result = 0
        var aceArray = [Card]()
        
        for card in cards
        {
            if card.point == 11
            {
                aceArray.append(card)
            }
            result += card.point
        }
        
        
        if result > 21 && aceArray.count != 0
        {
            for _ in 1...aceArray.count
            {
                result = result - 10
                if !(result > 21)
                {
                    return result
                }
            }
        }
        
        if result > 21
        {
            isBusting = true
        }
        
        return result
    }
    
    //計算點數（只計算打開的牌）
    private func countingOpenCardPoint() -> Int
    {
        var result = 0
        var aceArray = [Card]()
        
        for card in cards
        {
            if card.status == .face
            {
                if card.point == 11
                {
                    aceArray.append(card)
                }
                result += card.point
            }
        }
        return result
    }
    
    init (Maker: Bool)
    {
        isMaker = Maker
    }
}




//MARK:Cars Object
enum CardStatus
{
    case face
    case dos
}

class Card
{
    var suit:Int
    var number:Int
    var status:CardStatus
    var description: String
        
    {
        var result = ""
        switch suit
        {
        case 1:
            result = "♠︎"
        case 2:
            result = "♥︎"
        case 3:
            result = "♦︎"
        case 4:
            result = "♣︎"
        default:
            break
        }
        
        switch number {
        case 1:
            result = result + "A"
        case 11:
            result = result + "J"
        case 12:
            result = result + "Q"
        case 13:
            result = result + "K"
        default:
            result = "\(result)\(number)"
        }
        return result
    }
    
    var point:Int
    {
        switch number
        {
        case 11,12,13:
            return 10
        case 1:
            return 11
        default:
            return number
        }
    }
    
    init (suit: Int, number:Int, status:CardStatus)
    {
        self.suit = suit
        self.number = number
        self.status = status
    }
}
