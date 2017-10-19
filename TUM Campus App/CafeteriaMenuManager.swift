//
//  CafeteriaMenuManager.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CafeteriaMenuManager {
    
    static var cafeteriaMenus = [DataElement]()
    
    var manager: TumDataManager?

    
    var requiresLogin: Bool {
        return false
    }
    
    required init(mainManager: TumDataManager) {
        manager = mainManager
    }
    
    func fetchData(_ handler: @escaping ([DataElement]) -> ()) {
        if CafeteriaMenuManager.cafeteriaMenus.isEmpty {
            if let uuid = UIDevice.current.identifierForVendor?.uuidString {
                Alamofire.request(getURL(), method: .get, parameters: nil,
                                  headers: ["X-DEVICE-ID": uuid]).responseJSON() { (response) in
                    if let value = response.result.value {
                        let json = JSON(value)
                        if let cafeteriasJsonArray = json["mensa_menu"].array {
                            for item in cafeteriasJsonArray {
                                self.addMenu(item)
                            }
                            if let beilagenJsonArray = json["mensa_beilagen"].array {
                                for item in beilagenJsonArray {
                                    self.addMenu(item)
                                }
                            }
                            handler(CafeteriaMenuManager.cafeteriaMenus)
                        }
                    }
                }
            }
        }
    }
    
    func addMenu(_ item: JSON) {
//        if let cafeteria = item["mensa_id"].string, let date = item["date"].string, let typeShort = item["type_short"].string, let typeLong = item["type_long"].string, var name = item["name"].string, let mensa = self.manager?.getCafeteriaForID(cafeteria) {
//            let id = item["id"].string ?? ""
//            let typeNR = item["type_nr"].string ?? ""
//            let idNumber = Int(id) ?? 0
//            let nr = Int(typeNR) ?? Int.max
//            let dateformatter = DateFormatter()
//            let price = priceList[typeLong]
//                name = parseMensaMenu(name).name
//            let details = parseMensaMenu(name)
//            dateformatter.dateFormat = "yyyy-MM-dd"
//            let dateAsDate = dateformatter.date(from: date) ?? Date()
//            let newMenu = CafeteriaMenu(id: idNumber, date: dateAsDate, typeShort: typeShort, typeLong: typeLong, typeNr: nr, name: name, price: price, details: details)
//            mensa.addMenu(newMenu)
//            CafeteriaMenuManager.cafeteriaMenus.append(newMenu)
//        }
    }
    
    
    func getURL() -> String {
        return "http://lu32kap.typo3.lrz.de/mensaapp/exportDB.php?mensa_id=all"
    }
    
}

struct Price {
    
    var student: Double
    var employee: Double
    var guest: Double
}

struct MenuDetail {
    
    var name: String
    var nameWithoutAnnotations: String
    var nameWithEmojiWithoutAnnotations: String
    var annotations: [String]
    var annotationDescriptions: [String]
}
