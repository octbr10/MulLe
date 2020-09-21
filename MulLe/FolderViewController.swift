//
//  FolderViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 04.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import Foundation
import AMPopTip

class FolderViewController: UIViewController {
    
    var folderManager: FolderManager?
    let cellIdentifier: String = "CellForFolder"
    
    let tipCreateFolder = PopTip()
    let tipGoToFolder = PopTip()

    
    override func viewWillAppear(_ animated: Bool) {
        folderManager?.fetchFolders()
        self.tableView.reloadData()
        print("folderViewController viewWillAppear")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard

        // 첫 로딩 테스트를 위해 초기화 하는 부분
        userDefaults.set(false, forKey: "onboardingComplete")
        userDefaults.set(false, forKey: "tipCreateFolderTabbed")
        userDefaults.set(false, forKey: "tipGoToFolderTabbed")
        userDefaults.set(false, forKey: "tipSpeechLanguageTabbed")
        userDefaults.set(false, forKey: "tipNewRecordTabbed")
        userDefaults.synchronize()


        navigationItem.leftBarButtonItem = editButtonItem

        folderManager = FolderManager()

        if isKeyPresentInUserDefaults(key: "speechLanguage") != true {
            UserDefaults.standard.set("de-DE", forKey: "speechLanguage")
            print("German is set as default speechLanguage. viewDidLoad FolderViewController")
        }
        
        print("folderview did load")
        
        
        if userDefaults.bool(forKey: "tipCreateFolderTabbed") == false {
            print("tipCreateFolderTabbed: ", userDefaults.bool(forKey: "tipCreateFolderTabbed"))

            tipCreateFolder.bubbleColor = UIColor.red.withAlphaComponent(0.8)
            tipCreateFolder.shouldDismissOnTapOutside = false
            tipCreateFolder.show(text: "Create a folder", direction: .down, maxWidth: 200, in: view, from: CGRect(x: view.frame.width - 28, y: self.navigationController!.navigationBar.frame.height, width: 1, height: self.navigationController!.navigationBar.frame.height))
            
        }
        
    }

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addFolder(_ sender: UIBarButtonItem) {
        
        tipCreateFolder.hide()
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "tipCreateFolderTabbed")
        userDefaults.synchronize()
        print("tipCreateFolderTabbed: ", userDefaults.bool(forKey: "tipCreateFolderTabbed"))
        
       
        let alertController = UIAlertController(title: "New Forder", message: "Please input a folder name.", preferredStyle: .alert)
        alertController.addTextField {(UITextField) in UITextField.placeholder = "Folder Name for Voice Recordings"}
        
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            let textField = alertController.textFields![0]
            if let newFolderName = textField.text, newFolderName != "" {
                
               createFolder(folderName: newFolderName)
               self.folderManager?.fetchFolders()
               self.tableView.reloadData()
                
                if userDefaults.bool(forKey: "tipGoToFolderTabbed") == false {
                    self.tipGoToFolder.bubbleColor = UIColor.orange.withAlphaComponent(0.8)
                    self.tipGoToFolder.shouldDismissOnTapOutside = false
                    self.tipGoToFolder.show(text: "Tab a folder", direction: .up, maxWidth: 200, in: self.view, from: self.tableView.frame.offsetBy(dx: -50, dy: 35))
                      
                }

                
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
        // Pass the selected object to the new view controller
        
        guard let recordingViewController: RecordingViewController = segue.destination as? RecordingViewController else {
            return
        }
        
        guard let cell: UITableViewCell = sender as? UITableViewCell else {
            return
        }
        
        recordingViewController.titleText = cell.textLabel?.text
        
        tipGoToFolder.hide()
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "tipGoToFolderTabbed")
        userDefaults.synchronize()
        print("tipGoToFolderTabbed: ", userDefaults.bool(forKey: "tipGoToFolderTabbed"))
        
    }

    // Edit Toggle
    override func setEditing(_ editing: Bool, animated: Bool) {
        // Takes care of toggling the button's title.
        super.setEditing(editing, animated: true)

        // Toggle table view editing.
        tableView.setEditing(editing, animated: true)
        tableView.allowsSelectionDuringEditing = true
        print("tableView.isEditing: ", tableView.isEditing )
        
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
                
                let alertController = UIAlertController(title: "Warning", message: "Audio files in the folder will be deleted too.", preferredStyle: .alert)
                
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
            
            self.folderManager?.fetchFolders()
            self.tableView.reloadData()
            
        }
    }
    
        
}

