//
//  CompositionalWay.swift
//  POPExample
//
//  Created by Denis Obukhov on 27.04.2022.
//

import SwiftUI

// Compositional/OOP way

final class TextModel: ValidatingModel {
    @Published var inputText: String = ""
    
    override func validate() {
        isValid = !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

final class ColorModel: BaseModel {
    @Published var pickedColor: Color?
    let colors: [Color] = [.red, .green, .blue, .brown, .cyan, .mint]
}

class ValidatingModel: BaseModel {
    @Published var isValid: Bool?
    func validate() { fatalError("To implement in an ancestor") }
}

class BaseModel: ObservableObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

// MARK: - Views:

struct BaseCell<T: View>: View {
    let title: String
    @ViewBuilder var content: () -> T
    
    var body: some View {
        HStack {
            Text(title)
                .layoutPriority(1)
            Spacer(minLength: 20)
            content()
        }
    }
}

struct TextFieldCell: View {
    @StateObject var model: TextModel
    
    var body: some View {
        VStack {
            BaseCell(title: model.name) {
                TextField("Enter text", text: $model.inputText)
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

struct ColorPickerCell: View {
    @StateObject var model: ColorModel
    
    var body: some View {
        BaseCell(title: model.name) {
            Picker("Pick a color", selection: $model.pickedColor) {
                ForEach(model.colors, id: \.self) {
                    $0.tag($0 as Color?)
                }
            }
        }
    }
}
