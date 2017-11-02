//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by Rommel Rico on 11/2/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import Intents

enum BikeTaxiClass: String, CustomStringConvertible {
    case premier
    case basic
    
    // Uppercases the first letter (e.g. .premier becomes Premier)
    var description: String {
        return self.rawValue.capitalized
    }
}

class IntentHandler: INExtension {
    // TODO - Implement me.
}

extension IntentHandler: INRequestRideIntentHandling {
    // TODO - Implement me.
}
