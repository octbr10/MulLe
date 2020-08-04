//
//  FolderViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 04.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import Foundation

class FolderViewController: UIViewController {
        
    var folderArray: [String] = []
    
    let cellIdentifier: String = "CellForFolder"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Forder", message: "Please input a folder name.", preferredStyle: .alert)
        alertController.addTextField {(UITextField) in UITextField.placeholder = "Folder Name for Voice Recordings"}
        
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = alertController.textFields![0]
            if let newFolderName = textField.text, newFolderName != "" {
                self.folderArray.append(newFolderName)
                print("self.folderArray: ", self.folderArray)
                let indexPath = IndexPath(row: self.folderArray.count - 1, section: 0)
                print("folderArray.count : ", self.folderArray.count)
                print("indexPath.row: ", indexPath.row)
                
                createFolder(folderName: newFolderName)
                self.tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.automatic)

                }
            }
                        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { _ in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Do any additional setup after loading the view.
        folderArray = fetchFolders()
        print("folderArray: ", folderArray)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        guard let recordingViewController: RecordingViewController = segue.destination as? RecordingViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        
        recordingViewController.titleText = cell.textLabel?.text
        
    }
    
 

}

extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell = tableView.dequeueReusableCell(withIdentifier: "CellForFolder", for: indexPath)
        
        myCell.textLabel?.text = folderArray[indexPath.row]
        print(folderArray[indexPath.row])
        
        return myCell
    }
    
    // delete by swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // delete sequence is importanct. array should be deleted earlier than table cell
            let folderNameToDelete = folderArray[indexPath.row] // this should be done before array changes
            folderArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic) // delete from Table 삭제
            deleteFolder(folderName: folderNameToDelete)// delete from fileDocument
            print("indexPath.row : ", indexPath.row)
            
            }
        }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
       
    }
    
  
    
    
        
    
}

