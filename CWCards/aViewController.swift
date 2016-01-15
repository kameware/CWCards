//
//  ViewController.swift
//  CWCards
//
//  Created by mineharu on 2015/11/04.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import UIKit
import SWRevealViewController

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var typeTable: UITableView!
    
    
    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var rightButtonMenu: UIBarButtonItem!
    
    let types: [String] = ["ST01", "ST02", "BT01", "ST03", "BT02"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        typeTable.dataSource = self;
        typeTable.delegate = self;
        
        let revealController = self.revealViewController()
        
        revealController.tapGestureRecognizer()
        
        if self.revealViewController() != nil {
            leftMenuButton.target = self.revealViewController()
            leftMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            rightButtonMenu.target = self.revealViewController()
            rightButtonMenu.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = types[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard:UIStoryboard = UIStoryboard.init(name: "CardListViewController", bundle: NSBundle.mainBundle())
        let cardListViewcontroller:CardListViewController = storyboard.instantiateInitialViewController()! as! CardListViewController
        cardListViewcontroller.typeName = types[indexPath.row]
        self.navigationController?.pushViewController(cardListViewcontroller, animated: true)
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return true
    }
    
    // RightMenu
    // func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
    //    return true
    // }
}

