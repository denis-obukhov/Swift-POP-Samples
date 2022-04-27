//
//  POPWay.swift
//  POPExample
//
//  Created by Denis Obukhov on 27.04.2022.
//

import SwiftUI

// Protocol-oriented way

// Model for a text input. Adopts BaseModel as it contains a name and Validating protocol to check if input text isn't empty
final class TextModel: BaseModel, Validating {
    var name: String = ""
    @Published var inputText: String = ""
    @Published var isValid: Bool?
    
    init(name: String) {
        self.name = name
    }
    
    func validate() {
        isValid = !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// Model for a color picker. Adopts BaseModel as it contains a name
final class ColorModel: BaseModel {
    var name: String = ""
    @Published var pickedColor: Color?
    let colors: [Color] = [.red, .green, .blue, .brown, .cyan, .mint]
    
    init(name: String) {
        self.name = name
    }
}

// Protocol for a validating entity
protocol Validating {
    var isValid: Bool? { get }
    func validate()
}

// Basic model
protocol BaseModel: ObservableObject {
    var name: String { get set }
}

// MARK: - Views:

// Basic cell protocol
protocol PickerCell: View {
    associatedtype Content: View
    associatedtype Model: BaseModel
    var model: Model { get }
    var cellBody: Content { get }
}

// Add basic UI
extension PickerCell {
    var body: some View {
        HStack {
            Text(model.name)
                .layoutPriority(1)
            Spacer(minLength: 20)
            cellBody
        }
    }
}

// Contrains Model type to be Validating as we're going to call `validate()` and bind to `isValid` value
protocol ValidatingPickerCell: PickerCell where Model: Validating {}

// Add some validation UI
extension ValidatingPickerCell {
    var body: some View {
        VStack {
            HStack {
                Text(model.name)
                    .layoutPriority(1)
                Spacer(minLength: 20)
                cellBody
                    .onSubmit {
                        model.validate()
                    }
            }
            if model.isValid == false {
                Text("Invalid value")
                    .foregroundColor(.red)
            }
        }
    }
}

struct TextFieldCell<T: TextModel>: ValidatingPickerCell {
    @ObservedObject var model: T
    
    // var body is used from default implementation
    // Less code, more reusable
    var cellBody: some View {
        TextField("Enter text", text: $model.inputText)
    }
}

struct ColorPickerCell<T: ColorModel>: PickerCell {
    @ObservedObject var model: T
    
    // var body is used from default implementation
    // Less code, more reusable
    var cellBody: some View {
        Picker("Pick a color", selection: $model.pickedColor) {
            ForEach(model.colors, id: \.self) {
                $0.tag($0 as Color?)
            }
        }
    }
}
