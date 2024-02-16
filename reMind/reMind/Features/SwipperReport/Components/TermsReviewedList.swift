//
//  TermsReviwedList.swift
//  reMind
//
//  Created by João Pedro Borges on 25/01/24.
//

import SwiftUI
    
struct TermsReviewedList: View {
    
    var terms: [Term] = []
    
    @State private var selectedCard: Term?

    var body: some View {
        List(terms) { term in
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: term.remembered ? "checkmark.circle" : "x.circle")
                        .foregroundColor(.black)
                    Text(term.value ?? "")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    selectedCard = selectedCard == term ? nil : term
                }
            }
            .listRowBackground(term.remembered ? Palette.success.render : Palette.error.render)

            if selectedCard == term {
                Text((term.meaning ?? term.meaning) ?? "")
                    .foregroundColor(.secondary)
                    .padding()
                    .listRowBackground(
                        term.remembered ? Palette.success.render : Palette.error.render                    )
            }
        }
        .background(reBackground())
        
    }
}
struct TermsReviewedList_Preview: PreviewProvider {
    static var previews: some View {
        TermsReviewedList()
    }
}
