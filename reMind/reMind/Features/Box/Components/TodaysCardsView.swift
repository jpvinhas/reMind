//
//  TodaysCardsView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct TodaysCardsView: View {
    @ObservedObject var viewModel: BoxViewModel
    var box: Box
    @State private var isSwippedTime: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Cards")
                .font(.title)
                .fontWeight(.semibold)
            Text("\(box.numberOfPendingTerms) cards to review")
                .font(.title3)
            
            Button(action: {
                if box.numberOfPendingTerms > 0 {
                    print("swippe time!")
                    isSwippedTime.toggle()
                } else {
                    showAlert.toggle()
                }
            }, label: {
                Text("Start Swipping")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(reColorButtonStyle(box.theme))
            .padding(.top, 10)
        }
        .padding(.vertical, 16)
        .fullScreenCover(isPresented: $isSwippedTime, onDismiss: {isSwippedTime = false}){
            SwipperView(review: swipperReview(box: box))
                .onDisappear {
                    viewModel.updateBoxes()
                }
                .onAppear {
                    viewModel.updateBoxes()
                }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("No Cards"),
                message: Text("There are no pending cards to review."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onDisappear {
            viewModel.updateBoxes()
        }
    }
    func swipperReview(box: Box) -> SwipeReview{
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        var swipperReview = SwipeReview()
        swipperReview.termsToReview = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }
        swipperReview.termsReviewed = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview > today
        }
        return swipperReview
    }
}

struct TodaysCardsView_Previews: PreviewProvider {
    static let viewModel: BoxViewModel = {
        let box1 = Box(context: CoreDataStack.inMemory.managedContext)
        box1.creationDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())
        box1.name = "Box 1"
        box1.rawTheme = 0

        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "term of box 1"
        term.meaning = "meaning of box 1"
        term.rawSRS = 0
        term.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        let term2 = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "term2 of box 1"
        term.meaning = "meaning2 of box 1"
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
    @State static var box: Box = Box(context: viewModel.viewContext)
    static var previews: some View {
        TodaysCardsView(viewModel: viewModel, box: box)
        
        .padding()
    }
}
