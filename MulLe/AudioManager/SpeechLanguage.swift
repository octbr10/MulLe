//
//  SpeechLanguage.swift
//  MulLe
//
//  Created by Jeeyoung Park on 08.08.20.
//  Copyright © 2020 Jeeyoung Park. All rights reserved.
//

import Foundation
import Speech

class SpeechLanguage: NSObject {
    
    var availableLanguages: [SupportedLanguage] = []
    
    override init() {
        super.init()
        fetchLanguage()
    }
    
    func fetchLanguage() {

        //print("SFSpeechRecognizer.supportedLocales()", SFSpeechRecognizer.supportedLocales())
        
        let lang = Locale.init(identifier: "da-DK")
        let enLocale = Locale.init(identifier: "en")
        print(enLocale.localizedString(forIdentifier: lang.identifier)!)
    
        
//
//        for locale in SFSpeechRecognizer.supportedLocales() {
//            let language = SupportedLanguage (
//              code: locale.identifier ,
//              name: Locale.init(identifier: "en").localizedString(forIdentifier: locale.identifier)!
//            )
//          availableLanguages.append(language)
//          availableLanguages.sort(by: { $0.name.compare($1.name) == .orderedAscending})
//          //print(Locale.init(identifier: "en").localizedString(forIdentifier: locale.identifier)! as Any)
//        }

    }
   
}


