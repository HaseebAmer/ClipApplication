//
//  CustomClass.swift
//  todolist
//
//  Created by Haseeb Amer on 12/1/2023.
//

import Cocoa

class cellStruct: NSTableCellView {

    @IBOutlet weak var timeStamp: NSTextField!
    @IBOutlet weak var copiedItem: NSTextFieldCell!
    @IBOutlet weak var fullText: NSTextField!
    
    var emptyString: String = " "
    var attributedHTML: NSAttributedString = NSAttributedString(string: " ")
    var attributedRTF: NSAttributedString = NSAttributedString(string: " ")
    var plaintext: NSAttributedString = NSAttributedString(string: " ")


    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        self.layer?.cornerRadius = 10
        
    }
    
    @IBAction func copyButton(_ sender: Any) {
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        //get attributed rtf from latest viewcontroller
        let appDelegate = NSApp.delegate as! AppDelegate
        attributedRTF = appDelegate.mainViewController!.attributedRTF
        attributedHTML = appDelegate.mainViewController!.attributedHTML
        let text = appDelegate.mainViewController?.plaintext
        plaintext = (try? NSAttributedString(data: Data(text!.utf8),
                                             options: [.documentType: NSAttributedString.DocumentType.plain],
                                             documentAttributes: nil)) ?? NSAttributedString(string: " ")

        pasteBoard.writeObjects([attributedHTML])
    }
}



    
