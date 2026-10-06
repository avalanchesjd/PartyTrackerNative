import SwiftUI
import WidgetKit

struct PartyEntry: TimelineEntry {
    let date: Date
    let shots: Int
    let beers: Int
}

struct PartyProvider: TimelineProvider {
    func placeholder(in context: Context) -> PartyEntry {
        PartyEntry(date: .now, shots: 6, beers: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (PartyEntry) -> Void) {
        completion(
            PartyEntry(
                date: .now,
                shots: TrackerStore.shots,
                beers: TrackerStore.beers
            )
        )
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PartyEntry>) -> Void) {
        let entry = PartyEntry(
            date: .now,
            shots: TrackerStore.shots,
            beers: TrackerStore.beers
        )
        completion(Timeline(entries: [entry], policy: .never))
    }
}

struct PartyTrackerWidgetEntryView: View {
    let entry: PartyProvider.Entry

    var body: some View {
        PartyTrackerCard(
            shots: entry.shots,
            beers: entry.beers,
            shotLimit: TrackerStore.shotLimit,
            beerLimit: TrackerStore.beerLimit,
            interactive: true
        )
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct PartyTrackerWidget: Widget {
    let kind = "PartyTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PartyProvider()) { entry in
            PartyTrackerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Party Tracker")
        .description("Shoty i piwa bez otwierania aplikacji.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

@main
struct PartyTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        PartyTrackerWidget()
    }
}
