//
//  ViewController.swift
//  URLSessionJSONRequests
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 15/03/18.
//  Copyright © 2018 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var urlMain = "http://www.dontpad.com/"
    var str = ""
    @IBOutlet weak var urlInsert: UITextField!
    
    override func viewDidLoad() {
        urlInsert.delegate = self
    }
    
    @IBAction func openTxtArea(_ sender: Any) {
        getRequest()
        urlInsert.resignFirstResponder()
    }
    
    func getRequest() -> Void {
        var urlEntry = urlInsert.text
        urlEntry = urlMain + urlEntry!
        
        guard let url = URL(string: urlEntry!) else { return; }
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, poop) in
            if let data = data {
                self.str = self.getTextArea(data: data)
            }
            
        }
        session.resume()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // This function makes a Regex on a response from URL for recovery the data on a URL
    func getTextArea(data: Data) -> String {
        
        let strData = String(data: data, encoding: String.Encoding.utf8) as String?
        var string = strData?.replacingOccurrences(of: "<html lang=\"en\">(.|\n)*?<textarea id=\"text\">", with: "", options: .regularExpression, range: nil)
        
        string = string?.replacingOccurrences(of: "</textarea>(.|\n)*?</html>", with: "", options: .regularExpression, range: nil)
        
        return string!;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlInsert.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcDestiny : TextAreaController = segue.destination as! TextAreaController
        
        vcDestiny.dataReceived = urlInsert.text!
        vcDestiny.dataTextArea = str
    }
}
