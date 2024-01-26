//
//  TermsReviewedLabel.swift
//  reMind
//
//  Created by João Pedro Borges on 25/01/24.
//

import SwiftUI
struct TermsReviewedLabel: View {
    var numberOfTerms: Int
    var numberOfReviewedTerms: Int
    var body: some View {
        Text("\(numberOfReviewedTerms)/\(numberOfTerms) terms were reviewed")
            .fontWeight(.bold)
    }
}

struct TermsReviewedLabel_Preview: PreviewProvider {
    static var previews: some View {
        TermsReviewedLabel(numberOfTerms: 10,
                           numberOfReviewedTerms: 5)
    }
}
