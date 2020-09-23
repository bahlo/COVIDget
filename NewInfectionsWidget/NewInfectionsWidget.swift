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
        let objectId = Int(truncating: configuration.district?.value ?? 0)

        if objectId < 1 {
            // None or invalid configuration
            completion(Timeline(entries: [NewInfectionsEntry()], policy: .atEnd))
            return
        }
        
        DataFetcher.shared.getAttributes(objectId: objectId) { attributes in
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
    
    init(cases7Per100k: Float64) {
        date = Date()
        configuration = ConfigurationIntent()
        district = "Magrathea"
        self.cases7Per100k = cases7Per100k
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
        VStack {
            VStack(alignment: .leading){
                Text(entry.district)
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                Text(newInfections)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Spacer()
            Group {
                if entry.cases7Per100k < 1 {
                    Text("0")
                        .foregroundColor(.secondary)
                } else if entry.cases7Per100k < 50 {
                    Text(String(format: "%.0f", entry.cases7Per100k))
                        .foregroundColor(.orange)
                } else {
                    Text(String(format: "%.0f", entry.cases7Per100k))
                        .foregroundColor(.red)
                }
            }
                .font(.system(size: 40.0, weight: .regular))
            Spacer()
            Text(per100kInOneWeek)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
            .padding(12)
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
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(cases7Per100k: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(cases7Per100k: 55))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
