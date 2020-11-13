//
//  WebViewController.swift
//  Mp3App
//
//  Created by AnhLD on 11/13/20.
//  Copyright © 2020 AnhLD. All rights reserved.
//

import  UIKit
import  WebKit
import Reusable

class  WebViewController: UIViewController, StoryboardBased {
    @IBOutlet weak var wkWebView: WKWebView!
    private var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebview()
    }
    
    private func setupWebview() {
        let  myURL = URL(string: url)
        let  myRequest =  URLRequest(url: myURL!)
        wkWebView.load(myRequest)
    }
    
    func setupURL(url: String) {
        self.url = url
    }
}
