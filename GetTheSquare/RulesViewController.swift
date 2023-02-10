//
//  RulesViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 06/01/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {

    @IBOutlet weak var navBarRules: UINavigationBar!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtRules: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLanguage(){
        btnDone.title = settings.messages[17].value
        navBarRules.topItem?.title = settings.messages[19].value
        txtRules.text = settings.messages[20].value
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func showHomeScreen(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showHomeScreen", sender: nil)
    }
    
    

}
