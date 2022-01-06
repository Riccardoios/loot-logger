//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 10/06/2021.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    let notification = Notification(name: Notification.Name("updateNow"))
    let notificationCenter = NotificationCenter.default
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.backButtonTitle = ""
        
        
        notificationCenter.addObserver(self, selector: #selector(updateAll), name: Notification.Name("updateNow"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for improved performance set the cell height this way
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // if the trigged segue is the "showItem" segue
        
        switch segue.identifier {
        case "showItem":
            //figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // get the item associated with this row and pass it along
                let item = ItemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    @objc func updateAll() {
            tableView.reloadData()
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // Set the text on the cell with the description of the item
        // That is on the nth index of items, where n = rows this cell
        // Will appear in on the tableview
        
        let item = ItemStore.allItems[indexPath.row]
        
        //configure the cell with the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        
        let redOrGreen = item.valueInDollars >= 50 ? UIColor.red : UIColor.green
        cell.valueLabel.textColor = redOrGreen
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //if the table view is asking to commit a delete command..
        if editingStyle == .delete {
            let item = ItemStore.allItems[indexPath.row]
            
            //remove the item from the store
            itemStore.removeItem(item)
            
            //remove the item image from the store
            imageStore.deleteImage(forKey: item.itemKey)
            
            //also remove that row from the table view with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //update the model
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
            let newItem = itemStore.createItem()
       // Figure out where that item is in the array
        if let index = ItemStore.allItems.firstIndex(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
        // insert this new row into the table
                tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        notificationCenter.post(notification)
    }
    
    
    
}
