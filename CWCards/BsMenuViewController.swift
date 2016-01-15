//
//  LeftMenuViewController.swift
//  CWCards
//
//  Created by nakamura on 2015/12/26.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import UIKit
import SWRevealViewController

class BsMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var typeTable: UITableView!
    
    
    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var rightButtonMenu: UIBarButtonItem!
    
    let types: [String] = ["BT01-", "BT02-", "ST01-", "ST02-", "ST03-", "PR-U", "PR-P", "PR-T"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        typeTable.dataSource = self;
        typeTable.delegate = self;
        
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
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(types[indexPath.row], forKey: DeviceConst().UD_TYPENAME)
        
//        let navigationController = UINavigationControlΩler(rootViewController: cardListViewcontroller)
        
        self.dismissViewControllerAnimated(true, completion: nil)
//        let revealController = self.revealViewController()
//        revealController.pushFrontViewController(navigationController, animated: true)
    }
}
