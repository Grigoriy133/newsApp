//
//  MainView.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 29.04.2023.
//

import UIKit
import SnapKit

class MainView: UIView {
//MARK: - View
    let tableViewNews = UITableView()
    let imageViewNT = UIImageView()
    let secondViewController = WebViewController()
//MARK: - LifeCycle
    init() {
        super.init(frame: .zero)
        createView()
        makeConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - setupViewConfiguration

    func createView() {
        tableViewNews.register(TableViewCellNews.self, forCellReuseIdentifier: "news")
        tableViewNews.rowHeight = 400
        addSubview(tableViewNews)
        
        imageViewNT.contentMode = .scaleAspectFit
        imageViewNT.image = UIImage(named: "nt")
        addSubview(imageViewNT)
    }
    
    func setupStatusView(status: statusNews, label: UILabel, view: UIView){
        switch status{
        case .noRead: label.text = "New"
            view.backgroundColor = UIColor(red: 119/255, green: 194/255, blue: 179/255, alpha: 1)
        case .read: label.text = "has read"
            view.backgroundColor = UIColor(red: 108/255, green: 117/255, blue: 118/255, alpha: 1)
        }
    }
    
    func makeConstraints(){
        tableViewNews.snp.makeConstraints{
            $0.top.equalTo(imageViewNT.snp.bottom)
            $0.bottom.right.left.equalToSuperview()
        }
        imageViewNT.snp.makeConstraints{
            $0.right.left.equalToSuperview()
            $0.top.equalToSuperview().inset(20)
            $0.height.equalToSuperview().multipliedBy(0.15)
        }
    }
}



