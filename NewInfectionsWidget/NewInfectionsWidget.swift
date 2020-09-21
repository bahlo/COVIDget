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
        NewInfectionsEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            district: "--",
            cases: 0
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (NewInfectionsEntry) -> ()) {
        DataFetcher.shared.getAttributes(objectId: 125) { attributes in
            let entry = NewInfectionsEntry(
                date: Date(),
                configuration: configuration,
                district: attributes.gen,
                cases: attributes.cases
            )
            completion(entry)
        }
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        DataFetcher.shared.getAttributes(objectId: 125) { attributes in
            let entries = [
                NewInfectionsEntry(
                    date: Date(),
                    configuration: configuration,
                    district: attributes.gen,
                    cases: attributes.cases
                )
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
    let cases: Int
    
    var formattedDate: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: date)
        }
    }
}

struct NewInfectionsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text("New infections")
                    .font(.headline)
                Text(entry.district)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(entry.cases)")
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
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(
            date: Date(),
            configuration: ConfigurationIntent(),
            district: "Main-Kinzig-Kreis",
            cases: 42
        ))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
