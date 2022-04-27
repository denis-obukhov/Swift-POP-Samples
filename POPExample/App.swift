//
//  App.swift
//  App
//
//  Created by Denis Obukhov on 27.04.2022.
//

import SwiftUI

// Switch between `OOP-Compositional-way.swift` and `POP-way.swift` by switching target membership

@main
struct POPExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Form {
                    TextFieldCell(model: TextModel(name: "Full name:"))
                    ColorPickerCell(model: ColorModel(name: "Age:"))
                }
            }
        }
    }
}
