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
    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 16) {
                StepView(num: 1, text: Text("SETUP_STEP_1"))
                StepView(num: 2, text: Text("SETUP_STEP_2"))
                StepView(num: 3, text: Text("SETUP_STEP_3"))
                StepView(num: 4, text: Text("SETUP_STEP_4"))
                Spacer()
                Text("SOURCE_NOTE \(Text("LICENCE"))")
                Link("VIEW_LICENCE", destination: URL(string: "https://www.govdata.de/dl-de/by-2-0")!)
                Link("VIEW_DATA_RECORD", destination: URL(string: "https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0")!)
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
