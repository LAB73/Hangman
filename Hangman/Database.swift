//
//  Database.swift
//  Hangman
//
//  Created by Paul Krenn on 25.11.18.
//  Copyright © 2018 Paul Krenn. All rights reserved.
//

import Foundation
import Firebase

class Database {
    let db : Firestore;
    var HangmanWord = "";
    init() {
        db = Firestore.firestore();
    }
    
    func newGroup(groupName:String) {
        db.collection("Groups").document(groupName).setData([
            "last-used" : Date.init()
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        
    }
    
    func setWord(hangmanWord : String){
        let currentGroup = UserDefaults.standard.string(forKey: "currentGroup") ?? "";
        db.collection("Groups").document(currentGroup).setData([ "HangmanWord": hangmanWord ], merge: true);
    }
    
    func getWord(completion: @escaping (String) -> ()){
        getAny(lookFor: "HangmanWord") { object in
            completion(object as? String ?? "");
        }
    }
    
    func getGuessedWord(completion: @escaping (String) -> ()) {
        getAny(lookFor: "GuessedWord") { object in
            completion (object as? String ?? "");
        }
    }
    
    func wrongAttempt(completion: @escaping (Bool) -> ()){
        var oldNumber = 0;
        getAny(lookFor: "wrongAttempts") { object in
             oldNumber = object as? Int ?? 0;
            if oldNumber >= 4{
                completion(false)
            }
            else{
                let currentGroup = UserDefaults.standard.string(forKey: "currentGroup") ?? "";
                self.db.collection("Groups").document(currentGroup).setData([ "wrongAttempts": oldNumber + 1 ], merge: true);
                completion(true);
            }
        }
        
        
    }
    
    func getAny(lookFor : String, completion: @escaping (Any) -> ()){
        let currentGroup = UserDefaults.standard.string(forKey: "currentGroup") ?? "";
        var returnValue : Any = (Any).self;
        
        let docRef = db.collection("Groups").document(currentGroup);
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                returnValue = document.data()![lookFor] ?? (Any).self;
                completion(returnValue);
            } else {
                completion((Any).self)
                print("Document does not exist")
            }
        }
        
    }
    
    func resetFailedAttempts(){
        let currentGroup = UserDefaults.standard.string(forKey: "currentGroup") ?? "";
        db.collection("Groups").document(currentGroup).setData([ "wrongAttempts": 0 ], merge: true);
    }
    
    func setGuessed(guessedWord : String){
        let currentGroup = UserDefaults.standard.string(forKey: "currentGroup") ?? "";
        db.collection("Groups").document(currentGroup).setData([ "GuessedWord": guessedWord ], merge: true);
    }
    
    func isAlreadyThere(groupeName:String, completion: @escaping (Bool) -> ()){
        
        
        let docRef = db.collection("Groups").document(groupeName);
        
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                completion (true);
            } else {
                
                completion (false);
            }
        }
    }
    
    func getHangmanWord() -> String {
        return HangmanWord;
    }
    
    
    
}
