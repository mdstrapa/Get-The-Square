//
//  ScoresViewController.swift
//  GetTheSquare
//
//  Created by Marcos Strapazon on 06/01/18.
//  Copyright © 2018 Marcos Strapazon. All rights reserved.
//

import UIKit
import CoreData

class ScoresViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var navBarScores: UINavigationBar!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    
    var controller: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLanguage()
    }
    
    func setLanguage(){
        navBarScores.topItem?.title = settings.messages[16].value
        btnDone.title = settings.messages[17].value
    }
    

    func getData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
    
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Scores")
        // Configure the request's entity, and optionally its predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
        controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.controller?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let object = self.controller?.object(at: indexPath) as! Scores
        
        
        cell.lblPlayer.text = settings.messages[18].value
        cell.lblName.text = object.name!
        cell.lblScore.text = String(object.score)
        
        //cell.textLabel?.text = "Name: " +  + " - Socore: " +
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func showHomeScreen(_ sender: Any) {
        performSegue(withIdentifier: "showHomeScreen", sender: nil)
    }
}
