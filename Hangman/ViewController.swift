//
//  ViewController.swift
//  Hangman
//
//  Created by Paul Krenn on 25.11.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var groupeName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func createGroupe(_ sender: Any) {
        if(groupeName.text == nil || groupeName.text == ""){
            return
        }
        UserDefaults.standard.set(groupeName.text!, forKey: "currentGroup");
        
        let db = Database.init();
        
        db.isAlreadyThere(groupeName: groupeName.text!){object in
            if(object != true){
                 db.newGroup(groupName: self.groupeName.text!);
            }
        }
        
        
        db.getWord(){ object in
            if(object == ""){
                self.performSegue(withIdentifier: "newWord", sender: nil);
            }else{
                self.performSegue(withIdentifier: "guessWord", sender: nil);
            }
            
        }
        
        
        
    }
    
}

