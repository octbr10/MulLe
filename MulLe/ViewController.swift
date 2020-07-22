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
    
    let cellIdentifier: String = "cell"
    var numberOfRecords: Int = 3
    var no = [3, 2, 1]
         
    @IBAction func touchUpAddButton(_ sender: UIButton) {
        
        numberOfRecords += 1
        print(String(numberOfRecords))
        no.insert(numberOfRecords, at:0)
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRecords
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? CustomTableViewCell {
            return cell
        }
        
        return UITableViewCell()

    }
    
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var audioIndexLabel: UILabel!
    @IBOutlet var audioTitleText: UITextField!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        print("Recording Starts")
        print(audioIndexLabel.text ?? 99)
        playButton.isEnabled = false
        recordButton.isEnabled = false
    }
    
}
