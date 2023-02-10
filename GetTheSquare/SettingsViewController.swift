//
//  SettingsViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 06/01/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit
import CoreData

struct settings{
    static var playBackgroundMusic:Bool = true
    static var playSoundEffects:Bool = true
    static var backgroundMusicVolume:Float = 0.5
    static var userName:String = "Unknown"
    static var lang:String = "En"
    static var messages=[Messages]()
    static var advancedMode = false
}

struct Messages:Codable{
    var id:Int
    var value:String
}


class SettingsViewController: UIViewController {

    
    @IBOutlet weak var switchPlayBackgroundMusic: UISwitch!
    @IBOutlet weak var sliderBackgroundMusicVolume: UISlider!
    @IBOutlet weak var switchPlaySoundEffects: UISwitch!
    @IBOutlet weak var languageChoice: UISegmentedControl!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblBackgroundMusic: UILabel!
    @IBOutlet weak var lblBackgroundMusicVolume: UILabel!
    @IBOutlet weak var lblSoundEffects: UILabel!
    @IBOutlet weak var lblEraseScoreData: UILabel!
    @IBOutlet weak var btnEraseData: UIButton!
    @IBOutlet weak var navBarSettings: UINavigationBar!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var lblAdvancedMode: UILabel!
    @IBOutlet weak var switchAdvancedMode: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
        setFields()
    }
    
    func setFields(){
        switchPlayBackgroundMusic.isOn = settings.playBackgroundMusic
        switchPlaySoundEffects.isOn = settings.playSoundEffects
        sliderBackgroundMusicVolume.value = settings.backgroundMusicVolume
        switchAdvancedMode.isOn = settings.advancedMode
        languageChoice.setEnabled(true, forSegmentAt: 2)
    }
    
    public func getLanguage()->[Messages]{
        var msg = [Messages]()
        
        let path = Bundle.main.path(forResource: "messages_" + settings.lang, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let data = try! Data(contentsOf:url)
        let decoder = JSONDecoder()
        do{
            msg = try decoder.decode([Messages].self, from: data)
        }catch{
            print("Error during decoder process. The error is \(error)")
        }
        return msg
    
    }
    
    func setLanguage(){
        lblLanguage.text = settings.messages[36].value
        lblBackgroundMusic.text = settings.messages[8].value
        lblBackgroundMusicVolume.text = settings.messages[9].value
        lblSoundEffects.text = settings.messages[10].value
        lblEraseScoreData.text = settings.messages[11].value
        btnEraseData.setTitle(settings.messages[12].value, for: .normal)
        btnDone.title = settings.messages[7].value
        navBarSettings.topItem?.title = settings.messages[6].value
        lblAdvancedMode.text = settings.messages[37].value
    }

    
    @IBAction func showHomeScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showHomeScreen", sender: nil)
    }
    
    
    @IBAction func setPlayBackgroundMusic(_ sender: UISwitch) {
        settings.playBackgroundMusic = sender.isOn
    }
    
    @IBAction func setPlaySoundEffects(_ sender: UISwitch) {
        settings.playSoundEffects = sender.isOn
    }
    
    @IBAction func setBackgroundMusicVolume(_ sender: UISlider) {
        settings.backgroundMusicVolume = sender.value
    }
    
    @IBAction func setAdvancedMode(_ sender: UISwitch) {
        settings.advancedMode = sender.isOn
    }
    
    @IBAction func eraseScoreData(_ sender: UIButton) {
        
        let alert = UIAlertController(title: settings.messages[21].value,message: "\n" + settings.messages[22].value,preferredStyle:UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: settings.messages[23].value, style: UIAlertActionStyle.default,handler:{(action) in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
            
            request.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(request)
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        context.delete(result)
                    }
                    do{
                        try context.save()
                        
                    }catch{
                        print(error)
                    }
                }
            }catch{
                print(error)
            }
            
        }))
        alert.addAction(UIAlertAction(title:settings.messages[24].value,style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    @IBAction func userChangeLanguage(_ sender: UISegmentedControl) {
        settings.lang = languageChoice.titleForSegment(at: languageChoice.selectedSegmentIndex)!
        settings.messages = getLanguage()
        setLanguage()
        
    }
    
    
    

}
