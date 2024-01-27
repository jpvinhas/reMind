//
//  SwipeReview.swift
//  reMind
//
//  Created by Pedro Sousa on 04/07/23.
//

import Foundation

struct SwipeReview {
    var termsToReview: [Term] = []
    var termsReviewed: [Term] = []
    var allTerms: Int {
        return termsToReview.count + termsReviewed.count
    }
}
