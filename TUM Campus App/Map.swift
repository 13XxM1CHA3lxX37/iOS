//
//  Map.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/11/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
import Sweeft

final class Map: ImageDownloader, DataElement {
    let roomID: String
    let mapID: String
    let description: String
    let scale: Int
    
    init(roomID: String, mapID: String, description: String, scale: Int, api: TUMCabeAPI) {
        self.roomID = roomID
        self.mapID = mapID
        self.description = description
        self.scale = scale
        super.init()
        
        // TODO:
        
        let url = api.url(for: TUMCabeEndpoint.mapImage, arguments: ["room": roomID, "id": mapID])
        getImage(url.absoluteString)
    }
    
    convenience init?(roomID: String, api: TUMCabeAPI, from json: JSON) {
        guard let description = json["description"].string,
            let id = json["map_id"].int,
            let scale = json["scale"].int else {
                return nil
        }
        self.init(roomID: roomID,
                  mapID: id.description,
                  description: description,
                  scale: scale,
                  api: api)
    }
    
    func getCellIdentifier() -> String {
        return "map"
    }
    
    var text: String {
        return description
    }
    
}
