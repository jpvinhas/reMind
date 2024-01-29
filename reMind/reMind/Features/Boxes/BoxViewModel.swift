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
    func addTestTerms(to context: NSManagedObjectContext){
        let box1 = Box(context: context)
        box1.creationDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        box1.name = "Box 1"
        box1.rawTheme = 0
        
        let box2 = Box(context: context)
        box2.creationDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        box2.name = "Box 2"
        box2.rawTheme = 1

        let box3 = Box(context: context)
        box3.creationDate = Calendar.current.date(byAdding: .day, value: -2, to: Date())
        box3.name = "Box 3"
        box3.rawTheme = 2

        let term = Term(context: context)
        term.value = "term 1"
        term.meaning = "meaning 1"
        term.rawSRS = 1
        term.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        let term2 = Term(context: context)
        term2.value = "term 2"
        term2.meaning = "meaning 2"
        term2.rawSRS = 1
        term2.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        let term3 = Term(context: context)
        term3.value = "term 3"
        term3.meaning = "meaning 3"
        term3.rawSRS = 1
        term3.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        let term4 = Term(context: context)
        term4.value = "term 3"
        term4.meaning = "meaning 3"
        term4.rawSRS = 1
        term4.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        let term5 = Term(context: context)
        term5.value = "term 3"
        term5.meaning = "meaning 3"
        term5.rawSRS = 1
        term5.lastReview = Calendar.current.date(byAdding: .day,
                                                value: -1,
                                                to: Date())!
        box1.addToTerms([term,term2,term3])
        box2.addToTerms(term4)
        box3.addToTerms(term5)
        self.updateBoxes()

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
