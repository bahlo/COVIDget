//
//  ContentView.swift
//  COVIDget
//
//  Created by Arne Bahlo on 21.09.20.
//

import SwiftUI
import UIKit

struct ContentView: View {
    let setupGuide: LocalizedStringKey = "SETUP_GUIDE"
    let sourceNote: LocalizedStringKey = "SOURCE_NOTE"
    let viewLicence: LocalizedStringKey = "VIEW_LICENCE"
    let viewDataRecord: LocalizedStringKey = "VIEW_DATA_RECORD"

    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 16) {
                Text(setupGuide)
                Text(sourceNote)
                Link(viewLicence, destination: URL(string: "https://www.govdata.de/dl-de/by-2-0")!)
                Link(viewDataRecord, destination: URL(string: "https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0")!)
            }
                .navigationTitle("COVIDget")
                .padding(16)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
