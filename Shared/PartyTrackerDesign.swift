import SwiftUI
import AppIntents
import UIKit

struct PartyPalette {
    static let panelTop = Color(red: 0.14, green: 0.19, blue: 0.25)
    static let panelBottom = Color(red: 0.055, green: 0.075, blue: 0.10)
    static let secondary = Color(red: 0.48, green: 0.54, blue: 0.62)
    static let amber = Color(red: 0.94, green: 0.62, blue: 0.16)
    static let red = Color(red: 0.95, green: 0.28, blue: 0.28)
}

struct PartyPanelBackground: View {
    var body: some View {
        LinearGradient(colors: [PartyPalette.panelTop, PartyPalette.panelBottom,
                                Color(red: 0.08, green: 0.105, blue: 0.145)],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

// The exact illustrated wells from the supplied reference. Only small,
// independently rasterized images reach SwiftUI, not the full reference.
private enum ReferenceArt {
    static let wells: [UIImage] = {
        guard let source = UIImage(named: "PartyReference")?.cgImage else { return [] }
        return [CGRect(x: 337, y: 466, width: 142, height: 150),
                CGRect(x: 337, y: 700, width: 142, height: 151)].compactMap { rect in
            guard let crop = source.cropping(to: rect) else { return nil }
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            return UIGraphicsImageRenderer(size: rect.size, format: format).image { _ in
                UIImage(cgImage: crop).draw(in: CGRect(origin: .zero, size: rect.size))
            }
        }
    }()
}

struct PartyTrackerCard: View {
    let shots: Int
    let beers: Int
    let shotLimit: Int
    let beerLimit: Int
    let interactive: Bool

    var body: some View {
        GeometryReader { geometry in
            let s = geometry.size.width / 344
            let v = geometry.size.height / 324
            ZStack(alignment: .topLeading) {
                PartyPanelBackground()
                RoundedRectangle(cornerRadius: 49 * s, style: .continuous)
                    .strokeBorder(LinearGradient(colors: [.white.opacity(0.34), .white.opacity(0.05), .white.opacity(0.10)],
                                                 startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: s)
                Text("PARTY")
                    .font(.system(size: 18 * s, weight: .semibold))
                    .tracking(3.3 * s)
                    .foregroundStyle(Color(red: 0.76, green: 0.80, blue: 0.86))
                    .position(x: 68 * s, y: 45 * v)
                if interactive {
                    Button(intent: ResetTrackerIntent()) { resetLabel(s) }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Wyzeruj liczniki")
                        .position(x: 278 * s, y: 45 * v)
                } else {
                    resetLabel(s).position(x: 278 * s, y: 45 * v)
                }
                row(title: "Shoty", value: shots, limit: shotLimit, art: 0, s: s,
                    minus: DecrementShotsIntent(), plus: IncrementShotsIntent())
                    .position(x: 173 * s, y: 123 * v)
                Rectangle().fill(Color.white.opacity(0.12))
                    .frame(width: 291 * s, height: s)
                    .position(x: 171.5 * s, y: 181 * v)
                row(title: "Piwa", value: beers, limit: beerLimit, art: 1, s: s,
                    minus: DecrementBeersIntent(), plus: IncrementBeersIntent())
                    .position(x: 173 * s, y: 240 * v)
            }
            .clipShape(RoundedRectangle(cornerRadius: 49 * s, style: .continuous))
        }
    }

    private func resetLabel(_ s: CGFloat) -> some View {
        HStack(spacing: 9 * s) {
            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 20 * s, weight: .regular))
            Text("Reset").font(.system(size: 16 * s))
        }
        .foregroundStyle(Color(red: 0.60, green: 0.65, blue: 0.72))
        .frame(width: 83 * s, height: 32 * s)
        .contentShape(Rectangle())
    }

    private func row<M: AppIntent, P: AppIntent>(title: String, value: Int, limit: Int,
                                                art: Int, s: CGFloat, minus: M, plus: P) -> some View {
        HStack(spacing: 0) {
            Group {
                if ReferenceArt.wells.indices.contains(art) {
                    Image(uiImage: ReferenceArt.wells[art]).resizable().interpolation(.high)
                } else {
                    Image(systemName: art == 0 ? "wineglass" : "mug").resizable().scaledToFit()
                        .padding(14 * s).foregroundStyle(.white)
                }
            }
            .frame(width: 71 * s, height: 75 * s)
            .clipShape(RoundedRectangle(cornerRadius: 18 * s, style: .continuous))
            Spacer().frame(width: 10 * s)
            VStack(alignment: .leading, spacing: 4 * s) {
                Text(title)
                    .font(.system(size: 20 * s))
                    .foregroundStyle(Color(red: 0.78, green: 0.81, blue: 0.86))
                HStack(alignment: .firstTextBaseline, spacing: 5 * s) {
                    Text("\(value)")
                        .font(.system(size: 36 * s, weight: .semibold))
                        .foregroundStyle(value > limit ? PartyPalette.red : (value == limit ? PartyPalette.amber : .white))
                    Text("/ \(limit)")
                        .font(.system(size: 28 * s, weight: .medium))
                        .foregroundStyle(PartyPalette.secondary)
                }
                .minimumScaleFactor(0.65)
            }
            .lineLimit(1)
            .frame(width: 88 * s, alignment: .leading)
            Spacer().frame(width: 6 * s)
            if interactive {
                Button(intent: minus) { control("minus", s) }
                    .accessibilityLabel("\(title): odejmij jeden")
                Spacer().frame(width: 13 * s)
                Button(intent: plus) { control("plus", s) }
                    .accessibilityLabel("\(title): dodaj jeden")
            } else {
                control("minus", s)
                Spacer().frame(width: 13 * s)
                control("plus", s)
            }
        }
        .buttonStyle(.plain)
        .frame(width: 296 * s, height: 75 * s)
    }

    private func control(_ symbol: String, _ s: CGFloat) -> some View {
        Image(systemName: symbol)
            .font(.system(size: 29 * s, weight: .medium))
            .foregroundStyle(Color(red: 0.91, green: 0.93, blue: 0.96))
            .frame(width: 54 * s, height: 56 * s)
            .background {
                RoundedRectangle(cornerRadius: 15 * s, style: .continuous)
                    .fill(LinearGradient(colors: [Color(red: 0.19, green: 0.24, blue: 0.29),
                                                  Color(red: 0.09, green: 0.13, blue: 0.17)],
                                         startPoint: .topLeading, endPoint: .bottomTrailing))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15 * s, style: .continuous)
                            .strokeBorder(LinearGradient(colors: [.white.opacity(0.32), .white.opacity(0.04)],
                                                         startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: s)
                    }
            }
    }
}
