//
//  TableViewCellNews.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 29.04.2023.
//

import UIKit
import SnapKit

class TableViewCellNews: UITableViewCell {

    let cellLabel = UILabel()
    let imageViewNews = UIImageView()
    let statusView = UIView()
    let statusLabel = UILabel()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        addSubview(cellLabel)
        addSubview(imageViewNews)
        addSubview(statusView)
        statusView.addSubview(statusLabel)
        
        statusLabel.textColor = .white
        imageViewNews.contentMode = .scaleAspectFit
        cellLabel.numberOfLines = 0
        makeconstraints()
    }
    func makeconstraints(){
        cellLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageViewNews.snp.bottom).offset(10)
            $0.right.left.equalToSuperview().inset(10)
        }
        imageViewNews.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.right.left.equalToSuperview().inset(10)
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        statusView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().dividedBy(4)
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        statusLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
}
