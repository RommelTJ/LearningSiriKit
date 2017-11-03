//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by Rommel Rico on 11/2/17.
//  Copyright © 2017 Rommel Rico. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    private func placemarkResolutionResult(for placemark: CLPlacemark?) -> INPlacemarkResolutionResult {
        guard let placemark = placemark else {
            return INPlacemarkResolutionResult.needsValue()
        }
        
        let result: INPlacemarkResolutionResult
        
        if placemark.isoCountryCode == "GB" {
            result = INPlacemarkResolutionResult.success(with: placemark)
        }
        else {
            result = INPlacemarkResolutionResult.unsupported()
        }
        
        return result
    }
    
}

extension IntentHandler: INRequestRideIntentHandling {
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
        // Our fictional company has unlimited numbers of drivers, all called John Appleseed, so we'll always be able to get to the user.
        let responseCode = INRequestRideIntentResponseCode.success
        
        let response = INRequestRideIntentResponse(code: responseCode,
                                                   userActivity: nil)
        
        // Set up the driver info
        let driverHandle = INPersonHandle(value: "john@biketaxis.com", type: .emailAddress)
        var personComponents = PersonNameComponents()
        personComponents.familyName = "Appleseed"
        personComponents.givenName = "John"
        
        let formatter = PersonNameComponentsFormatter()
        
        let driver = INRideDriver(personHandle: driverHandle,
                                  nameComponents: personComponents,
                                  displayName: formatter.string(from: personComponents),
                                  image: nil,
                                  contactIdentifier: nil,
                                  customIdentifier: nil)
        
        let vehicle = INRideVehicle()
        
        vehicle.model = intent.rideOptionName!.spokenPhrase // Model name will be "Basic" or "Premier"
        
        // Hardcode the location to be center of Newcastle, UK
        vehicle.location = CLLocation(latitude: 54.978252,
                                      longitude: -1.6177800000000389)
        
        // The important part - combining all the above information
        let status = INRideStatus()
        status.driver = driver
        status.vehicle = vehicle
        status.phase = .confirmed
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        
        response.rideStatus = status
        
        completion(response)
    }
    
}

//MARK:- Resolving

extension IntentHandler {
    
    // At our fictional company, we only allow one passenger (it's hard to fit more on a bike!)
    func resolvePartySize(for intent: INRequestRideIntent, with completion: @escaping (INIntegerResolutionResult) -> Void) {
        let result: INIntegerResolutionResult
        
        if let partySize = intent.partySize{
            if partySize == 1 {
                // We can offer a ride to this one person
                result = INIntegerResolutionResult.success(with: 1)
            } else {
                // Sorry... we don't support giving rides to more than 1 person
                result = INIntegerResolutionResult.unsupported()
            }
        } else {
            result = INIntegerResolutionResult.confirmationRequired(with: 1)
        }
        
        completion(result)
    }
    
    // We have two classes of rides: premier and basic
    func resolveRideOptionName(for intent: INRequestRideIntent, with completion: @escaping (INSpeakableStringResolutionResult) -> Void) {
        if let rideName = intent.rideOptionName?.spokenPhrase.lowercased(),
            let taxiClass = BikeTaxiClass(rawValue: rideName) {
            
            let speakableString = INSpeakableString(vocabularyIdentifier: "", spokenPhrase: taxiClass.description, pronunciationHint: taxiClass.description)
            let result = INSpeakableStringResolutionResult.success(with: speakableString)
            completion(result)
            return
        }
        
        let premier = BikeTaxiClass.premier.description
        let premierSpeakableString = INSpeakableString(vocabularyIdentifier: "", spokenPhrase: premier, pronunciationHint: premier)
        
        let basic = BikeTaxiClass.basic.description
        let basicSpeakableString = INSpeakableString(vocabularyIdentifier: "", spokenPhrase: basic, pronunciationHint: basic)
        
        let result = INSpeakableStringResolutionResult.disambiguation(with: [premierSpeakableString, basicSpeakableString])
        
        completion(result)
    }
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        completion(placemarkResolutionResult(for: intent.pickupLocation))
    }
    
    func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        completion(placemarkResolutionResult(for: intent.dropOffLocation))
    }
    
    
}

//MARK:- Confirming

extension IntentHandler {
    
    func confirm(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        // Verify network connection to our state-of-the-art ride booking service is available
        
        // Let's say it is
        let responseCode = INRequestRideIntentResponseCode.ready
        let response = INRequestRideIntentResponse(code: responseCode, userActivity: nil)
        
        // Move on to the handling stage
        completion(response)
    }

}
