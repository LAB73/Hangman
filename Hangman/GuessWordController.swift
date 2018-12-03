//
//  GuessWordController.swift
//  Hangman
//
//  Created by Paul Krenn on 27.11.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class GuessWordController: UIViewController {
    @IBOutlet weak var guessingWord: UILabel!
    @IBOutlet weak var inputLetter: UITextField!
    @IBOutlet weak var wrongAttemptsLabel: UILabel!
    
    let db = Database.init();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.getGuessedWord(){ object in
            self.guessingWord.text = object;
        }
        
    }
    
    @IBAction func onlyOneLetter(_ sender: Any) {
        if(inputLetter.text != nil && inputLetter.text!.count > 1){
            let temp = inputLetter.text!.dropFirst().description;
            inputLetter.text = temp;
        }
    }
    
    @IBAction func checkContaining(_ sender: Any) {
        
        if(inputLetter.text == nil){
            return
        }
        let labelValue : String = inputLetter.text!;
        inputLetter.text = "";
        
        db.getWord(){ object in
            
            if(object.contains(labelValue)){
                self.setNewLetters(newLetter: labelValue){object in
                    
                    if(object){
                        self.performSegue(withIdentifier: "finished", sender: sender);
                    }
                }
            
            }else{
                self.db.wrongAttempt(){ ectBool in
                    self.wrongAttemptsLabel.text = self.wrongAttemptsLabel.text! + " " + self.db.failCounter.description;
                    if(!ectBool){
                        self.performSegue(withIdentifier: "finished", sender: sender);
                    }
                }
            }
        }
        
        print("cleared");
       
        
        
    }
    
    func setNewLetters(newLetter: String, completion: @escaping (Bool) -> ()){
       
        db.getWord(){ object in
            var characters: String;
            characters = object;
            
            var counter : Int = 0;
            for char in characters {
                let temp = char.description;
                
                if(temp == newLetter){
                    self.guessingWord.text = self.replace(myString: self.guessingWord.text!, counter, char);
                }
                
                counter = counter + 1;
                
            }
            
            self.db.setGuessed(guessedWord: self.guessingWord.text!);
            
            
            self.db.getWord(){object in
                completion(self.guessingWord.text! == object);
            }
        }
        
        
        
        
    }
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
}
