//
//  login.swift
//  todolist
//
//  Created by Haseeb Amer on 4/2/2023.
//

import Cocoa
import Firebase
import SwiftUI
import AppKit
class loginVC: NSViewController {

    private var emailCell = ""
    private var passwordCell = ""
    

    @IBOutlet weak var forgotPassword: NSButton!
    @IBOutlet weak var errorMessage: NSTextField!
    
    @IBOutlet weak var loginButton: NSButton!
    
    @IBOutlet weak var signUpButton: NSButton!
    @IBOutlet weak var mailCell: NSTextField!
    @IBOutlet weak var passCell: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mailCell.layer?.shadowOpacity = 0
        passCell.layer?.shadowOpacity = 0
        
        let attrList = [NSAttributedString.Key.foregroundColor: NSColor.darkGray,
                        NSAttributedString.Key.font : NSFont.systemFont(ofSize: 11)]

        mailCell.placeholderAttributedString =
        NSAttributedString(string:"Enter email", attributes: attrList)
        
        passCell.placeholderAttributedString =
        NSAttributedString(string:"Enter password",attributes: attrList)


    }
    

    override func viewDidAppear() {
        view.window?.titlebarAppearsTransparent = true
        view.window?.backgroundColor = NSColor.white
        
    }
    
    override func viewWillAppear() {
        view.window?.isOpaque = false
    }
    
    @IBAction func loginApproved(_ sender: Any) {
        emailCell = mailCell?.stringValue ?? ""
        passwordCell = passCell?.stringValue ?? ""
        
        self.errorMessage.stringValue = "Loading..."
        Task {
            await fetchData()
        }
    }
    
    
    @IBAction func signUpSwitch(_ sender: Any) {
        if let mainWC = view.window?.windowController as? MainWindowController {
            mainWC.signUpVC()
        }
    }
}

extension loginVC {
    func fetchData() async {
        Auth.auth().signIn(withEmail: emailCell, password: passwordCell) {result, error in
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
