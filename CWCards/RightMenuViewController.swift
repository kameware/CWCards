//
//  RightMenuViewController.swift
//  CWCards
//
//  Created by nakamura on 2015/12/21.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cardTableView: UITableView!
    
    var typeName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardTableView.dataSource = self
        cardTableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let ud = NSUserDefaults.standardUserDefaults()
        typeName = ud.objectForKey(DeviceConst().UD_TYPENAME) as! String
        cardTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate -
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var result = 0
        if (typeName == "BT01-") {
            result = 159
        } else if (typeName == "BT02-") {
            result = 160
        } else if (typeName == "ST03-") {
            result = 13
        } else if (typeName == "PR-U") {
            result = 5
        } else if (typeName == "PR-P") {
            result = 1
        } else if (typeName == "PR-T") {
            result = 1
        } else {
            result = 13
        }
        return result;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "RightMenuCell")
        
        // DBに登録されているか確認
        let realm = try! Realm()
        let no = NSString(format: "%@%03ld", typeName, indexPath.row + 1)
        let predicate = NSPredicate(format: "card_number = %@", no)
        let cardData = realm.objects(Card).filter(predicate).first
        
        if ((cardData) == nil) {
            // なければWEBから取得
            
            // 情報取得
            let urlPath = "https://www.gundam-cw.com/mng/search_ajax.php"
            
            let parameters = [
                "number": NSString(format: "%@%03ld", typeName, indexPath.row + 1),
                "card_type": typeName.hasPrefix("PR") ? "3" : "1"
            ]
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.80 Safari/537.36",
                "Cookie": "PHPSESSID=o5da2lbp5fjspunj87sr954pi1; _ga=GA1.2.1523371473.1447127031",
                "Origin": "chrome-extension://hgmloofddffdnphfgcellkdfbfbjeloo",
                "Accept-Encoding": "gzip, deflate",
                "Accept-Language": "ja,en-US;q=0.8,en;q=0.6"
            ]
            
            Alamofire.request(.POST, urlPath, parameters: parameters, headers: headers)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        if let JSON = response.result.value {
                            if 0 < JSON.count {
                                let cardInfo:NSDictionary = JSON[0] as! NSDictionary;
                                try! realm.write{
                                    realm.create(Card.self, value: cardInfo, update: true)
                                }
                                let cardData = realm.objects(Card).filter(predicate).first
                                var cardColor:UIColor = UIColor.whiteColor();
                                switch (cardData?.color)! {
                                case "青":
                                    cardColor = UIColor.blueColor()
                                    break
                                case "緑":
                                    cardColor = UIColor.greenColor()
                                    break
                                case "黄":
                                    cardColor = UIColor.orangeColor()
                                    break
                                case "黒":
                                    cardColor = UIColor.blackColor()
                                    break
                                case "赤":
                                    cardColor = UIColor.redColor()
                                    break
                                default:
                                    break
                                }
                                cell.textLabel!.text = NSString(format: "%@", (cardData?.card_name)!) as String
                                cell.backgroundColor = cardColor.colorWithAlphaComponent(0.3)
                            }
                        }
                    case .Failure(let error):
                        NSLog("%@", error)
                    }
            }
        } else {
            var cardColor:UIColor = UIColor.whiteColor();
            switch (cardData?.color)! {
            case "青":
                cardColor = UIColor.blueColor()
                break
            case "緑":
                cardColor = UIColor.greenColor()
                break
            case "黄":
                cardColor = UIColor.orangeColor()
                break
            case "黒":
                cardColor = UIColor.blackColor()
                break
            case "赤":
                cardColor = UIColor.redColor()
                break
            default:
                break
            }
            cell.textLabel!.text = NSString(format: "%@", (cardData?.card_name)!) as String
            cell.backgroundColor = cardColor.colorWithAlphaComponent(0.3)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("%ld", indexPath.row)
        
        let revealController = self.revealViewController()
        let navigation = revealController.frontViewController as! UINavigationController
        let viewControllers = navigation.viewControllers;
        let cardListViewController = viewControllers.last as! CardListViewController
        cardListViewController.cardTableView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Right, animated: true)
        revealController.rightRevealToggleAnimated(true)
    }

}
