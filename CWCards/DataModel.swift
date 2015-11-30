//
//  DataModel.swift
//  CWCards
//
//  Created by nakamura on 2015/11/16.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import Foundation
import RealmSwift

class Card: Object {
    dynamic var card_number = ""
    dynamic var card_name = ""
    dynamic var color_restraint_1 = ""
    dynamic var color_restraint_2 = ""
    dynamic var cost = ""
    dynamic var ability_1 = ""
    dynamic var ability_2 = ""
    dynamic var atk = ""
    dynamic var def = ""
    dynamic var element = ""
    dynamic var size = ""
    dynamic var color = ""
    dynamic var rarity = ""
    dynamic var illustrator = ""
    dynamic var recording = ""
    
    override static func primaryKey() -> String? {
        return "card_number"
    }
}