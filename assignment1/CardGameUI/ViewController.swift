//
//  ViewController.swift
//  CardGameUI
//
//  Created by Ashish Ashish on 10/7/20.
//  Modified by Yali Sun on 10/8/20.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var player1Img1: UIImageView!
    
    @IBOutlet weak var player1Img2: UIImageView!
    
    @IBOutlet weak var player1Img3: UIImageView!
    
    @IBOutlet weak var player2Img1: UIImageView!
    
    @IBOutlet weak var player2Img2: UIImageView!
    
    @IBOutlet weak var player2Img3: UIImageView!
    
    let cardNums = [
        0: "A",
        1: "2",
        2: "3",
        3: "4",
        4: "5",
        5: "6",
        6: "7",
        7: "8",
        8: "9",
        9: "10",
        10: "J",
        11: "Q",
        12: "K"
    ]
    
    let cardColors = [
        0: "S",
        1: "H",
        2: "C",
        3: "D"
    ]
    
    @IBOutlet weak var lblWinner: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func convertCardName(card: Int) -> String {
        let cardNum = card / 4
        let cardColor = card % 4
        return cardNums[cardNum]! + cardColors[cardColor]!
    }
    
    func deal() -> Int {
        var set:Set = Set<Int>()
        var arr = [Int]()
        while (set.count < 6) {
            let card = Int.random(in: 0 ..< 51)
            if (set.contains(card)) {
                continue
            }
            set.insert(card)
            arr.append(card)
        }
        
        player1Img1.image = UIImage(named: convertCardName(card: arr[0]))
        player1Img2.image = UIImage(named: convertCardName(card: arr[1]))
        player1Img3.image = UIImage(named: convertCardName(card: arr[2]))
        player2Img1.image = UIImage(named: convertCardName(card: arr[3]))
        player2Img2.image = UIImage(named: convertCardName(card: arr[4]))
        player2Img3.image = UIImage(named: convertCardName(card: arr[5]))
        
        if (arr[0] == 0 || arr[1] == 0 || arr[2] == 0) {
            return -1
        } else if (arr[3] == 0 || arr[4] == 0 || arr[5] == 0) {
            return 1
        }
        return 0
    }

    @IBAction func playGame(_ sender: Any) {
        let winner = deal()
        if (winner == 0) {
            lblWinner.text = "No Winner"
            return
        }
        
        if (winner < 0) {
            lblWinner.text = "Winner is Player 1"
        } else if (winner > 0) {
            lblWinner.text = "Winner is Player 2"
        }
        let alert = UIAlertController(title: "Play Again", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: playGame))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

}

