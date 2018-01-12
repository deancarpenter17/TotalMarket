//
//  DataStore.swift
//  TotalMarket
//
//  Created by Dean Carpenter on 1/11/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class DataStore {
    static let shared = DataStore()
    
    private var ref: DatabaseReference!
    
    private var users: [User]
    
    private init() {
        ref = Database.database().reference()
        users = [User]()
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func userCount() -> Int {
        return users.count
    }
    
    func getUser(index: Int) -> User {
        return users[index]
    }
    
    func convertNSDate(date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.long
        formatter.timeStyle = .medium
        
        return formatter.string(from: date as Date!)
        
    }
    
    func addUser(user: User) {
        // define array of key/value pairs to store for this person.
        let userRecord = [
            "username": user.username,
            "email": user.email
        ]
        
        // Save to Firebase.
        self.ref.child("users").child(user.username).setValue(userRecord)
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        users.append(user)
    }
    
    func loadUsers() {
        var newUsers = [User]()
        
        // Fetch the data from Firebase and store it in our internal users array.
        ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let users = value {
                // Iterate over the user objects and store in our internal users array.
                for u in users {
                    let username = u.key as! String
                    let user = u.value as! [String:String]
                    let email = user["email"]
                    let newUser = User(username: username,
                                       email: email!)
                    newUsers.append(newUser)
                }
                
                self.users = newUsers
            }
            
            print("\(DataStore.shared.userCount()) users have been loaded from firebase!")
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
