//
//  DeckEditViewController.swift
//  CWCards
//
//  Created by mineharu on 2016/01/21.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

import UIKit
import RealmSwift

protocol DeckEditDelegate {
    func selectCard(card:Card)
}

class DeckEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DeckEditDelegate {
    
    
    @IBOutlet weak var deckTableView: UITableView!
    
    var deck_id:Int = 0
    var deck:Deck = Deck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deckTableView.delegate = self
        deckTableView.dataSource = self
        
//        let realm = try! Realm()
        if (0 < deck_id) {
            
        } else {
            
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "戻る",
            style: UIBarButtonItemStyle.Done,
            target: self,
            action: "alertShow")
    }
    
    override func viewWillDisappear(animated: Bool) {
        if (self.navigationController?.viewControllers.indexOf(self) == nil) {
        }
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectCardSegue" {
            let cardListViewController:CardListViewController = segue.destinationViewController as! CardListViewController
            cardListViewController.selectFlg = true
            cardListViewController.deckEditDelegate = self
        }
    }
    
    // MARK: -UITableView-
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deck.cards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DeckEditTableViewCell = tableView.dequeueReusableCellWithIdentifier("deckeditcell", forIndexPath: indexPath) as! DeckEditTableViewCell
        cell.cardNameLabel.text = deck.cards[indexPath.row].card_name
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let row:Int = indexPath.row
            deck.cards.removeAtIndex(row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    //MARK: -DeckEditDelegate-
    func selectCard(card:Card) {
        deck.cards.append(card)
        deckTableView.reloadData()
    }
    
    func alertShow() {
        let alert:UIAlertController = UIAlertController(title: "確認", message: "デッキを保存しましすか？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
        }))
        alert.addAction(UIAlertAction(title: "保存しない", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alert.addAction(UIAlertAction(title: "保存", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in
            self.deck.deck_name = alert.textFields![0].text!
            let realm = try! Realm()
            try! realm.write{
                realm.create(Deck.self, value: self.deck, update: true)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }))
        alert.addTextFieldWithConfigurationHandler { (text:UITextField) -> Void in
            text.placeholder = "デッキ名"
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

}
