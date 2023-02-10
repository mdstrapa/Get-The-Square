//
//  CountdownViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 04/02/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit
import AVFoundation

class CountdownViewController: UIViewController {

    
    
    @IBOutlet weak var lblCoutdown: UILabel!
    var timerCountdown = Timer()
    var playerSoundEffect = AVAudioPlayer()
    var seconds:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        seconds = 4
        //starting the timer
        timerCountdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(CountdownViewController.countdown)), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func playSound(){
        do{
            try playerSoundEffect = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Countdown", ofType: "mp3")!))
            playerSoundEffect.play()
        }catch{
            print("Error while trying to play a sound")
            print(error)
        }
    }

    @objc func countdown(){
        if seconds > 1 {
            seconds = seconds - 1
            lblCoutdown.text = String(seconds)
            playSound()
            lblCoutdown.center = CGPoint(x: lblCoutdown.center.x - 500, y: lblCoutdown.center.y)
            UIView.animate(withDuration: 0.2){
                self.lblCoutdown.center = CGPoint(x: self.lblCoutdown.center.x + 500, y: self.lblCoutdown.center.y)
            }
        }else{
            timerCountdown.invalidate()
            performSegue(withIdentifier: "showTheGame", sender: nil)
        }
        
    }

}
