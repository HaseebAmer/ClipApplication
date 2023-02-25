//
//  signUp.swift
//  todolist
//
//  Created by Haseeb Amer on 3/2/2023.
//

import Cocoa
import Firebase

class signUpVC: NSViewController {
    
    private var emailCell = ""
    private var passwordCell = ""
    
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var password: NSTextField!
    @IBOutlet weak var email: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let signUpAttributes = [NSAttributedString.Key.foregroundColor: NSColor.darkGray, NSAttributedString.Key.font : NSFont.systemFont(ofSize: 11)]
        
        email.placeholderAttributedString =
        NSAttributedString(string:"Enter email", attributes:signUpAttributes)
        
        password.placeholderAttributedString =
        NSAttributedString(string:"Enter password", attributes:signUpAttributes)
    }
    
    
    @IBAction func switchtoLogin(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.loginVC()
        }
    }
    
    
    @IBAction func switchLogin(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.loginVC()
        }
    }
    
    
    @IBAction func approvingSignUp(_ sender: Any) {
        emailCell = email.stringValue
        passwordCell = password.stringValue

        self.errorMessage.stringValue = "Loading... "

        Auth.auth().createUser(withEmail: emailCell, password: passwordCell) {result, error in
            if error != nil {
                self.errorMessage.stringValue = error!.localizedDescription
            } else {
                if let mainWC = self.view.window?.windowController as? MainWindowController {
                    mainWC.mainContentVC()
                }
            }
        }
    }
}
