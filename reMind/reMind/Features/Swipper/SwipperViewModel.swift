//
//  SwipperViewModel.swift
//  reMind
//
//  Created by João Pedro Borges on 27/01/24.
//
import Foundation
import CoreData

//class SwipperViewModel: ObservableObject {
//    @Published var boxViewModel: BoxViewModel
//    
//    @Published var review: SwipeReview
//    
//    init(boxViewModel: BoxViewModel, box: Box) {
//        self.boxViewModel = boxViewModel
//        self.review = boxViewModel.swipperReview(box: box)
//    }
//    
//    func updateReview(forDirection direction: SwipperDirection) {
//        guard let termReviewed = review.termsToReview.first else {
//            return
//        }
//        termReviewed.rawSRS += (direction == .left) ? 1 : -1
//        termReviewed.lastReview = Date()
//        termReviewed.remembered = (direction == .left) ? true : false
//        
//        review.termsReviewed.append(termReviewed)
//        review.termsToReview.removeFirst()
//    }
//}
