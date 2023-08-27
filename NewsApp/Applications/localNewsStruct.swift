//
//  localNewsStruct.swift
//  NewsApp
//
//  Created by Grigoriy Korotaev on 29.04.2023.
//

import Foundation
import UIKit

enum statusNews {
    case read
    case noRead
}

struct localNewsStruct {
    var status: statusNews?
    var title: String
    var image: UIImage?
    var text: String?
    var id: Int?
    var date: Date?
    var url: String?
}

var ArrayNews = [localNewsStruct]()
var doneNews = [100000008865128]
var keyID = "key"
