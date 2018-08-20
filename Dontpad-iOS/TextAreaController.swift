//
//  TextAreaController.swift
//  Dontpad-iOS
//
//  Created by Djorkaeff Alexandre Vilela Pereira on 17/08/2018.
//  Copyright © 2018 Djorkaeff Alexandre Vilela Pereira. All rights reserved.
//

import UIKit

class TextAreaController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textArea: UITextView!
    var dataReceived = String()
    var dataTextArea = String()
    
    @IBAction func postAction(_ sender: UIButton) {
        var urlEntry = labelTitle.text
        urlEntry = "http://www.dontpad.com/" + urlEntry!
        guard let url = URL(string: urlEntry!) else { return; }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var postString = "id=text&text="
        postString += self.textArea.text!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 { // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    @IBAction func getAction(_ sender: Any) {
        var urlEntry = labelTitle.text
        urlEntry = "http://www.dontpad.com/" + urlEntry!
        
        guard let url = URL(string: urlEntry!) else { return; }
        
        let session = URLSession.shared.dataTask(with: url) { (data, response, poop) in
            if let data = data {
                self.dataTextArea = self.getTextArea(data: data)
                DispatchQueue.main.async {
                    self.textArea.text = self.dataTextArea
                }
            }
            
        }
        session.resume()
    }
    
    func post() {
        var urlEntry = labelTitle.text
        urlEntry = "http://www.dontpad.com/" + urlEntry!
        guard let url = URL(string: urlEntry!) else { return; }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var postString = "id=text&text="
        postString += self.textArea.text!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
    
    func recursivaQueue() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            self.recursivaQueue()
            self.post()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textArea.delegate = self
        self.labelTitle.text = self.dataReceived
        self.textArea.text = dataTextArea
        getAction(NSNull.self)
        recursivaQueue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getTextArea(data: Data) -> String {
        
        let strData = String(data: data, encoding: String.Encoding.utf8) as String?
        var string = strData?.replacingOccurrences(of: "<html lang=\"en\">(.|\n)*?<textarea id=\"text\">", with: "", options: .regularExpression, range: nil)
        
        string = string?.replacingOccurrences(of: "</textarea>(.|\n)*?</html>", with: "", options: .regularExpression, range: nil)
        
        return string!;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textArea.resignFirstResponder()
        return true
    }
}
