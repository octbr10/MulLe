//
//  CustomTableViewCell.swift
//  MulLe
//
//  Created by Jeeyoung Park on 15.07.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit

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
    
    func confgureCell(item:Item) {
        audioIndexLabel.text = String(item.audioIndex)
        audioTitleText.text = item.audioTitle
    }
}
