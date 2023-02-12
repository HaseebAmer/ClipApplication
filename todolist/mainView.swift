//
//  ViewController.swift
//  todolist
//
//  Created by Haseeb Amer on 6/1/2023.
//

import Cocoa
import AppKit
import WebKit
import Firebase
import SwiftUI


class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
        
    var count: Int = NSPasteboard.general.changeCount
    let htmlWrapping : String = "<!DOCTYPE html> <html></body> </html>"
    lazy var window: NSWindow! = self.view.window

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet var textView: NSTextView!
    @IBOutlet var rtfView: NSTextView!
        //put this in a seperate class, formatting.
    @IBOutlet weak var rtfScroll: NSScrollView!
    @IBOutlet weak var htmlScroll: NSScrollView!
    
    //database
    var dbArr = [CopiedDoc]()
    //need to format html to include boilerplate
    var html: String =
    """
    """
    
    var rtf: String = " "
    
    //attributed string to represent formatted RTF and HTML.
    var attributedRTF: NSAttributedString = NSAttributedString(string: " ")
    var attributedHTML: NSAttributedString = NSAttributedString(string: " ")
    var plaintext: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating reference to view controller for itself through appdelegate
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.mainViewController = self
        
        //every 0.05 seconds, check if  NSPasteboard.general.count has changed.
        _ = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
            if self.count != NSPasteboard.general.changeCount {
                self.count = NSPasteboard.general.changeCount
                
                //only add item to tableView if it is in background.
                //do not want to add item to tableView if we are using copy button.
                let application = NSApplication.shared
                let state = application.isActive
                
                if !state {
                    self.addClicked(self)
                }
            }
        }

        //create ref to DB.
        let db = Firestore.firestore()
        
        
        db.collection(Firebase.Auth.auth().currentUser!.uid).order(by: "time").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    let dbItem = CopiedDoc(
                        html: doc["html"] as! String,
                        rtf: doc["rtf"] as! String,
                        time: doc["time"] as! String,
                        plaintext: doc["plaintext"] as! String)
                    
                    self.dbArr.append(dbItem)
                        
                    let row  = self.dbArr.count
                    if row >= 0 {
                        self.tableView.insertRows(at: IndexSet(integer: row - 1), withAnimation: .slideUp)
                    }
                }
            }
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }

    
    override func viewDidAppear() {
        view.window?.titlebarAppearsTransparent = true
        view.window?.backgroundColor = .controlBackgroundColor
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
                        
        //Create reference to database.
        let db = Firestore.firestore()

        plaintext = NSPasteboard.general.string(forType:NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text")) ?? ""
        
        let today = Date.now
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss E, d MMM y"
        
        let time = format.string(from: today)
        
        html =
        
        """
        <!DOCTYPE html>
        <html>
        """
    
        +
        
        (NSPasteboard.general.string(forType:NSPasteboard.PasteboardType(rawValue: "public.html")) ?? "")
        
        +
    
        """
        </body>
        </html>
        """
                
        rtf = NSPasteboard.general.string(forType:NSPasteboard.PasteboardType(rawValue: "public.rtf")) ?? ""
        
        let dbItem = CopiedDoc(html: html, rtf: rtf, time: time, plaintext: plaintext)

        db.collection(Firebase.Auth.auth().currentUser!.uid).document().setData([
            "html": html,
            "time": time,
            "rtf": rtf,
            "plaintext": plaintext
        ])
        
        self.dbArr.insert(dbItem, at: 0)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: IndexSet(integer: 0))
        self.tableView.endUpdates()
    }
    
    
    @IBAction func clear(_ sender: Any) {


        let db  = Firestore.firestore()
        let UUID = Firebase.Auth.auth().currentUser!.uid
        db.collection(UUID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in querySnapshot!.documents {
                    db.collection(UUID).document(doc.documentID).delete()
                }
            }
        }

        dbArr.removeAll()
        
        textView.string = ""
        rtfView.string = ""

        self.tableView.reloadData()
 
    }
    
    
    //MARK: TableView funcs
    /**
     * Returns number of rows of dbArr
     */
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dbArr.count
    }
    
    /**
     * This function performs checking on HTML and RTF strings extracted from dbArr,
     * Ensures HTML or RTF are not empty strings.
     * Places attributed HTML & RTF strings in textview and rtfview respectively.
     */
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        var d : NSDictionary? = nil
        let contentHTML = dbArr[row].html
        let contentRTF = dbArr[row].rtf

        if contentHTML.removeExtraSpaces() != htmlWrapping {
            let dataHTML = Data(contentHTML.utf8)
            
            attributedHTML = (try? NSAttributedString(
                                        data: dataHTML,
                                        options: [.documentType: NSAttributedString.DocumentType.html],
                                        documentAttributes: &d)) ?? NSAttributedString(string:"")
            
            textView.textStorage?.setAttributedString(attributedHTML)
        } else {
            textView.textStorage?.setAttributedString(
                NSAttributedString(string: "          This content is unavailable",
                                     attributes:
                                     [NSAttributedString.Key.foregroundColor: NSColor.white,
                                      NSAttributedString.Key.font : NSFont.systemFont(ofSize: 14)]
                                   ))
        }
        
        if contentRTF.removeExtraSpaces() != "" {
            let dataRTF = Data(contentRTF.utf8)
            
            attributedRTF = (try? NSAttributedString(
                                    data: dataRTF,
                                    options: [.documentType: NSAttributedString.DocumentType.rtf],
                                    documentAttributes: &d)) ?? NSAttributedString(string: "")
            
            rtfView.textStorage?.setAttributedString(attributedRTF)

        } else {
            rtfView.textStorage?.setAttributedString(
                NSAttributedString(string: "           This content is unavailable",
                                   attributes:
                                    [NSAttributedString.Key.foregroundColor: NSColor.white,
                                     NSAttributedString.Key.font : NSFont.systemFont(ofSize: 14)]
                                  ))
        }
        return true
    }
    
    /**
     * Recieves contents of copiedDoc struct via dbArr, processes information and places it in tableView cell.
     */
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let dbItem = dbArr[row]
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "copiedCellRef"), owner: self) as? cellStruct {
        
            cell.copiedItem?.stringValue = dbItem.plaintext.removeExtraSpaces()
            cell.timeStamp?.stringValue = dbItem.time
            cell.attributedRTF = attributedRTF
            cell.attributedHTML = attributedHTML
            cell.fullText?.stringValue = dbItem.plaintext.removeExtraSpaces()
            return cell
        }
        return nil
    }
}

/**
 * Helper function  to remove reoccuring strings from utf-8 plaintext
 */
extension String {
    func removeExtraSpaces() -> String {
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }

}

