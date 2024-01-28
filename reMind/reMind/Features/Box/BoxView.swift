
import SwiftUI

struct BoxView: View {
    
    @ObservedObject var viewModel: BoxViewModel
    
    @State var box: Box
    
    @State private var searchText: String = ""
    @State private var isEditingBox: Bool = false
    @State private var isCreatingNewTerm: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
        content
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
                let editorViewModel = EditorViewModel(viewModel: viewModel,box: box)
                BoxEditorView(editorViewModel: editorViewModel, editorMode: true)
                .onDisappear {
                    if box.name == nil {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }

            .sheet(isPresented: $isCreatingNewTerm) {
                TermEditorView(box: $box, term: "", meaning: "")
            }
    }

    private var content: some View {
        List {
            TodaysCardsView(numberOfPendingCards: getNumberOfPendingTerms(of: box),
                            theme: box.theme, box: $box)
            Section {
                ForEach(filteredTerms, id: \.self) { term in
                    NavigationLink(destination: TermEditorView(box: $box, term: term.value ?? "", meaning: term.meaning ?? "", editorMode: true)) {
                        Text(term.value ?? "Unknown")
                            .padding(.vertical, 8)
                            .fontWeight(.bold)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    box.removeFromTerms(term)
                                } label: {
                                    Image(systemName: "trash")
                                }
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
    }
    
    func getNumberOfPendingTerms(of box: Box) -> Int {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }
            
            return nextReview <= today
        }
        
        return filteredTerms.count == 0 ? 0 : filteredTerms.count
    }
}

struct BoxView_Previews: PreviewProvider {
    
    @State static var box: Box = {
        let box = Box(context: CoreDataStack.inMemory.managedContext)
        box.name = "Box 1"
        box.rawTheme = 1
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
        term2.rawSRS = 1
        term2.lastReview = Calendar.current.date(byAdding: .day, value: -1,to: Date())
        
        
        let term3 = Term(context: CoreDataStack.inMemory.managedContext)
        term3.value = "Term 3"
        
        return [term1, term2, term3]
    }()
    
    
    static var previews: some View {
        NavigationStack {
            BoxView(viewModel: BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext),box: BoxView_Previews.box)
        }
    }
}
