//
//  NewInfectionsWidget.swift
//  NewInfectionsWidget
//
//  Created by Arne Bahlo on 21.09.20.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: Errors

enum ConfigurationError: Error {
    case invalidObjectId
}

/// Unknown error only exists for the preview.
enum UnknownError: Error {
    case unknown
}

// MARK: Timeline provider

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
            // This is displayed when adding to the homescreen
            completion(Timeline(entries: [NewInfectionsEntry()], policy: .never))
            return
        }
        
        DataFetcher.shared.getAttributes(objectId: objectId) { (attributes, error) in
            // If we have an error, create a timeline that checks again in 10 seconds
            if error != nil {
                let entry = NewInfectionsEntry(configuration: configuration, error: error!)
                let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .minute, value: 1, to: Date())!))
                completion(timeline)
                return
            }
            
            // No error, all good
            let nextHour = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
            let entry = NewInfectionsEntry(configuration: configuration, attributes: attributes!)
            let timeline = Timeline(entries: [entry], policy: .after(nextHour!))
            completion(timeline)
        }
    }
}

// MARK: Entry

struct NewInfectionsEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let district: String
    let cases7Per100k: Float64
    let error: Error?
    
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
        error = nil
    }
    
    init(cases7Per100k: Float64) {
        date = Date()
        configuration = ConfigurationIntent()
        district = "Magrathea"
        self.cases7Per100k = cases7Per100k
        error = nil
    }
    
    init(configuration: ConfigurationIntent, attributes: DistrictAttributes) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm Uhr"
        
        date = dateFormatter.date(from: attributes.lastUpdate) ?? Date()
        self.configuration = configuration
        district = attributes.gen
        cases7Per100k = attributes.cases7Per100k
        error = nil
    }
    
    init(configuration: ConfigurationIntent, error: Error) {
        date = Date()
        cases7Per100k = -1
        district = ""
        self.configuration = configuration
        self.error = error
    }
}

// MARK: Widget

struct NewInfectionsWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            if let error = entry.error {
                VStack(spacing: 12){
                    Spacer()
                    Image(systemName: "exclamationmark.octagon")
                        .font(.system(size: 32, weight: .light))
                    Spacer()
                    Group {
                        switch error {
                        case is URLError:
                            Text("CHECK_CONNECTION")
                        case is ConfigurationError:
                            Text("CHECK_CONFIGURATION")
                        default:
                            Text("UNKNOWN_ERROR")
                        }
                    }
                        .font(.system(size: 16))
                        .minimumScaleFactor(0.5)
                }
                .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading){
                    Text(entry.district)
                        .font(.headline)
                        .minimumScaleFactor(0.5)
                    Text("NEW_INFECTIONS")
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
                Text("PER_100K_IN_ONE_WEEK")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
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

// MARK: Preview

struct NewInfectionsWidget_Previews: PreviewProvider {
    static var previews: some View {
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(cases7Per100k: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(cases7Per100k: 55))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(configuration: ConfigurationIntent(), error: URLError(.badServerResponse)))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(configuration: ConfigurationIntent(), error: ConfigurationError.invalidObjectId))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        NewInfectionsWidgetEntryView(entry: NewInfectionsEntry(configuration: ConfigurationIntent(), error: UnknownError.unknown))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
