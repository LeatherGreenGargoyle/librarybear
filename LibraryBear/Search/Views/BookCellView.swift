//
//  BookCellView.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/7/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SDWebImage
import SnapKit
import UIKit

class BookCellView: UICollectionViewCell {
    
    static var identifier: String = "BookViewCell"
    
    private let bookCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bookTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    private let bookAuthor: UILabel = {
        let label = UILabel()
        return label
    }()
    private let bookPublishDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([bookCover, bookTitle, bookAuthor, bookPublishDate])
        
        bookCover.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        bookTitle.snp.makeConstraints { (make) in
            make.top.equalTo(bookCover.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        bookAuthor.snp.makeConstraints { (make) in
            make.top.equalTo(bookTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        bookPublishDate.snp.makeConstraints { (make) in
            make.top.equalTo(bookAuthor.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
    }
    
    func set(title: String, author: String, publishDate: String) {
        bookTitle.text = title
        bookAuthor.text = author
        bookPublishDate.text = publishDate
    }
    
    func set(coverURL: URL) {
        // TODO: add placeholder
        bookCover.sd_setImage(with: coverURL, completed: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
