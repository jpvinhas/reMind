//
//  Term+CoreDataProperties.swift
//  reMind
//
//  Created by Pedro Sousa on 25/09/23.
//
//

import Foundation
import CoreData

@objc(Term)
public final class Term: NSManagedObject {
    @objc dynamic var remembered: Bool = false
}

extension Term {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Term> {
        return NSFetchRequest<Term>(entityName: "Term")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var lastReview: Date?
    @NSManaged public var meaning: String?
    @NSManaged public var rawSRS: Int16
    @NSManaged public var rawTheme: Int16
    @NSManaged public var value: String?
    @NSManaged public var boxID: Box?


}

extension Term: CoreDataModel {
    var srs: SpacedRepetitionSystem {
        return SpacedRepetitionSystem(rawValue: Int(rawSRS)) ?? SpacedRepetitionSystem.first
    }

    var theme: reTheme {
        return reTheme(rawValue: Int(self.rawTheme)) ?? reTheme.lavender
    }
    var nextReview : Date {
        let srs = Int(self.rawSRS)
        guard let lastReview = self.lastReview,
              let nextReview = Calendar.current.date(byAdding: .day, value: srs, to: lastReview)
        else { return Date() }
        return nextReview
    }
}

enum SpacedRepetitionSystem: Int {
    case none = 0
    case first = 1
    case second = 2
    case third = 3
    case fourth = 5
    case fifth = 8
    case sixth = 13
    case seventh = 21
}
extension Term: Identifiable {
    public var id: UUID {
        return identifier ?? UUID()
    }
}
