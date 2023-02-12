//
//  testie.swift
//  todolist
//
//  Created by Haseeb Amer on 4/2/2023.
//

import Cocoa

class testie: NSViewController {

    @IBOutlet weak var isthisworking: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    

    @IBAction func workingfully(_ sender: Any) {
        print("hellllooooo")
    }
    
}
