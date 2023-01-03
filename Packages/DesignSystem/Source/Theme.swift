//
//  Theme.swift
//  
//
//  Created by Jack Perry on 2/1/2023.
//

import SwiftUI
import Combine

public class Theme: ObservableObject {

    public enum ThemeKey: String {
        case colorScheme
        case tint
        case label
        case primaryBackground
        case secondaryBackground
    }

    public enum ColorScheme: String {
        case light
        case dark
    }

    // MARK: - Properties

    @AppStorage("is_previously_set")
    private var isSet: Bool = false

    @AppStorage(ThemeKey.colorScheme.rawValue)
    public var colorScheme: ColorScheme = .dark {
        didSet {
            if colorScheme == .dark {
                setColor(set: DarkColorSet())
            } else {
                setColor(set: LightColorSet())
            }
        }
    }

    // MARK: Colors

    @AppStorage(ThemeKey.tint.rawValue) public var tintColor: Color = .black

    @AppStorage(ThemeKey.primaryBackground.rawValue)
    public var primaryBackgroundColor: Color = .white

    @AppStorage(ThemeKey.secondaryBackground.rawValue)
    public var secondaryBackgroundColor: Color = .gray

    @AppStorage(ThemeKey.label.rawValue)
    public var labelColor: Color = .black

    // MARK: - init

    public init() {
        if isSet == false {
            setColor(set: DarkColorSet())
            isSet.toggle()
        }

    }

    // MARK: - Helpers

    public func setColor(set: ColorSet) {
        self.tintColor = set.tintColor
        self.primaryBackgroundColor = set.primaryBackgroundColor
        self.secondaryBackgroundColor = set.secondaryBackgroundColor
        self.labelColor = set.labelColor
    }

}
