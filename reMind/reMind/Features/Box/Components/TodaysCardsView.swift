//
//  TodaysCardsView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct TodaysCardsView: View {
    @State var numberOfPendingCards: Int
    @State var theme: reTheme
    @Binding var box: Box
    @State private var isSwippedTime: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Cards")
                .font(.title)
                .fontWeight(.semibold)
            Text("\(numberOfPendingCards) cards to review")
                .font(.title3)
            
            Button(action: {
                if numberOfPendingCards > 0 {
                    print("swippe time!")
                    isSwippedTime.toggle()
                } else {
                    showAlert.toggle()
                }
            }, label: {
                Text("Start Swipping")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(reColorButtonStyle(theme))
            .padding(.top, 10)
        }
        .padding(.vertical, 16)
        .fullScreenCover(isPresented: $isSwippedTime, onDismiss: {isSwippedTime = false}){
            SwipperView(review: swipperReview(box: box))
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("No Cards"),
                message: Text("There are no pending cards to review."),
                dismissButton: .default(Text("OK"))
            )
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
        TodaysCardsView(numberOfPendingCards: 10, theme: .mauve, box: $box)
            .padding()
    }
}
