import SwiftUI
import WidgetKit
import AppIntents

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
        completion(Timeline(entries: [entry], policy: .after(Date.now.addingTimeInterval(900))))
    }
}

struct PartyTrackerWidgetEntryView: View {
    let entry: PartyProvider.Entry

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("PARTY")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                Spacer(minLength: 4)
                Button(intent: ResetTrackerIntent()) {
                    Image(systemName: "arrow.counterclockwise")
                        .frame(width: 28, height: 24)
                }
                .accessibilityLabel("Wyzeruj liczniki")
                .buttonStyle(.plain)
            }
            HStack(spacing: 8) {
                counter(title: "Shoty", value: entry.shots, limit: TrackerStore.shotLimit) {
                    Button(intent: DecrementShotsIntent()) { control("minus") }
                        .accessibilityLabel("Odejmij shot")
                    Button(intent: IncrementShotsIntent()) { control("plus") }
                        .accessibilityLabel("Dodaj shot")
                }
                Rectangle().fill(.white.opacity(0.15)).frame(width: 1)
                counter(title: "Piwa", value: entry.beers, limit: TrackerStore.beerLimit) {
                    Button(intent: DecrementBeersIntent()) { control("minus") }
                        .accessibilityLabel("Odejmij piwo")
                    Button(intent: IncrementBeersIntent()) { control("plus") }
                        .accessibilityLabel("Dodaj piwo")
                }
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(.white)
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget) {
            LinearGradient(colors: [PartyPalette.panelTop, PartyPalette.panelBottom],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    private func counter<Controls: View>(title: String, value: Int, limit: Int,
                                        @ViewBuilder controls: () -> Controls) -> some View {
        VStack(spacing: 4) {
            Text(title).font(.system(size: 12, weight: .medium))
            Text("\(value)")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(value > limit ? PartyPalette.red : (value == limit ? PartyPalette.amber : .white))
                .minimumScaleFactor(0.7)
            Text("/ \(limit)")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(PartyPalette.secondary)
            HStack(spacing: 4) { controls() }
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
    }

    private func control(_ symbol: String) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 12, weight: .bold))
            .frame(maxWidth: .infinity, minHeight: 28)
            .background(PartyPalette.control, in: RoundedRectangle(cornerRadius: 8))
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
        .containerBackgroundRemovable(false)
    }
}

@main
struct PartyTrackerWidgetBundle: WidgetBundle {
    var body: some Widget {
        PartyTrackerWidget()
    }
}
