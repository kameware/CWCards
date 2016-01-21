//
//  DeckEditViewController.swift
//  CWCards
//
//  Created by mineharu on 2016/01/21.
//  Copyright © 2016年 Mineharu. All rights reserved.
//

import UIKit

class DeckEditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectCardSegue" {
            let cardListViewController:CardListViewController = segue.destinationViewController as! CardListViewController
            cardListViewController.selectFlg = true
            
        }
        
    }

}
