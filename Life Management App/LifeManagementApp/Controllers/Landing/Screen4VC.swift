//
//  Screen4VC.swift
//  LifeManagementApp
//
//  Created by Eric Rado on 9/13/17.
//  Copyright © 2017 SeniorProject. All rights reserved.
//

import UIKit

class Screen4VC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.allowsInlineMediaPlayback = true
        getVideo(videoCode: "sK70sQDDfDQ")
        
    }
    
    func getVideo(videoCode: String){
        let url = URL(string: "https://www.youtube.com/embed/\(videoCode)?&playsinline")
        webView.loadRequest(URLRequest(url: url!))
    }
}
