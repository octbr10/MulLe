//
//  ViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController{
               
    @IBOutlet weak var tableView:UITableView!
    
    var arrayOfItems:[Item] = [Item]()
    let cellIdentifier: String = "cell"
    var numberOfRecords: Int = 10
    var no = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
         
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        //numberOfRecords += 1
        //print(String(numberOfRecords))
        //no.insert(numberOfRecords, at:0)
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfItems = APIClient().getData()
        print(arrayOfItems)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomTableViewCell {
            cell.confgureCell(item: arrayOfItems[indexPath.row])
            return cell
        }
        
        return UITableViewCell()

    }
    
}

