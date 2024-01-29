//
//  BoxCardView.swift
//  reMind
//
//  Created by Pedro Sousa on 27/06/23.
//

import SwiftUI

struct BoxCardView: View {
    @ObservedObject var viewModel: BoxViewModel
    var box: Box

    var body: some View {
        VStack(alignment: .leading) {
            Text(box.name ?? "")
                .font(.title3)
                .fontWeight(.bold)
            
            Label("\(box.numberOfTerms) terms", systemImage: "doc.plaintext.fill")
                .padding(8)
                .background(Palette.reBlack.render.opacity(0.2))
                .cornerRadius(10)
        }
        .foregroundColor(Palette.reBlack.render)
        .padding(16)
        .frame(width: 165, alignment: .leading)
        .background(box.theme.render)
        .cornerRadius(10)
    }
}

struct BoxCardView_Previews: PreviewProvider {
    static let viewModel: BoxViewModel = {
        let box1 = Box(context: CoreDataStack.inMemory.managedContext)
        box1.creationDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
        box1.name = "Box 1"
        box1.rawTheme = 0

        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "term of box 1"
        term.meaning = "meaning of box 1"
        term.rawSRS = 1
        term.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        box1.addToTerms(term)

        let box2 = Box(context: CoreDataStack.inMemory.managedContext)
        box2.name = "Box 2"
        box2.rawTheme = 1

        let box3 = Box(context: CoreDataStack.inMemory.managedContext)
        box3.name = "Box 3"
        box3.rawTheme = 2

        return BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext)
    }()
    static var previews: some View {
        BoxCardView(viewModel: viewModel, box: Box(context: CoreDataStack.inMemory.managedContext)
)
    }
}
