//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {
    
    @ObservedObject var editorViewModel: EditorViewModel
    
    @State var editorMode: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                reTextField(title: "Name", text: $editorViewModel.name)
                reTextField(title: "Keywords", caption: "Separated by , (comma)", text: $editorViewModel.keywords)
                reTextEditor(title: "Description", text: $editorViewModel.description)
                reRadioButtonGroup(title: "Theme", currentSelection: $editorViewModel.theme)
                if editorMode {
                    Button(action: {
                        editorViewModel.removeBox()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Remove")
                            .foregroundColor(.red)
                            .padding()
                    }
                    .padding(.bottom, 20)
                }
                Spacer()
            }
            .padding()
            .background(reBackground())
            .navigationTitle(editorMode ? "Edit Box" : "New Box")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if editorMode{
                            editorViewModel.editBox()
                            editorViewModel.viewModel.updateBoxes()
                            presentationMode.wrappedValue.dismiss()
                            print("edited")
                            print("ViewModel Boxess: \(editorViewModel.viewModel.boxes)")
                        }else{
                            editorViewModel.saveNewBox()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}
struct BoxEditorView_Previews: PreviewProvider {
    static let context = CoreDataStack.inMemory.managedContext
    static var previews: some View {
        BoxEditorView(editorViewModel: EditorViewModel(viewModel: BoxViewModel(viewContext: context), box: Box(context: context)))
    }
}
