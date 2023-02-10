//
//  HomeScreenViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 06/01/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var lblTypeYoutName: UILabel!
    @IBOutlet weak var btnStartTheGame: UIButton!
    @IBOutlet weak var btnScores: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnRules: UIButton!
    

    
    override func viewWillAppear(_ animated: Bool) {
        let setup = SettingsViewController()
        settings.messages = setup.getLanguage()
        setLanguage();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setLanguage(){
        lblTypeYoutName.text = settings.messages[4].value
        btnStartTheGame.setTitle(settings.messages[0].value, for: .normal)
        btnSettings.setTitle(settings.messages[2].value, for: .normal)
        btnScores.setTitle(settings.messages[1].value, for: .normal)
        btnRules.setTitle(settings.messages[3].value, for: .normal)
        txtUserName.placeholder = settings.messages[5].value
    }
    
    @IBAction func showRules(_ sender: UIButton) {
        performSegue(withIdentifier: "showRules", sender: nil)
    }
    
    
    @IBAction func showSettings(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    
    @IBAction func showScores(_ sender: Any) {
        performSegue(withIdentifier: "showScores", sender: nil)
    }
    
    @IBAction func showTheGame(_ sender: Any) {
        
        settings.userName = txtUserName.text!
        
        performSegue(withIdentifier: "showCountdown", sender: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    

}
