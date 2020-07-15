//
//  ViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    let cellIdentifier: String = "cell"
  
    var numberOfRecords: Int = 0
    var no: [String] = []
         
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        numberOfRecords += 1
        print(String(numberOfRecords))
        no.append(String(numberOfRecords))
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        
        let text: String = no[indexPath.row]
        cell.textLabel?.text = text
        
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

