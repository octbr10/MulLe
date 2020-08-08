//
//  LocaleViewController.swift
//  MulLe
//
//  Created by Jeeyoung Park on 07.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import UIKit
import Speech

class LocaleViewController: UIViewController {

    var availableLanguages: [SupportedLanguage] = []
//    var lastSelection: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSupportedLanguage()

        

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func dismissClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchSupportedLanguage() {
      
        //print("SFSpeechRecognizer.supportedLocales(): ", SFSpeechRecognizer.supportedLocales())
          for locale in SFSpeechRecognizer.supportedLocales() {
              let language = SupportedLanguage (
                code: locale.languageCode ?? "en",
                name: Locale.init(identifier: "en").localizedString(forIdentifier: locale.identifier)!
              )
              availableLanguages.append(language)
            availableLanguages.sort(by: { $0.name.compare($1.name) == .orderedAscending})
            print(Locale.init(identifier: "en").localizedString(forIdentifier: locale.identifier)! as Any)
          }
       // print("availableLanguages: ", availableLanguages)
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if self.lastSelection != nil {
//            self.tableView.cellForRow(at: self.lastSelection as IndexPath)?.accessoryType = .none
//        }
//
//        self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
//
//        self.lastSelection = indexPath
//
//        self.tableView.deselectRow(at: indexPath as IndexPath, animated: true)
//    }


}



extension LocaleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return availableLanguages.count
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "localeCell", for: indexPath)
        cell.textLabel?.text = availableLanguages[indexPath.row].name
        
        return cell
            
    }
    
    // checkmark when a row is selected/deselectedß
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
    }

}
