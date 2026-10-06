import SwiftUI
import AppIntents

struct PartyPalette {
    static let panelTop = Color(red: 0.075, green: 0.115, blue: 0.165)
    static let panelBottom = Color(red: 0.028, green: 0.050, blue: 0.082)
    static let control = Color(red: 0.095, green: 0.135, blue: 0.185)
    static let controlEdge = Color.white.opacity(0.11)
    static let secondary = Color(red: 0.56, green: 0.64, blue: 0.74)
    static let separator = Color.white.opacity(0.13)
    static let amber = Color(red: 0.94, green: 0.62, blue: 0.16)
    static let red = Color(red: 0.95, green: 0.28, blue: 0.28)
}

struct PartyTrackerCard: View {
    let shots: Int
    let beers: Int
    let shotLimit: Int
    let beerLimit: Int
    let interactive: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [PartyPalette.panelTop, PartyPalette.panelBottom],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(Color.white.opacity(0.16), lineWidth: 1)

            VStack(spacing: 0) {
                header
                    .frame(height: 34)

                Spacer(minLength: 4)

                TrackerRow(
                    title: "Shoty",
                    current: shots,
                    limit: shotLimit,
                    icon: AnyView(ShotGlassIcon()),
                    minusIntent: DecrementShotsIntent(),
                    plusIntent: IncrementShotsIntent(),
                    interactive: interactive
                )

                Divider()
                    .overlay(PartyPalette.separator)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 8)

                TrackerRow(
                    title: "Piwa",
                    current: beers,
                    limit: beerLimit,
                    icon: AnyView(BeerMugIcon()),
                    minusIntent: DecrementBeersIntent(),
                    plusIntent: IncrementBeersIntent(),
                    interactive: interactive
                )
            }
            .padding(15)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var header: some View {
        HStack {
            Text("P A R T Y")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.78))

            Spacer()

            if interactive {
                Button(intent: ResetTrackerIntent()) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 11, weight: .semibold))
                        Text("Reset")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(Color.white.opacity(0.66))
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Reset")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                }
                .foregroundStyle(Color.white.opacity(0.66))
            }
        }
    }
}

private struct TrackerRow<MinusIntent: AppIntent, PlusIntent: AppIntent>: View {
    let title: String
    let current: Int
    let limit: Int
    let icon: AnyView
    let minusIntent: MinusIntent
    let plusIntent: PlusIntent
    let interactive: Bool

    var body: some View {
        HStack(spacing: 10) {
            iconWell

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.82))

                HStack(alignment: .firstTextBaseline, spacing: 3) {
                    Text("\(current)")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(valueColor)

                    Text("/ \(limit)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundStyle(PartyPalette.secondary)
                }
            }

            Spacer(minLength: 2)

            HStack(spacing: 7) {
                if interactive {
                    Button(intent: minusIntent) {
                        ControlSurface(symbol: "minus")
                    }
                    .buttonStyle(.plain)

                    Button(intent: plusIntent) {
                        ControlSurface(symbol: "plus")
                    }
                    .buttonStyle(.plain)
                } else {
                    ControlSurface(symbol: "minus")
                    ControlSurface(symbol: "plus")
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var iconWell: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.075),
                            Color.white.opacity(0.025)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 13, style: .continuous)
                .stroke(Color.white.opacity(0.11), lineWidth: 0.8)

            icon
                .padding(8)
        }
        .frame(width: 42, height: 42)
    }

    private var valueColor: Color {
        if current > limit { return PartyPalette.red }
        if current == limit { return PartyPalette.amber }
        return .white
    }
}

private struct ControlSurface: View {
    let symbol: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            PartyPalette.control.opacity(0.96),
                            PartyPalette.control.opacity(0.68)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .stroke(PartyPalette.controlEdge, lineWidth: 0.8)

            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.9))
        }
        .frame(width: 32, height: 32)
    }
}

struct ShotGlassIcon: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: w * 0.24, y: h * 0.14))
                    path.addLine(to: CGPoint(x: w * 0.76, y: h * 0.14))
                    path.addLine(to: CGPoint(x: w * 0.66, y: h * 0.84))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.34, y: h * 0.84),
                        control: CGPoint(x: w * 0.50, y: h * 0.92)
                    )
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.20),
                            Color.white.opacity(0.045)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                Path { path in
                    path.move(to: CGPoint(x: w * 0.24, y: h * 0.14))
                    path.addLine(to: CGPoint(x: w * 0.76, y: h * 0.14))
                    path.addLine(to: CGPoint(x: w * 0.66, y: h * 0.84))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.34, y: h * 0.84),
                        control: CGPoint(x: w * 0.50, y: h * 0.92)
                    )
                    path.closeSubpath()
                }
                .stroke(Color.white.opacity(0.72), lineWidth: 1.4)

                Capsule()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: w * 0.42, height: 1.4)
                    .offset(y: h * 0.29)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct BeerMugIcon: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                RoundedRectangle(cornerRadius: w * 0.10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                PartyPalette.amber.opacity(0.94),
                                PartyPalette.amber.opacity(0.58)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: w * 0.52, height: h * 0.58)
                    .offset(x: -w * 0.06, y: h * 0.10)

                RoundedRectangle(cornerRadius: w * 0.10, style: .continuous)
                    .stroke(Color.white.opacity(0.72), lineWidth: 1.3)
                    .frame(width: w * 0.52, height: h * 0.60)
                    .offset(x: -w * 0.06, y: h * 0.10)

                RoundedRectangle(cornerRadius: w * 0.12, style: .continuous)
                    .stroke(Color.white.opacity(0.68), lineWidth: 1.5)
                    .frame(width: w * 0.26, height: h * 0.34)
                    .offset(x: w * 0.27, y: h * 0.12)

                HStack(spacing: -2) {
                    Circle()
                    Circle()
                    Circle()
                }
                .foregroundStyle(Color.white.opacity(0.90))
                .frame(width: w * 0.54, height: h * 0.18)
                .offset(x: -w * 0.06, y: -h * 0.23)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
