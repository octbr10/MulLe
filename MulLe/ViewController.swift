//
//  ViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
               
    @IBOutlet weak var tableView:UITableView!
       
    let cellIdentifier: String = "cell"
    var numberOfRecords: Int = 10
    var no = Array(1...10)
         
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        numberOfRecords += 1
        print(String(numberOfRecords))
        no.append(numberOfRecords)
        self.tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomTableViewCell
        
        let text: String = String(no[indexPath.row])
        cell.recordLabel.text = text

        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      }


}

