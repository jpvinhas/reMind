//
//  ContentView.swift
//  reMind
//
//  Created by Pedro Sousa on 23/06/23.
//

import SwiftUI

struct BoxesView: View {
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 140), spacing: 20),
        GridItem(.adaptive(minimum: 140), spacing: 20)
    ]
    
    @ObservedObject var viewModel: BoxViewModel
    @State private var isCreatingNewBox: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.boxes) { box in
                    NavigationLink(destination: BoxView(viewModel: viewModel, box: box)) {
                       BoxCardView(viewModel: viewModel, box: box)
                            .reBadge(viewModel.getNumberOfPendingTerms(of: box))
                    }
                }
            }
            .padding(40)
        }
        .padding(-20)
        .navigationTitle("Boxes")
        .background(reBackground())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isCreatingNewBox.toggle()
                    viewModel.updateBoxes()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isCreatingNewBox) {
            BoxEditorView(editorViewModel: EditorViewModel(viewModel: viewModel, box: nil))
        }
        .onAppear {
            viewModel.updateBoxes()
        }
    }
}

struct BoxesView_Previews: PreviewProvider {

    static let viewModel: BoxViewModel = {
        let viewModel = BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext)
        return viewModel
    }()
    
    static var previews: some View {
        NavigationStack {
            BoxesView(viewModel: BoxesView_Previews.viewModel)
        }
    }
}
