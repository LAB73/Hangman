//
//  FinishedController.swift
//  Hangman
//
//  Created by Paul Krenn on 27.11.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class FinishedController: UIViewController {

    @IBOutlet weak var dasWort: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Database.init();
        
        db.getWord(){ object in
            self.dasWort.text = self.dasWort.text! + " " + object;

            db.setWord(hangmanWord: "");
            db.setGuessed(guessedWord: "");
            db.resetFailedAttempts();
        }
        
        
        
        
        
    }
    @IBAction func buttonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toStart", sender: nil);
    }
    
}
