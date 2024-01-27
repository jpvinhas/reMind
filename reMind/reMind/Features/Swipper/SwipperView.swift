//
//  SwipperView.swift
//  reMind
//
//  Created by Pedro Sousa on 03/07/23.
//

import SwiftUI

struct SwipperView: View {
    
    @State var review: SwipeReview
    @State private var direction: SwipperDirection = .none
    @State private var finalDirection: SwipperDirection = .none
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var translation: CGSize = .zero

    @State private var SwippedFinished: Bool = false
    var body: some View {
        VStack {
            SwipperLabel(direction: $direction)
                .padding()

            Spacer()

            SwipperCard(direction: $direction,
                        finalDirection: $finalDirection, frontContent: {
                Text(review.termsToReview.first?.value ?? "Term")
            }, backContent: {
                Text("Meaning")
            }, theme: review.termsToReview.first?.theme ?? .lavender)
            .gesture(
                LongPressGesture()
                    .onEnded {_ in
                        updateReview(forDirection: finalDirection)
                    }
            )

            Spacer()

            Button(action: {
                print("finish review")
                SwippedFinished.toggle()
            }, label: {
                Text("Finish Review")
                    .frame(maxWidth: .infinity, alignment: .center)
            })
            .buttonStyle(reButtonStyle())
            .padding(.bottom, 30)
                
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(reBackground())
        .navigationTitle("\(review.termsToReview.count) terms left")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $SwippedFinished, onDismiss: {
            presentationMode.wrappedValue.dismiss()
        }){
            SwipperReportView(review: $review)
        }
        
    }

    private func updateReview(forDirection direction: SwipperDirection) {
        guard let termReviewed = review.termsToReview.first else {
            return
        }
        termReviewed.rawSRS += (direction == .left) ? 1 : -1
        termReviewed.lastReview = Date()
        termReviewed.remembered = (direction == .left) ? true : false
        
        review.termsReviewed.append(termReviewed)
        review.termsToReview.removeFirst()
        
        self.finalDirection = direction
        if review.termsToReview.count == 0 {SwippedFinished.toggle()}
        
        print(review.termsReviewed.last?.rawSRS ?? 4)
    }
}

struct SwipperView_Previews: PreviewProvider {
    static let term: Term = {
        let term = Term(context: CoreDataStack.inMemory.managedContext)
        term.value = "Terme"
        term.meaning = "Meaning"
        term.rawSRS = 0
        term.rawTheme = 2
        
        return term
    }()
    static var previews: some View {
        NavigationStack {
            SwipperView(review: SwipeReview(termsToReview: [
                term
            ]))
        }
    }
}
