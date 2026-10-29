// Génère l'icône de l'app (1024 x 1024, sans transparence) à partir du logo SwiftUI.
// Utilisation (depuis la racine du dépôt) :
//   ./scripts/render_app_icon.sh

import AppKit
import SwiftUI

@MainActor
func renderOpaquePNG(_ view: some View, size: Int, to path: String) {
    let renderer = ImageRenderer(content: view.frame(width: CGFloat(size), height: CGFloat(size)))
    renderer.scale = 1
    guard let image = renderer.cgImage else { fatalError("Rendu impossible") }

    // L'App Store refuse les icônes avec canal alpha : on redessine dans un contexte opaque.
    let context = CGContext(
        data: nil, width: size, height: size, bitsPerComponent: 8, bytesPerRow: 0,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    )!
    context.draw(image, in: CGRect(x: 0, y: 0, width: size, height: size))
    let rep = NSBitmapImageRep(cgImage: context.makeImage()!)
    let data = rep.representation(using: .png, properties: [:])!
    try! data.write(to: URL(fileURLWithPath: path))
    print("écrit : \(path)")
}

let output = CommandLine.arguments.dropFirst().first ?? "AppIcon.png"
MainActor.assumeIsolated {
    renderOpaquePNG(LogoMark(size: 1024, rounded: false), size: 1024, to: output)
}
