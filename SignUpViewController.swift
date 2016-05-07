//
//  SignUpViewController.swift
//  OnTheMap
//
//  Created by KEITH GROUT on 5/3/16.
//  Copyright © 2016 keithwgrout. All rights reserved.
//

import UIKit
import WebKit

class SignUpViewController: UIViewController {

    var webView: WKWebView
    var requestURL: NSURL?
    
    required init?(coder aDecoder: NSCoder) {
        webView = WKWebView.init(frame: CGRectZero)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let urlRequest = requestURL {
            print(urlRequest)
            webView.loadRequest(NSURLRequest(URL: urlRequest))
        }
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.frame = view.frame
        view.addSubview(webView)

    }
    
}


// wkNav delegate methods
extension SignUpViewController: WKNavigationDelegate {
    
}

// wkUI delegate methods
extension SignUpViewController: WKUIDelegate {
}
