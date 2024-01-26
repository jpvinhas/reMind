//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {
    @ObservedObject var viewModel: BoxViewModel

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                reTextField(title: "Name", text: $viewModel.name)
                reTextField(title: "Keywords", caption: "Separated by , (comma)", text: $viewModel.keywords)
                reTextEditor(title: "Description", text: $viewModel.description)
                reRadioButtonGroup(title: "Theme", currentSelection: $viewModel.theme)
                Spacer()
            }
            .padding()
            .background(reBackground())
            .navigationTitle("New Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNewBox()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    private func saveNewBox(){
        let newBox = Box(context: CoreDataStack.inMemory.managedContext)
        newBox.name = viewModel.name
        newBox.keywords = viewModel.keywords
        newBox.rawTheme = Int16(viewModel.theme)

        viewModel.boxes.append(newBox)
        CoreDataStack.inMemory.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}
struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(viewModel: BoxViewModel(viewContext: CoreDataStack.shared.managedContext))

    }
}
