//
//  DeckListViewController.swift
//  CWCards
//
//  Created by mineharu on 2016/01/21.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

import UIKit

class DeckListViewController: UIViewController {

    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealController = self.revealViewController()
        revealController.tapGestureRecognizer()
        
        if self.revealViewController() != nil {
            leftMenuButton.target = self.revealViewController()
            leftMenuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
