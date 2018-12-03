//
//  NewWordController.swift
//  Hangman
//
//  Created by Paul Krenn on 25.11.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class NewWordController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBAction func updateWord(_ sender: Any) {
        if(textField.text == nil || textField.text == ""){
            return
        }
        
        let db = Database.init();
        db.setWord(hangmanWord: textField.text!)
        db.setGuessed(guessedWord: createGuessed(letters: textField.text!.count));
    }
    @IBAction func Back(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "guessedWord");
        performSegue(withIdentifier: "goHome", sender: self);
    }
    
    func createGuessed(letters: Int) -> String{
        var counter = 0;
        var stringsal: String = "";
        while (counter < letters) {
            counter = counter+1;
            stringsal = stringsal + "_";
        }
        return stringsal;
    }
}
