//
//  NewInfectionsWidget.swift
//  NewInfectionsWidget
//
//  Created by Arne Bahlo on 21.09.20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> NewInfectionsEntry {
        NewInfectionsEntry()
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NewInfectionsEntry) -> ()) {
        DataFetcher.shared.getAttributes(objectId: 125) { attributes in
            let entry = NewInfectionsEntry(configuration: configuration, attributes: attributes)
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        DataFetcher.shared.getAttributes(objectId: 125) { attributes in
            let entries = [
                NewInfectionsEntry(configuration: configuration, attributes: attributes)
            ]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct NewInfectionsEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let district: String
    let cases7Per100k: Float64
    
    var formattedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: date)
        }
    }
    
    init() {
        date = Date()
        configuration = ConfigurationIntent()
        cases7Per100k = 0
        district = "--"
    }
    
    init(configuration: ConfigurationIntent, attributes: DistrictAttributes) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm Uhr"
        
        date = dateFormatter.date(from: attributes.lastUpdate) ?? Date()
        self.configuration = configuration
        district = attributes.gen
        cases7Per100k = attributes.cases7Per100k
    }
}

struct NewInfectionsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("New Infections")
                    .font(.headline)
                Text(entry.district)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(String(format: "%.0f", entry.cases7Per100k))
                .font(.system(size: 40))
                .foregroundColor(.red)
                .fontWeight(.medium)
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                    .font(.system(size: 12))
                Text("\(entry.formattedDate)")
                    .font(.footnote)
            }
                .foregroundColor(.gray)
        }.padding()
    }
}

@main
struct NewInfectionsWidget: Widget {
    let kind: String = "NewInfectionsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NewInfectionsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("New Infections")
        .description("Display the new infections for a district.")
        .supportedFamilies([.systemSmall])
    }
}

struct NewInfectionsWidget_Previews: PreviewProvider {
    static var previews: some View {
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
