//
//  WebView.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 03.05.2023.
//

import UIKit
import WebKit
import SnapKit

class WebView: UIView {
    //MARK: - View
    
    let webMainView = WKWebView()
    let toolBar = UIToolbar()
    let refreshButton = UIButton()
    let backButton = UIButton()
    let nextButton = UIButton()
    let shareButton = UIButton()
    //MARK: - LifeCycle
        init() {
            super.init(frame: .zero)
            createView()
            
            createConstraints()
            configurateButtons()
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    func configurateButtons(){
        refreshButton.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal )
        refreshButton.addTarget(self, action: #selector(refreshPage), for: .touchUpInside)
        
        backButton.setImage(UIImage(systemName: "arrowshape.left.fill"), for: .normal )
        backButton.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        
        nextButton.setImage(UIImage(systemName: "arrowshape.right.fill"), for: .normal )
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal )
    }
    
    func createView(){
        addSubview(webMainView)
        addSubview(toolBar)
        toolBar.addSubview(refreshButton)
        toolBar.addSubview(backButton)
        toolBar.addSubview(nextButton)
        toolBar.addSubview(shareButton)
        toolBar.backgroundColor = .gray
    }
    func createConstraints(){
        webMainView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(toolBar)
        }
        toolBar.snp.makeConstraints{
            $0.bottom.right.left.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        refreshButton.snp.makeConstraints{
            $0.right.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        backButton.snp.makeConstraints{
            $0.left.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
        }
        nextButton.snp.makeConstraints{
            $0.left.equalTo(backButton).inset(50)
            $0.top.equalToSuperview().inset(10)
        }
        shareButton.snp.makeConstraints{
            $0.right.equalTo(refreshButton).inset(50)
            $0.top.equalToSuperview().inset(10)
        }
    }
    
    @objc func refreshPage(){
        webMainView.reload()
    }
    @objc func backPage(){
        if webMainView.canGoBack{
            webMainView.goBack()
        }
    }
    @objc func nextPage(){
        if webMainView.canGoForward{
            webMainView.goForward()
        }
    }

}
