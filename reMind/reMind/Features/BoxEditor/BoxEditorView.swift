//
//  BoxEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 29/06/23.
//

import SwiftUI

struct BoxEditorView: View {
    @ObservedObject var viewModel: BoxViewModel
    
    @State var editorMode: Bool = false
    @State var box: Box
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                reTextField(title: "Name", text: $viewModel.name)
                reTextField(title: "Keywords", caption: "Separated by , (comma)", text: $viewModel.keywords)
                reTextEditor(title: "Description", text: $viewModel.description)
                reRadioButtonGroup(title: "Theme", currentSelection: $viewModel.theme)
                if editorMode {
                    Button(action: {
                        removeBox()
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
                            print("edited")
                        }else{saveNewBox()}
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
    private func removeBox() {
        box.destroy()
        try? viewModel.viewContext.save()
        presentationMode.wrappedValue.dismiss()
   }
    private func editBox(){
        box.name = viewModel.name
        box.keywords = viewModel.keywords
        box.rawTheme = Int16(viewModel.theme)
        
        CoreDataStack.inMemory.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
    
}
struct BoxEditorView_Previews: PreviewProvider {
    static var previews: some View {
        BoxEditorView(viewModel: BoxViewModel(viewContext: CoreDataStack.shared.managedContext),editorMode: true,box: Box(context: CoreDataStack.inMemory.managedContext))

    }
}
