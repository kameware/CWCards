//
//  CardListViewController.swift
//  CWCards
//
//  Created by mineharu on 2015/11/04.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class CardListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var cardTableView: UICollectionView!
    
//    @IBOutlet weak var leftMenuButton: UIBarButtonItem!
    @IBOutlet weak var rightMenuButton: UIBarButtonItem!
    
    var typeName:String = ""
    var selectFlg:Bool = false
    var deckEditDelegate:DeckEditDelegate!
    var cardData:Card!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let ud = NSUserDefaults.standardUserDefaults()
        typeName = ud.objectForKey(DeviceConst().UD_TYPENAME) as! String
        
        cardTableView.delegate = self;
        cardTableView.dataSource = self;
        
        let revealController = self.revealViewController()
        
        revealController.tapGestureRecognizer()
        self.navigationController?.navigationBarHidden = false
        
        if self.revealViewController() != nil {
            // 左メニュー呼び出しボタン
            if !selectFlg {
                let leftMenuButton:UIBarButtonItem = UIBarButtonItem(title: "三", style: UIBarButtonItemStyle.Done, target: self.revealViewController(), action: "revealToggle:")
                self.navigationItem.leftBarButtonItem = leftMenuButton
            } else {
                // 決定ボタン追加処理
                let selectButton:UIBarButtonItem = UIBarButtonItem(title: "決", style: UIBarButtonItemStyle.Done, target: self, action: "selectCard")
                let rightButtons = NSMutableArray(array: self.navigationItem.rightBarButtonItems!)
                rightButtons.addObject(selectButton)
                self.navigationItem.rightBarButtonItems = rightButtons as AnyObject as? [UIBarButtonItem]
            }
            rightMenuButton.target = self.revealViewController()
            rightMenuButton.action = "rightRevealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationItem.title = typeName
        cardTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -UICollectionViewDelegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("CardCell", forIndexPath: indexPath) as! CardCollectionViewCell;
        
        // DBに登録されているか確認
        let realm = try! Realm()
        let no = NSString(format: "%@%03ld", typeName, indexPath.row + 1)
        let predicate = NSPredicate(format: "card_number = %@", no)
        cardData = realm.objects(Card).filter(predicate).first
        
        let prFlg = typeName.hasPrefix("PR")
        var imgUrlBase = "https://www.gundam-cw.com/img/card/%@%03ld.png"
        if (prFlg) {
            imgUrlBase = "https://www.gundam-cw.com/img/card/pr/%@%03ld.png"
        }
        
        if ((cardData) == nil) {
            // なければWEBから取得
            
            // 情報取得
            let urlPath = "https://www.gundam-cw.com/mng/search_ajax.php"
            
            let parameters = [
                "number": NSString(format: "%@%03ld", typeName, indexPath.row + 1),
                "card_type": prFlg ? "3" : "1"
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
                                self.cardData = realm.objects(Card).filter(predicate).first
                                var cardColor:UIColor = UIColor.whiteColor();
                                switch (self.cardData?.color)! {
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
                                cell.cardNoLabel.text = NSString(format: "No.:%@", (self.cardData?.card_number)!) as String
                                cell.cardNameLabel.text = NSString(format: "カード名:%@", (self.cardData?.card_name)!) as String
                                let attrText = NSMutableAttributedString(string: NSString(format: "コスト: %@:%@ 無色:%@", (self.cardData?.color_restraint_1)!, (self.cardData?.color_restraint_2)!, (self.cardData?.cost)!) as String)
//                                attrText.addAttribute(NSForegroundColorAttributeName, value: cardColor, range: NSMakeRange(4, 4))
//                                attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(9, 4))
                                cell.costLabel.attributedText = attrText
                                cell.abilyty1Label.text = NSString(format: "能力１:%@", (self.cardData?.ability_1)!) as String
                                cell.ability2Label.text = NSString(format: "能力２:%@", (self.cardData?.ability_2)!) as String
                                cell.atkLabel.text = NSString(format: "ATK:%@", (self.cardData?.atk)!) as String
                                cell.defLabel.text = NSString(format: "DEF:%@", (self.cardData?.def)!) as String
                                cell.elementLabel.text = NSString(format: "特徴:%@", (self.cardData?.element)!) as String
                                cell.sizeLabel.text = NSString(format: "サイズ:%@", (self.cardData?.size)!) as String
                                cell.colorLabel.text = NSString(format: "色:%@", (self.cardData?.color)!) as String
                                cell.rarityLabel.text = NSString(format: "レアリティ:%@", (self.cardData?.rarity)!) as String
                                cell.illustratorLabel.text = NSString(format: "イラストレーター:%@", (self.cardData?.illustrator)!) as String
                                cell.recordingLabel.text = NSString(format: "収録:%@", (self.cardData?.recording)!) as String
                                cell.cardImageView.sd_setImageWithURL(NSURL(string: NSString(format: imgUrlBase, self.typeName, indexPath.row + 1) as String))
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
            cell.cardNoLabel.text = NSString(format: "No.:%@", (cardData?.card_number)!) as String
            cell.cardNameLabel.text = NSString(format: "カード名:%@", (cardData?.card_name)!) as String
            let attrText = NSMutableAttributedString(string: NSString(format: "コスト: %@:%@ 無色:%@", (cardData?.color_restraint_1)!, (cardData?.color_restraint_2)!, (cardData?.cost)!) as String)
//            attrText.addAttribute(NSForegroundColorAttributeName, value: cardColor, range: NSMakeRange(4, 4))
//            attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(9, 4))
            cell.costLabel.attributedText = attrText
            cell.abilyty1Label.text = NSString(format: "能力１:%@", (cardData?.ability_1)!) as String
            cell.ability2Label.text = NSString(format: "能力２:%@", (cardData?.ability_2)!) as String
            cell.atkLabel.text = NSString(format: "ATK:%@", (cardData?.atk)!) as String
            cell.defLabel.text = NSString(format: "DEF:%@", (cardData?.def)!) as String
            cell.elementLabel.text = NSString(format: "特徴:%@", (cardData?.element)!) as String
            cell.sizeLabel.text = NSString(format: "サイズ:%@", (cardData?.size)!) as String
            cell.colorLabel.text = NSString(format: "色:%@", (cardData?.color)!) as String
            cell.rarityLabel.text = NSString(format: "レアリティ:%@", (cardData?.rarity)!) as String
            cell.illustratorLabel.text = NSString(format: "イラストレーター:%@", (cardData?.illustrator)!) as String
            cell.recordingLabel.text = NSString(format: "収録:%@", (cardData?.recording)!) as String
            cell.cardImageView.sd_setImageWithURL(NSURL(string: NSString(format: imgUrlBase, self.typeName, indexPath.row + 1) as String))
        }
        
        cell.abilyty1Label.adjustsFontSizeToFitWidth = true
        cell.ability2Label.adjustsFontSizeToFitWidth = true
        cell.illustratorLabel.adjustsFontSizeToFitWidth = true
        cell.recordingLabel.adjustsFontSizeToFitWidth = true
        
        return cell;
    }
    
    // MARK: -SlideNavigationControllerDelegate
    func slideNavigationControllerShouldDisplayRightMenu() -> Bool {
        return true
    }
    
    // MARK: -self method-
    func selectCard() {
        deckEditDelegate.selectCard(cardData)
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func bsChangeBtn(sender: AnyObject) {
        NSLog("aaa")
    }
    
    

}
