//
//  ViewController.swift
//  21
//
//  Created by 張啟裕 on 2017/12/19.
//  Copyright © 2017年 Justin Chang. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

enum PlayingStatus {
    case win
    case lose
    case drew
}

class PlayingVC: UIViewController
{
    var players = [Player]()
    var timer:Timer!
    var makerDidGenerateNumber = 0
    var playerDidGenerateNumber = 0
    var makerLastCardView: CardView?

    @IBOutlet weak var pointTitle: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var playerCardDistrictView: UIView!
    @IBOutlet weak var makerCardDistrictView: UIView!
    @IBOutlet weak var playerPointLabel: UILabel!
    @IBOutlet weak var makerPointLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var surrenderButton: UIButton!
    @IBOutlet weak var hitButton: UIButton!
    @IBOutlet weak var standButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        generateUI()
        generateData()
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    func generateUI()
    {
        generateBorder(withView: surrenderButton)
        generateBorder(withView: hitButton)
        generateBorder(withView: standButton)
        generateBorder(withView: playerCardDistrictView)
        generateBorder(withView: makerCardDistrictView)
        generateBorder(withView: startButton)
        
        startButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
    }
    
    
    func generateData()
    {
        players.append(Player(Maker: true))
        players.append(Player(Maker: false))
    }
    
    
    func generateBorder(withView view: UIView)
    {
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1.5
        view.layer.borderColor = Color.mainColor.cgColor
    }
    
    
    func generateCardView(withPlayer player: Player)
    {
        if player.isMaker
        {
            for i in makerDidGenerateNumber...player.cards.count - 1
            {
                let xPosition = Double(Config.cardViewInterval) * Double(i) + Double(Config.cardViewWidth) * Double(i) + Double(Config.cardViewInterval)
                let frame = CGRect(x: CGFloat(xPosition), y: 20 * Config.variable, width: Config.cardViewWidth, height: Config.cardViewHeight)
                let visual = (i == 0)
                let cardView = CardView(frame: frame, cardInfo: player.cards[i], visual:visual)
                view.addSubview(cardView)
                if visual == true
                {
                    makerLastCardView = cardView
                    cardView.visual = false
                }
            }
            makerDidGenerateNumber = player.cards.count
        }
        else
        {
            for i in playerDidGenerateNumber...player.cards.count - 1
            {
                let xPosition = Double(Config.cardViewInterval) * Double(i) + Double(Config.cardViewWidth) * Double(i) + Double(Config.cardViewInterval)
                let yPosition = Config.screenHeight - 20 * Config.variable - Config.cardViewHeight
                let frame = CGRect(x: CGFloat(xPosition), y: yPosition, width: Config.cardViewWidth, height: Config.cardViewHeight)
                let visual = (i == 0)
                let cardView = CardView(frame: frame, cardInfo: player.cards[i], visual:visual)
                view.addSubview(cardView)
            }
            playerDidGenerateNumber = player.cards.count
        }
    }
    
    
    //開始發牌
    @IBAction func start(_ sender: UIButton)
    {
        if sender.titleLabel?.text == "再來一次"
        {
            statusLabel.text = "決戰21點"
            
            let cardView = view.subviews.filter{$0 is CardView}
            for view in cardView
            {
                view.removeFromSuperview()
            }
        }
        setPlayerOperating(enable: true)

        sender.isHidden = true
        pointTitle.isHidden = false
        surrenderButton.isHidden = false
        surrenderButton.isEnabled = true
        hitButton.isHidden = false
        standButton.isHidden = false
        playerPointLabel.isHidden = false
        makerPointLabel.isHidden = false
        
        
        for player in players
        {
            player.cards.append(deal(.dos))
            generateCardView(withPlayer: player)
            player.cards.append(deal(.face))
            generateCardView(withPlayer: player)
        }
        updateDisplayPoint()
        
        if players[0].allCardAmount == 21
        {
            finished(withStauts: .lose)
        }
        
        if players[1].allCardAmount == 21
        {
            finished(withStauts: .win)
        }
    }
    
    func updateDisplayPoint()
    {
        makerPointLabel.text = "\(players[0].openCardAmount)"
        playerPointLabel.text = "\(players[1].allCardAmount)"
    }
    
    
    //再發一張
    @IBAction func hit(_ sender: UIButton)
    {
        if players[1].cards.count < 5
        {
            players[1].cards.append(deal(.face))
            generateCardView(withPlayer: players[1])
            updateDisplayPoint()
        }
        
        if players[1].isBusting == true
        {
            finished(withStauts: .lose)
            return
        }
        
        if players[1].cards.count == 5
        {
            finished(withStauts: .win)
        }
    }
    
    
    //停止發牌
    @IBAction func stand(_ sender: UIButton)
    {
        setPlayerOperating(enable: false)
        runMaker()
    }
    
    //投降
    @IBAction func surrender(_ sender: UIButton)
    {
        setPlayerOperating(enable: false)
        finished(withStauts: .lose)
    }
    
    func setPlayerOperating(enable:Bool)
    {
        surrenderButton.isEnabled = enable
        hitButton.isEnabled = enable
        standButton.isEnabled = enable
    }
    
    
    func runMaker()
    {
        for _ in 1...3
        {
            if players[0].allCardAmount > 17
            {
                break
            }
            
            players[0].cards.append(deal(.face))
            generateCardView(withPlayer: players[0])
            updateDisplayPoint()
        }
        
        if players[0].isBusting == false
        {
            if players[0].cards.count == 5
            {
                finished(withStauts: .lose)
                return
            }
            settle()
        }
        else
        {
            finished(withStauts: .win)
        }
    }
    

    func settle()
    {
        if players[0].allCardAmount > players[1].allCardAmount
        {
            finished(withStauts: .lose)
        }
        else if players[0].allCardAmount == players[1].allCardAmount
        {
            finished(withStauts: .drew)
        }
        else if players[0].allCardAmount < players[1].allCardAmount
        {
            finished(withStauts: .win)
        }
    }
    

    func deal(_ cardStatus: CardStatus) -> Card
    {
        let aSuit = Int(arc4random_uniform(3))
        let aNumber = Int(arc4random_uniform(12))
        return Card(suit: aSuit + 1, number: aNumber + 1, status: cardStatus)
    }
    
    func finished(withStauts status: PlayingStatus)
    {
        switch status {
        case .win:
            statusLabel.text = "You Win"
            AudioServicesPlayAlertSound(1008)
        case .lose:
            statusLabel.text = "You lose"
            AudioServicesPlayAlertSound(1053)
        case .drew:
            statusLabel.text = "Drew"
        }
        setPlayerOperating(enable: false)

        makerPointLabel.text = "\(players[0].allCardAmount)"
        makerLastCardView?.dosImage.isHidden = true
        startButton.isHidden = false
        startButton.setTitle("再來一次", for: .normal)
        
        //清除資料
        players[0].isBusting = false
        players[1].isBusting = false
        makerDidGenerateNumber = 0
        playerDidGenerateNumber = 0
        for player in players
        {
            player.cards.removeAll()
        }
    }
}

