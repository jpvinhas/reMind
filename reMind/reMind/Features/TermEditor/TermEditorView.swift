//
//  TermEditorView.swift
//  reMind
//
//  Created by Pedro Sousa on 30/06/23.
//

import SwiftUI

struct TermEditorView: View {
    @Binding var box: Box
    @State var term: String
    @State var meaning: String
    @State var editorMode: Bool = false

    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                reTextField(title: "Term", text: $term)
                reTextEditor(title: "Meaning", text: $meaning)
                
                Spacer()

                Button(action: {
                    
                    if editorMode {
                        
                        CoreDataStack.inMemory.saveContext()
                        presentationMode.wrappedValue.dismiss()
                    }else{
                        saveNewTerm()
                    }
                    print("save and add new")
                }, label: {
                    Text(editorMode ? "Save" : "Save and Add New")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(reButtonStyle())
            }
            .padding()
            .background(reBackground())
            .navigationTitle("New Term")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(editorMode ? "" : "Cancel") {
                        print("Cancel")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if editorMode {
                            print("Edited")
                            CoreDataStack.inMemory.saveContext()
                            presentationMode.wrappedValue.dismiss()
                        }else{
                            saveNewTerm()
                        }
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
    private func saveNewTerm(){
        let newTerm = Term(context: box.managedObjectContext ?? CoreDataStack.inMemory.managedContext)
        newTerm.value = term
        newTerm.meaning = meaning
        newTerm.creationDate = Date()
        newTerm.lastReview = Date()
        newTerm.rawSRS = 0
        newTerm.boxID = box
        newTerm.rawTheme = box.rawTheme
        box.addToTerms(newTerm)
        CoreDataStack.inMemory.saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}

struct TermEditorView_Previews: PreviewProvider {
    @State static var box: Box = {
        let box = Box(context: CoreDataStack.inMemory.managedContext)
        box.name = "Box 1"
        box.rawTheme = 0
        BoxView_Previews.terms.forEach { term in
            box.addToTerms(term)
        }
        return box
    }()
    
    static let terms: [Term] = {
        let term1 = Term(context: CoreDataStack.inMemory.managedContext)
        term1.value = "Term 1"
        
        let term2 = Term(context: CoreDataStack.inMemory.managedContext)
        term2.value = "Term 2"
        
        let term3 = Term(context: CoreDataStack.inMemory.managedContext)
        term3.value = "Term 3"
        
        return [term1, term2, term3]
    }()
    static var previews: some View {
        TermEditorView(box: $box, term: "" , meaning: "")}
}
