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
    var columns: [GridItem] = [GridItem(.flexible(maximum: 120)), GridItem(.flexible())]

    var body: some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 16) {
                StepView(num: 1, text: Text("SETUP_STEP_1"))
                switch UIDevice.current.userInterfaceIdiom {
                case .pad:
                    StepView(num: 3, text: Text("SETUP_STEP_2_IPAD"))
                default:
                    StepView(num: 3, text: Text("SETUP_STEP_2"))
                }
                StepView(num: 3, text: Text("SETUP_STEP_3"))
                StepView(num: 4, text: Text("SETUP_STEP_4"))
                Spacer()
                LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                    Text("DATASOURCE_LABEL") + Text(":")
                    Link("RKI Corona Landkreise", destination: URL(string: "https://npgeo-corona-npgeo-de.hub.arcgis.com/datasets/917fc37a709542548cc3be077a786c17_0")!)
                    Text("PUBLISHER_LABEL") + Text(":")
                    Link("Robert Koch Institut (RKI)", destination: URL(string: "https://www.rki.de/")!)
                    Text("LICENSE_LABEL") + Text(":")
                    Link("dl-de/by-2-0", destination: URL(string: "https://www.govdata.de/dl-de/by-2-0")!)
                }
            }
                .navigationTitle("COVIDget")
                .padding(16)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
