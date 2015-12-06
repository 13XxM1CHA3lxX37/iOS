//
//  AccessTokenReceiver.swift
//  TUM Campus App
//
//  Created by Mathias Quintero on 12/6/15.
//  Copyright © 2015 LS1 TUM. All rights reserved.
//

import Foundation
protocol AccessTokenReceiver {
    func receiveToken(token: String)
}