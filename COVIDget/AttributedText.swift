//
//  AttributedText.swift
//  COVIDget
//
//  Created by Arne Bahlo on 22.09.20.
//

import UIKit
import SwiftUI
import Foundation

struct AttributedText: UIViewRepresentable {
    var text: NSAttributedString
    var width: CGFloat

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.isSelectable = false
        view.isEditable = false
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
}
