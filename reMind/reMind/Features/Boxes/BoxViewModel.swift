//
//  BoxViewModel.swift
//  reMind
//
//  Created by Pedro Sousa on 17/07/23.
//

import Foundation
import CoreData

class BoxViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var keywords: String = ""
    @Published var description: String = ""
    @Published var theme: Int = 0

    @Published var viewContext: NSManagedObjectContext
    deinit {
        try? viewContext.save()
        updateBoxes()
    }
    
    @Published var boxes: [Box] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.boxes = Box.all().sorted(by: { $0.creationDate ?? Date() > $1.creationDate ?? Date() })
    }
    func updateBoxes(){
        self.boxes = Box.all().sorted(by: { $0.creationDate ?? Date() > $1.creationDate ?? Date() })
        self.objectWillChange.send()
    }

    func getNumberOfPendingTerms(of box: Box) -> String {
        let term = box.terms as? Set<Term> ?? []
        let today = Date()
        let filteredTerms = term.filter { term in
            let srs = Int(term.rawSRS)
            guard let lastReview = term.lastReview,
                  let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
            else { return false }

            return nextReview <= today
        }

        return filteredTerms.count == 0 ? "" : "\(filteredTerms.count)"
    }
    
}
