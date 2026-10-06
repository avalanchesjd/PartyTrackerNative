import AppIntents
import Foundation
import WidgetKit

enum TrackerStore {
    private static let shotsKey = "partytracker.shots"
    private static let beersKey = "partytracker.beers"

    static let shotLimit = 15
    static let beerLimit = 2
    static let shotMax = 20
    static let beerMax = 10

    static var shots: Int {
        get { UserDefaults.standard.integer(forKey: shotsKey) }
        set {
            UserDefaults.standard.set(
                max(0, min(shotMax, newValue)),
                forKey: shotsKey
            )
        }
    }

    static var beers: Int {
        get { UserDefaults.standard.integer(forKey: beersKey) }
        set {
            UserDefaults.standard.set(
                max(0, min(beerMax, newValue)),
                forKey: beersKey
            )
        }
    }

    static func refreshWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: "PartyTrackerWidget")
    }

    static func reset() {
        shots = 0
        beers = 0
        refreshWidget()
    }
}

struct IncrementShotsIntent: AppIntent {
    static var title: LocalizedStringResource = "Dodaj shota"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        TrackerStore.shots += 1
        TrackerStore.refreshWidget()
        return .result()
    }
}

struct DecrementShotsIntent: AppIntent {
    static var title: LocalizedStringResource = "Odejmij shota"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        TrackerStore.shots -= 1
        TrackerStore.refreshWidget()
        return .result()
    }
}

struct IncrementBeersIntent: AppIntent {
    static var title: LocalizedStringResource = "Dodaj piwo"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        TrackerStore.beers += 1
        TrackerStore.refreshWidget()
        return .result()
    }
}

struct DecrementBeersIntent: AppIntent {
    static var title: LocalizedStringResource = "Odejmij piwo"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        TrackerStore.beers -= 1
        TrackerStore.refreshWidget()
        return .result()
    }
}

struct ResetTrackerIntent: AppIntent {
    static var title: LocalizedStringResource = "Resetuj Party Tracker"
    static var openAppWhenRun = false

    func perform() async throws -> some IntentResult {
        TrackerStore.reset()
        return .result()
    }
}
