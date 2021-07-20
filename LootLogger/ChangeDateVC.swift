//
//  ChangeDateVC.swift
//  LootLogger
//
//  Created by Riccardo Carlotto on 08/07/2021.
//

import UIKit

class ChangeDateVC: UIViewController {
    var item: Item!
    
    @IBOutlet var datePicker: UIDatePicker!
    
    @IBAction func dateDidChange(_ sender: UIDatePicker) {
        sender.date = datePicker.date
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        datePicker.date = item.dateCreated
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
    
    
    
}
