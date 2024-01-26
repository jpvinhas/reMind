//
//  BoxView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct BoxView: View {
    @State var box: Box
    
    @State private var searchText: String = ""
    @State private var isEditingBox: Bool = false
    @State private var isCreatingNewTerm: Bool = false
    
    private var filteredTerms: [Term] {
        let termsSet = box.terms as? Set<Term> ?? []
        let terms = Array(termsSet).sorted { lhs, rhs in
            (lhs.value ?? "") < (rhs.value ?? "")
        }
        
        if searchText.isEmpty {
            return terms
        } else {
            return terms.filter { ($0.value ?? "").contains(searchText) }
        }
    }
    
    var body: some View {
        List {
            TodaysCardsView(numberOfPendingCards: box.terms?.count ?? 0,
                            theme: box.theme,box: box)
            Section {
                ForEach(filteredTerms, id: \.self) { term in
                    Text(term.value ?? "Unknown")
                        .padding(.vertical, 8)
                        .fontWeight(.bold)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                print("delete")
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                        }
                }
            } header: {
                Text("All Cards")
                    .textCase(.none)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Palette.label.render)
                    .padding(.leading, -16)
                    .padding(.bottom, 16)
            }
            
        }
        .scrollContentBackground(.hidden)
        .background(reBackground())
        .navigationTitle(box.name ?? "Unknown")
        .searchable(text: $searchText, prompt: "")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isEditingBox.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                
                Button {
                    isCreatingNewTerm.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                
            }
            
        }
        .sheet(isPresented: $isEditingBox) {
            BoxEditorView(viewModel: BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext))
        }

        .sheet(isPresented: $isCreatingNewTerm) {
            TermEditorView(box: $box, term: "", meaning: "")
        }
    }
}
struct BoxView_Previews: PreviewProvider {
        static var box: Box = {
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
        NavigationStack {
            BoxView(box: BoxView_Previews.box)
        }
    }
}

