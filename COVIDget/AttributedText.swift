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
    var attributedText: NSAttributedString

    init(_ attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    func makeUIView(context: Context) -> UITextView {
        return UITextView()
    }

    func updateUIView(_ label: UITextView, context: Context) {
        label.attributedText = attributedText
    }
}
