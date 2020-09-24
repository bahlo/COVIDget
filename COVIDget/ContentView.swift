//
//  ContentView.swift
//  COVIDget
//
//  Created by Arne Bahlo on 21.09.20.
//

import SwiftUI
import UIKit

struct StepView: View {
    let num: Int
    let text: Text
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "\(num).circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.accentColor)
            text
        }
    }
}

struct ContentView: View {
    let setupStep1: LocalizedStringKey = "SETUP_STEP_1"
    let setupStep2: LocalizedStringKey = "SETUP_STEP_2"
    let setupStep3: LocalizedStringKey = "SETUP_STEP_3"
    let setupStep4: LocalizedStringKey = "SETUP_STEP_4"
    let sourceNote: LocalizedStringKey = "SOURCE_NOTE"
    let viewLicence: LocalizedStringKey = "VIEW_LICENCE"
    let viewDataRecord: LocalizedStringKey = "VIEW_DATA_RECORD"

    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 16) {
                StepView(num: 1, text: Text(setupStep1))
                StepView(num: 2, text: Text(setupStep2))
                StepView(num: 3, text: Text(setupStep3))
                StepView(num: 4, text: Text(setupStep4))
                Spacer()
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
