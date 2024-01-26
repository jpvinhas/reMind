//
//  SwipperReportView.swift
//  reMind
//
//  Created by João Pedro Borges on 25/01/24.
//

import SwiftUI

struct SwipperReportView: View {
    @Binding var review: SwipeReview
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 5){
                TermsReviewedLabel(numberOfTerms:review.allTerms, numberOfReviewedTerms: review.termsReviewed.count)
                TermsReviewedList(terms: review.termsReviewed)
                .background(reBackground())
                
                Spacer()
                
                Button(action: {
                    print("Closed Report View")
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Close Report")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(reButtonStyle())
            }
            .padding()
            .background(reBackground())
            .navigationTitle("Swipper Report")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SwipperReportView_Preview: PreviewProvider {
    @State static var review: SwipeReview = SwipeReview(termsToReview: [], termsReviewed: [])
    static var previews: some View {
        SwipperReportView(review: $review)
    }
}
