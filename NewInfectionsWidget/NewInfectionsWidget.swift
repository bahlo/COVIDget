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
        completion(NewInfectionsEntry())
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        DataFetcher.shared.getAttributes(objectId: 125) { attributes in
            let entries = [
                NewInfectionsEntry(configuration: configuration, attributes: attributes)
            ]
            
            let in24h = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            let tomorrow = Calendar.current.startOfDay(for: in24h!)

            let timeline = Timeline(entries: entries, policy: .after(tomorrow))
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
        cases7Per100k = 42
        district = "Magrathea"
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
    let newInfections: LocalizedStringKey = "NEW_INFECTIONS"
    let per100kInOneWeek: LocalizedStringKey = "PER_100K_IN_ONE_WEEK"

    var body: some View {
        VStack{
            VStack(alignment: .leading){
                Text(newInfections)
                    .font(.headline)
                Text(entry.district)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Group {
                if entry.cases7Per100k < 1 {
                    Text("0")
                        .foregroundColor(.secondary)
                } else {
                    Text(String(format: "%.0f", entry.cases7Per100k))
                        .foregroundColor(.red)
                }
            }
                .font(.system(size: 36))
            Spacer()
            Text(per100kInOneWeek)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }.padding(12)
    }
}

@main
struct NewInfectionsWidget: Widget {
    let kind: String = "NewInfectionsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            NewInfectionsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(NSLocalizedString("NEW_INFECTIONS", comment: "Headline for new infections widget"))
        .description(NSLocalizedString("NEW_INFECTIONS_DESCRIPTION", comment: "Description of new infections widget"))
        .supportedFamilies([.systemSmall])
    }
}

struct NewInfectionsWidget_Previews: PreviewProvider {
    static var previews: some View {
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
