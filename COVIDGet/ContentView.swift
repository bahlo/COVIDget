//
//  ContentView.swift
//  COVIDGet
//
//  Created by Arne Bahlo on 21.09.20.
//

import SwiftUI

struct ContentView: View {
    let setupGuide: LocalizedStringKey = "SETUP_GUIDE"
    let sourceNote: LocalizedStringKey = "SOURCE_NOTE"

    var body: some View {
        NavigationView{
            VStack(spacing: 12){
                Text(setupGuide)
                Text(sourceNote)
                Button("dl-de/by-2-0", action: {
                    // TODO: Open Safari
                })
            }
                .navigationTitle("COVIDGet")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
