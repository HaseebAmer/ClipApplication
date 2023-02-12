//
//  MainWindowController.swift
//  todolist
//
//  Created by Haseeb Amer on 3/2/2023.
//

import Cocoa
import Firebase
import FirebaseFirestore
class MainWindowController: NSWindowController {
    
    var signUpVCref : signUpVC?
    var loginVCref : loginVC?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        loginVCref = contentViewController as? loginVC
    }

    func signUpVC() {
        
        if signUpVCref == nil {
            signUpVCref = storyboard?.instantiateController(withIdentifier: "signUp") as? signUpVC
        }
        
        window?.contentView = signUpVCref?.view
    }
    
    func mainContentVC() {
        if let mainVC = storyboard?.instantiateController(withIdentifier: "mainVC") as? ViewController {
            window?.contentView = mainVC.view
        }
    }

    func loginVC() {
        window?.contentView = loginVCref?.view
    }
}

