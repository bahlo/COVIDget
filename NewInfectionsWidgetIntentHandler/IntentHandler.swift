//
//  IntentHandler.swift
//  NewInfectionsWidgetIntentHandler
//
//  Created by Arne Bahlo on 22.09.20.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideDistrictOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<District>?, Error?) -> Void) {
        // TODO: Get available collections from the DataFetcher.
        let mkk = District(identifier: "mkk", display: "Main-Kinzig-Kreis")
        mkk.value = 125
        let tempelhof = District(identifier: "tempelhof", display: "Berlin Tempelhof-Schöneberg")
        tempelhof.value = 415
        let collection = INObjectCollection(items: [mkk, tempelhof])
        completion(collection, nil)
    }
    
}
