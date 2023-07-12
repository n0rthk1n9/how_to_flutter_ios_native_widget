//
//  HowToFlutterIosNativeWidget.swift
//  HowToFlutterIosNativeWidget
//
//  Created by Jan Armbrust on 12.07.23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), widgetData: WidgetData(text: "Flutter iOS native widget!"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), widgetData: WidgetData(text: "Flutter iOS native widget!"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let sharedDefaults = UserDefaults(suiteName: "group.howToFlutterIosNativeWidgetiOS16")
        let flutterData = try? JSONDecoder().decode(WidgetData.self, from: (sharedDefaults?
            .string(forKey: "widgetData")?.data(using: .utf8)) ?? Data())

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, widgetData: flutterData)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WidgetData: Decodable, Hashable {
    let text: String
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let widgetData: WidgetData?
}

struct HowToFlutterIosNativeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.widgetData?.text ?? "Tap to set message.")
    }
}

struct HowToFlutterIosNativeWidget: Widget {
    let kind: String = "HowToFlutterIosNativeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HowToFlutterIosNativeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Flutter iOS Native Widget")
        .description("This is an example widget, created by Flutter and showing data from Flutter.")
    }
}

struct HowToFlutterIosNativeWidget_Previews: PreviewProvider {
    static var previews: some View {
        HowToFlutterIosNativeWidgetEntryView(entry: SimpleEntry(date: Date(), widgetData: WidgetData(text: "Flutter iOS native widget!")))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
