//
//  IntentViewController.swift
//  IntentHandlerUI
//
//  Created by Rommel Rico on 11/2/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import IntentsUI

class IntentViewController: UIViewController, INUIHostedViewControlling {
    
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var dropOffLocationLabel: UILabel!
    @IBOutlet weak var bikeTypeLabel: UILabel!
    @IBOutlet weak var rideImageView: UIImageView!
    
    
    // MARK: - INUIHostedViewControlling
    
    // Prepare your view controller for the interaction to handle.
    func configure(with interaction: INInteraction, context: INUIHostedViewContext, completion: @escaping (CGSize) -> Void) {
        let intent = interaction.intent as! INRequestRideIntent
        let rideName = intent.rideOptionName?.spokenPhrase
        let pickUpLocation = intent.pickupLocation
        let dropOffLocation = intent.dropOffLocation
        let bikeTaxiClass = BikeTaxiClass(rawValue: rideName!.lowercased())!
        
        // Configure the image type
        rideImageView.image = bikeTaxiClass == .basic ? #imageLiteral(resourceName: "basic") : #imageLiteral(resourceName: "premier")
        
        // Set the pickup and dropoff points.
        pickupLocationLabel.text = pickUpLocation?.name ?? ""
        dropOffLocationLabel.text = dropOffLocation?.name ?? ""
        bikeTypeLabel.text = "Vehicle Type: \(bikeTaxiClass)"
        
        completion(self.desiredSize)
    }
    
    var desiredSize: CGSize {
        return self.extensionContext!.hostedViewMaximumAllowedSize
    }
    
}
