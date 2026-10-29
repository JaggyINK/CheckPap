import SwiftUI

/// Couleurs de marque. Sarcelle et menthe : neutres, sans rapport avec les couleurs de l'État.
enum Brand {
    static let teal = Color(red: 0x1A / 255, green: 0x86 / 255, blue: 0x6E / 255)
    static let deepTeal = Color(red: 0x0E / 255, green: 0x5A / 255, blue: 0x4C / 255)
    static let mint = Color(red: 0x4F / 255, green: 0xC4 / 255, blue: 0xA0 / 255)
    static let foldTint = Color(red: 0xCF / 255, green: 0xE9 / 255, blue: 0xE1 / 255)
}

// MARK: - Logo

/// Logo de l'app : deux feuilles (les "papiers"), les initiales "CP" et une pastille "validé".
/// Dessiné uniquement avec des formes vectorielles, il reste net à toutes les tailles.
struct LogoMark: View {
    var size: CGFloat = 64
    /// `false` pour l'icône de l'app : iOS arrondit lui-même les coins.
    var rounded: Bool = true

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Brand.mint, Brand.teal, Brand.deepTeal],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            PaperShape()
                .fill(.white.opacity(0.35))
                .frame(width: size * 0.46, height: size * 0.58)
                .rotationEffect(.degrees(-10))
                .offset(x: -size * 0.07, y: -size * 0.03)

            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    PaperShape()
                        .fill(.white)
                    FoldShape()
                        .fill(Brand.foldTint)
                    Text(verbatim: "CP")
                        .font(.system(size: size * 0.19, weight: .heavy, design: .rounded))
                        .foregroundStyle(Brand.deepTeal)
                        .offset(y: -size * 0.03)
                }
                .frame(width: size * 0.46, height: size * 0.58)

                CheckBadge(size: size * 0.22)
                    .offset(x: size * 0.07, y: size * 0.06)
            }
            .compositingGroup()
            .shadow(color: Brand.deepTeal.opacity(0.35), radius: size * 0.04, y: size * 0.02)
            .rotationEffect(.degrees(6))
            .offset(x: size * 0.02, y: size * 0.01)
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: rounded ? size * 0.2237 : 0, style: .continuous))
        .accessibilityHidden(true)
    }
}

/// Pastille ronde "validé" : la coche en forme de V, blanche sur fond menthe.
struct CheckBadge: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(colors: [Brand.mint, Brand.teal], startPoint: .top, endPoint: .bottom))
            Circle()
                .strokeBorder(.white, lineWidth: size * 0.08)
            CheckShape()
                .stroke(.white, style: StrokeStyle(lineWidth: size * 0.12, lineCap: .round, lineJoin: .round))
                .frame(width: size * 0.95, height: size * 0.95)
                .offset(x: size * 0.01, y: -size * 0.06)
        }
        .frame(width: size, height: size)
    }
}

/// Feuille avec le coin supérieur droit plié.
struct PaperShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fold = min(rect.width, rect.height) * 0.26
        let radius = min(rect.width, rect.height) * 0.08
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - fold, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + fold))
        path.addArc(tangent1End: CGPoint(x: rect.maxX, y: rect.maxY),
                    tangent2End: CGPoint(x: rect.minX, y: rect.maxY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.maxY),
                    tangent2End: CGPoint(x: rect.minX, y: rect.minY), radius: radius)
        path.addArc(tangent1End: CGPoint(x: rect.minX, y: rect.minY),
                    tangent2End: CGPoint(x: rect.maxX, y: rect.minY), radius: radius)
        path.closeSubpath()
        return path
    }
}

/// Le petit triangle du coin plié.
struct FoldShape: Shape {
    func path(in rect: CGRect) -> Path {
        let fold = min(rect.width, rect.height) * 0.26
        var path = Path()
        path.move(to: CGPoint(x: rect.maxX - fold, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - fold, y: rect.minY + fold))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + fold))
        path.closeSubpath()
        return path
    }
}

/// La coche, positionnée en proportion de la feuille.
struct CheckShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.24, y: rect.minY + rect.height * 0.56))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.43, y: rect.minY + rect.height * 0.71))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.76, y: rect.minY + rect.height * 0.40))
        return path
    }
}

/// Logo + nom de l'app.
struct Wordmark: View {
    var body: some View {
        HStack(spacing: 12) {
            LogoMark(size: 44)
            Text(verbatim: "Check Pap")
                .font(.title2.weight(.bold))
                .fontDesign(.rounded)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(verbatim: "Check Pap"))
    }
}

#Preview("Logo") {
    VStack(spacing: 24) {
        LogoMark(size: 180)
        Wordmark()
    }
    .padding()
}
