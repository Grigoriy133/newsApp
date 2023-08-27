//
//  WebViewController.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 30.04.2023.
//

import UIKit

class WebViewController: UIViewController {

   let Webview = WebView()
    var currentNews: localNewsStruct!
    
    override func loadView() {
        view = Webview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func configurateWeb(){
        let url = URL(string: currentNews.url!)
        let request = URLRequest(url: url!)
        Webview.webMainView.load(request)
        
        Webview.shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
    }
    
    @objc func share(){
        let activityViewController = UIActivityViewController(activityItems: [currentNews.url ?? [Any]()], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

/*       let request = URLRequest(url: url!)
 webMainView.load(request)
 */
