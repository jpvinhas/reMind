//
//  BoxEditorViewModel.swift
//  reMind
//
//  Created by João Pedro Borges on 25/01/24.
//
import Foundation
import CoreData

class EditorViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var keywords: String = ""
    @Published var description: String = ""
    @Published var theme: Int = 0

    @Published var viewContext: NSManagedObjectContext
    
    @Published var viewModel: BoxViewModel
    
    @Published var box: Box?
    

    init(viewModel: BoxViewModel, box: Box?) {
        self.viewModel = viewModel
        self.viewContext = viewModel.viewContext
        self.box = box
        self.name = box?.name ?? ""
        self.theme = Int(box?.rawTheme ?? 0)
        self.keywords = box?.keywords ?? ""
    }

    func saveNewBox(){
        let newBox = Box(context: viewContext)
        newBox.name = name
        newBox.creationDate = Date()
        newBox.keywords = keywords
        newBox.rawTheme = Int16(theme)
        
        //viewModel.boxes.append(newBox)
        try? viewModel.viewContext.save()
        viewModel.updateBoxes()
    }
    func removeBox() {
        box?.destroy()
        
        try? viewModel.viewContext.save()
        viewModel.updateBoxes()
   }
    func editBox(){
        print(name)
        box?.name = name
        box?.keywords = keywords
        box?.rawTheme = Int16(theme)
        
        try? viewModel.viewContext.save()
        viewModel.updateBoxes()
    }
    
}
