//
//  reMindApp.swift
//  reMind
//
//  Created by Pedro Sousa on 23/06/23.
//

import SwiftUI
import CoreData

@main
struct reMindApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BoxesView(viewModel: BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext))
                .onDisappear {
                    CoreDataStack.shared.saveContext()
                }
            }
        }
    }
}
