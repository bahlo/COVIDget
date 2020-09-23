//
//  IntentHandler.swift
//  NewInfectionsWidgetIntentHandler
//
//  Created by Arne Bahlo on 22.09.20.
//

import Intents

class IntentHandler: INExtension, ConfigurationIntentHandling {
    func provideDistrictOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<District>?, Error?) -> Void) {
        DataFetcher.shared.getDistrictData { data in
            var districts = data.features.map { (feature) -> District in
                let district = District(identifier: feature.attributes.gen, display: feature.attributes.gen)
                district.value = feature.attributes.objectId as NSNumber
                return district
            }
            districts.sort {
                $0.identifier! < $1.identifier!
            }
            let collection = INObjectCollection(items: districts)
            completion(collection, nil)
        }
    }
    
}
