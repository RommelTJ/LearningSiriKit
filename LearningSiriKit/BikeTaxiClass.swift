//
//  BikeTaxiClass.swift
//  LearningSiriKit
//
//  Created by Rommel Rico on 11/3/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

enum BikeTaxiClass: String, CustomStringConvertible {
    case premier
    case basic
    
    var description: String {
        return self.rawValue.localizedCapitalized
    }
}
