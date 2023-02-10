//
//  ViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 05/01/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class ViewController: UIViewController {

    
    var playerSoundEffects = AVAudioPlayer()
    var playerChangeLevel = AVAudioPlayer()
    var playerBackgroundMusic = AVAudioPlayer()
    
    
    @IBOutlet weak var lblLevelTitle: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblScoreTitle: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblQtd: UILabel!
    @IBOutlet weak var lblLevel: UILabel!
    @IBOutlet weak var btnSquare: UIButton!
    @IBOutlet weak var lblLevelNumber: UILabel!
    @IBOutlet weak var imgTimeLeft: UIImageView!
    
    
    var score = 0
    var level = 1
    var value = 5
    var qtd = 0
    var previousQtd = 0
    var timer = Timer()
    var timerInterval = 3.0
    var playerIsAlive = true
    var notSquare = false
    
    let chageLevelMessages: [String] = ["amazing","iCantBelieveIt","ohMyGod","youDid"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        initGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setLanguage(){
        lblLevelTitle.text = settings.messages[13].value
        lblTotalTitle.text = settings.messages[14].value
        lblScoreTitle.text = settings.messages[15].value
        
    }
    
    
    func playSoundEffect(){
        if settings.playSoundEffects{
            let tapNumber = Int(arc4random_uniform(5)) + 1
            do{
                try playerSoundEffects = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "tap" + String(tapNumber), ofType: "mp3")!))
                playerSoundEffects.play()
            }catch{
                print("Error while trying to play a sound")
                print(error)
            }
        }
    }
    
    
    func changeLevel(){
        
        
        
        
        if settings.playSoundEffects {
            let messageNumber = Int(arc4random_uniform(4))
            do{
                try playerChangeLevel = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: chageLevelMessages[messageNumber], ofType: "mp3")!))
                playerChangeLevel.play()
            }catch{
                print("Error while trying to play a sound")
                print(error)
            }
        }
        
        level += 1
        value += 5
        
        lblLevelNumber.text = "Level \(level)"
        lblLevelNumber.alpha = 1
        UIView.animate(withDuration: 3, animations:{
            self.lblLevelNumber.alpha = 0
        })
        
        
        if level == 2 {timerInterval = 2}
        else if level == 3 {timerInterval = 1.5}
        else if level == 4 {timerInterval = 1}
        else if level == 5 {timerInterval = 0.7}
        else if level == 6 {timerInterval = 0.4}
        else if level == 7 {timerInterval = 0.2}
        else {timerInterval = 0.1}
    }
    
    
    @IBAction func tapSquare(_ sender: UIButton) {
        
        if timer.isValid {timer.invalidate()}
        
        if !notSquare{
            playSoundEffect()
            
            imgTimeLeft.alpha = 0
            UIView.animate(withDuration: timerInterval, animations:{
                self.imgTimeLeft.alpha = 1
            })
            
            
            //if advanced mode is active, we must change the image sometimes
            if settings.advancedMode{
                let changeFormat = Int(arc4random_uniform(10))
                if changeFormat == 1{
                    sender.setImage(UIImage(named:"theBall.png"), for: .normal)
                    notSquare = true
                }else if changeFormat == 2{
                    sender.setImage(UIImage(named:"theTriangle.png"), for: .normal)
                    notSquare = true
                }else{
                    sender.setImage(UIImage(named:"theSquare.png"), for: .normal)
                    notSquare = false
                }
            }
            
            
            sender.alpha = 1
            let xPos = Int(arc4random_uniform(219))
            let yPos = 20 + Int(arc4random_uniform(467))
            let myPoint = CGPoint(x: xPos, y: yPos)
            
            sender.frame.origin = myPoint
            
            score = score + value;
            qtd += 1
            previousQtd = qtd
            
            lblScore.text = String(score)
            lblQtd.text = String(qtd)
            lblLevel.text = String(level)
            
            if qtd%20==0{
                changeLevel()
            }
            
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: (#selector(ViewController.checkTime)), userInfo: nil, repeats: true)
            
            if settings.playBackgroundMusic{
                if !playerBackgroundMusic.isPlaying {
                    playBackgroundMusic();
                }
            }
            
        }else{
            //here executes code when the play tap the non-square symbol
            //in this case, the game ends right now
            
            if settings.playBackgroundMusic {
                if playerBackgroundMusic.isPlaying {
                    playerBackgroundMusic.stop()
                }
            }
            
            
            if settings.playSoundEffects{
                do{
                    try playerSoundEffects = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "scream", ofType: "mp3")!))
                    playerSoundEffects.play()
                }catch{
                    print("Error while trying to play a sound")
                    print(error)
                }
            }
            
            
            let alert = UIAlertController(title: "OMG", message: "You Can't tap this symbol!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Sorry",style: UIAlertActionStyle.default,handler:{(action) in
                self.gameOver()
            }))
            self.present(alert, animated: true,completion: nil)
            
            
        }
        
    }
    
    func playBackgroundMusic(){
        
        
        if settings.playBackgroundMusic {
            do{
                try playerBackgroundMusic = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "GetTheSquareBackgroundMusic", ofType: "mp3")!))
                playerBackgroundMusic.volume = settings.backgroundMusicVolume
                playerBackgroundMusic.play()
            }catch{
                print("Error while trying to play a sound")
                print(error)
            }
        }
        
        
    }
    
    func initGame(){
        score = 0
        level = 1
        value = 5
        qtd = 0
        previousQtd = 0
        timerInterval = 3.0
        
        lblScore.text = String(score)
        lblQtd.text = String(qtd)
        lblLevel.text = String(level)
        
        let xPos = 115
        let yPos = 134
        let myPoint = CGPoint(x: xPos, y: yPos)
        btnSquare.frame.origin = myPoint
        btnSquare.isHidden = false
   
        
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: (#selector(ViewController.checkTime)), userInfo: nil, repeats: true)
        
        
        imgTimeLeft.alpha = 0
        UIView.animate(withDuration: timerInterval, animations:{
            self.imgTimeLeft.alpha = 1
        })
        
        playBackgroundMusic()
    
    };
    
    func gameOver(){
        
        let newRecord = false
        
        saveScore()
        
        let messages = defineFinalMessages()
        
        let additionalMessage = messages[0]
        let actionTitle = messages[1]
        let messageTitle = settings.messages[34].value + ", " + settings.userName + "!"
        let result = "\n" + settings.messages[35].value + " \(score).\n\n" + additionalMessage
        
        
        timer.invalidate()
        if settings.playBackgroundMusic {
            if playerBackgroundMusic.isPlaying {
                playerBackgroundMusic.stop()
            }
        }
        
        
        if settings.playSoundEffects{
            do{
                try playerSoundEffects = AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "explosion", ofType: "mp3")!))
                playerSoundEffects.play()
            }catch{
                print("Error while trying to play a sound")
                print(error)
            }
        }
        
        
        let alert = UIAlertController(title: messageTitle, message: result, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle,style: UIAlertActionStyle.default,handler:{(action) in
            if !newRecord { self.performSegue(withIdentifier: "showHomeScreen", sender: nil)}
        }))
        self.present(alert, animated: true,completion: nil)
    }
    
    
    func saveScore(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newScore = NSEntityDescription.insertNewObject(forEntityName: "Scores", into: context)
        
        newScore.setValue(settings.userName, forKey: "name")
        newScore.setValue(score, forKey: "score")
        
        do{
            try context.save()
            print("Saved into the database!")
        }catch{
            print("There was an error")
            print(error)
        }
        
    }
    
    
    
    func defineFinalMessages() -> [String]{
        var additionalMessage = ""
        var actionTitle = ""
        
        //depengding on the score value, we are going to set a different message and action title.
        if score < 100{
            additionalMessage = settings.messages[25].value   //"A monkey can do better than what you did."
            actionTitle = settings.messages[30].value //"I promisse I will do better next time."
        }else if score < 500 {
            additionalMessage = settings.messages[26].value  //"Not bad. But also not good at all!"
            actionTitle = settings.messages[31].value //"Sorry!"
        }else if score < 1000 {
            additionalMessage = settings.messages[27].value //"Great score. Contrats."
            actionTitle = settings.messages[32].value //"Thanks!"
        }else if score < 1300 {
            additionalMessage = settings.messages[28].value //"YOU are sick!! Congrats!!"
            actionTitle = settings.messages[32].value //"Thanks!"
        }else if score < 2000 {
            additionalMessage = settings.messages[29].value //"ARE YOU SOME KIND OF GOD??"
            actionTitle = settings.messages[33].value // "Yes!"
        }
        
        var result = [String]()
        result.append(additionalMessage)
        result.append(actionTitle)
        
        return result
        
    }
    
    @objc func checkTime(){
        print("The qtd is \(qtd) and the previous qts is \(previousQtd)" )
    
        
        
        
        if !notSquare {
            
            if previousQtd == qtd {

                gameOver()
                
            }else{
                previousQtd = qtd
            }
        
        }else{
            //here execute code when a non-square was not tapped

            notSquare = false
            
            tapSquare(btnSquare)
            
        }
    }

}

