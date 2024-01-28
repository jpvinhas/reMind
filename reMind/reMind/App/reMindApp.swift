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
    let viewModel: BoxViewModel = BoxViewModel(viewContext: CoreDataStack.inMemory.managedContext)
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BoxesView(viewModel: viewModel)
                .onDisappear {
                    CoreDataStack.inMemory.saveContext()
                }
            }
        }
    }
}
