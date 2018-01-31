//
//  ViewController.swift
//  Browser
//
//  Created by Kenny Cohen on 1/27/18.
//  Copyright © 2018 Kenny Cohen. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var goButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var urlTexwtField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlTextField.delegate = self
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlString:String = "https://www.apple.com"
        
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        urlTextField.text = urlString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = urlTextField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
        
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func refreshButtonTapped(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        
        urlTextField.text = webView.url?.absoluteString
    }
    

}

