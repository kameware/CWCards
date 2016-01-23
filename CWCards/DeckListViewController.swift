//
//  DeckListViewController.swift
//  CWCards
//
//  Created by mineharu on 2016/01/21.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

import UIKit
import RealmSwift

class DeckListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var deckTableView: UITableView!
    
    var decks:Results<Deck>?{
        do {
            let realm = try! Realm()
            return realm.objects(Deck)
        } catch {
            NSLog("error")
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealController = self.revealViewController()
        revealController.tapGestureRecognizer()
        
        if self.revealViewController() != nil {
            leftMenuButton.target = self.revealViewController()
            leftMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        deckTableView.delegate = self
        deckTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -tableview-
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return decks!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("deckcell")!
        cell.textLabel?.text = decks![indexPath.row].deck_name
        
        return cell
        
    }

}
