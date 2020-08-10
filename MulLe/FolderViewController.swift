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
        
//    var folderArray: [String] = []
//    var fileCountArray: [String] = []
    
    var folderManager: FolderManager?
    
    let cellIdentifier: String = "CellForFolder"
    
    override func viewWillAppear(_ animated: Bool) {
        folderManager?.fetchFolders()
        self.tableView.reloadData()
        print("folderViewController viewWillAppear")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = editButtonItem

        folderManager = FolderManager()

        if isKeyPresentInUserDefaults(key: "speechLanguage") != true {
            UserDefaults.standard.set("de-DE", forKey: "speechLanguage")
            print("German is set as default speechLanguage. viewDidLoad FolderViewController")
        }
        
        print("folderview did load")
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New Forder", message: "Please input a folder name.", preferredStyle: .alert)
        alertController.addTextField {(UITextField) in UITextField.placeholder = "Folder Name for Voice Recordings"}
        
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = alertController.textFields![0]
            if let newFolderName = textField.text, newFolderName != "" {
                
               createFolder(folderName: newFolderName)
               self.folderManager?.fetchFolders()
               self.tableView.reloadData()
                }
            }
                        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { _ in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
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

    // Edit Toggle
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
        tableView.allowsSelectionDuringEditing = true
        print("tableView.isEditing: ", tableView.isEditing )
        self.tableView.reloadData()
        
    }
    
}

extension FolderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderManager?.folders.count ?? 0
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let myCell = tableView.dequeueReusableCell(withIdentifier: "CellForFolder", for: indexPath)
        
        if tableView.isEditing {
            myCell.textLabel?.text = folderManager?.folders[indexPath.row].folderName
            myCell.detailTextLabel?.text = String(describing: folderManager!.folders[indexPath.row].fileCount)
        } else {
               myCell.textLabel?.text = folderManager?.folders[indexPath.row].folderName
               myCell.detailTextLabel?.text = String(describing: folderManager!.folders[indexPath.row].fileCount)
        }
        
        return myCell

    }
    
    // segue disable when edit mode
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    // edit mode folder name change
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if tableView.isEditing {
                print("clicked")
        
        let alertController = UIAlertController(title: "Change Folder Name", message: "Please input a new folder name.", preferredStyle: .alert)
        alertController.addTextField {(UITextField) in UITextField.text = self.folderManager?.folders[indexPath.row].folderName}
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = alertController.textFields![0]
            if let newFolderName = textField.text, newFolderName != "" {
                
                var oldFolderURL = self.folderManager?.folders[indexPath.row].folderURL
                var rv = URLResourceValues()
                rv.name = textField.text
                try? oldFolderURL?.setResourceValues(rv)
                
               self.folderManager?.fetchFolders()
               self.tableView.reloadData()
                }
            }
                        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { _ in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        

            }
    }
    
    
    
    
    // delete by swipe
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            // delete sequence is importanct. array should be deleted earlier than table cell
            let folderNameToDelete = (folderManager?.folders[indexPath.row].folderName)!
            
            if folderManager?.folders[indexPath.row].fileCount != 0 {
                
                let alertController = UIAlertController(title: "Warning", message: "Recording files in this folder will be deleted too.", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
                    
                    self.folderManager?.folders.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic) // delete from Table 삭제
                    deleteFolder(folderName: folderNameToDelete)// delete from fileDocument
                    print("indexPath.row : ", indexPath.row)
                    
                }
                
                let cancelAction = UIAlertAction(title:"Cancel", style: .cancel) { _ in
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                
                self.folderManager?.folders.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic) // delete from Table 삭제
                deleteFolder(folderName: folderNameToDelete)// delete from fileDocument
                print("indexPath.row : ", indexPath.row)
            }
            
        }
    }
    
   
//    // cell move
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//       
//    }
        
}

