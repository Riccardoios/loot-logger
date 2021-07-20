//
//  ItemStore.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 11/06/2021.
//

import UIKit

class ItemStore {
    
    init() {
        
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print ("error reading the saved items: \(error)")
        }
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        
        
    }
    
    var allItems = [Item]()
    
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("item.plist")
    }()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        try? saveChanges()
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        //get reference to object beign moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //remove item from array
        allItems.remove(at: fromIndex)
        
        //Insert item from array
        allItems.insert(movedItem, at: toIndex)
    }
    
    @objc func saveChanges() throws {
        print ("Saving items to: \(itemArchiveURL)")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print ("items saved")
            
        } catch let encodingError{
            print ("error encoding allItems: \(encodingError)")
            
        }
        
    }
    
    
    
    
    
    
   
    
}
