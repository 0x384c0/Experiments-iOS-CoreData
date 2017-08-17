//
//  ViewController.swift
//  coreDataTest
//
//  Created by 0x384c0 on 8/17/17.
//  Copyright © 2017 Spalmalo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func load(_ sender: Any) {
         let languages = DatabaseController.getLanguages()
        if languages.count == 0 {print("NO DATA")}
        for language in languages{
            print(language.lang!)
            for string in language.localizedStrings?.allObjects as! [LocalizedString]{
                print(string.stringKey!)
                print(string.stringValue!)
            }
        }
    }
    
    @IBAction func drop(_ sender: Any) {
        DatabaseController.removeLanguages()
    }
    @IBAction func save(_ sender: Any) {
        let language = DatabaseController.newLanguage()
        language.lang = "date: \(Date())"
        for i in 0...3{
            let string = DatabaseController.newLocalizedString()
            string.stringKey = "KEY_\(i)"
            string.stringValue = "VALUE_\(i)"
            language.addToLocalizedStrings(string)
        }
        DatabaseController.saveContext()
    }
    
}

