import SwiftUI

struct StaticPreviewCard: View {
    var body: some View {
        PartyTrackerCard(
            shots: 6,
            beers: 1,
            shotLimit: 15,
            beerLimit: 2,
            interactive: false
        )
    }
}
