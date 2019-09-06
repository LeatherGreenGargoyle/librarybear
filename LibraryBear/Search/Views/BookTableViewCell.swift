//
//  BookTableViewCell.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import SDWebImage
import UIKit

class BookTableViewCell: UITableViewCell {
    private let bookCover: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let bookTitle: UILabel = {
        let label = UILabel()
        return label
    }()
    private let authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    private let publishDate: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubviews([bookCover, bookTitle, authorLabel, publishDate])
        
        bookCover.snp.makeConstraints { (make) in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        bookTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalTo(bookCover.snp.trailing)
        }
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookTitle.snp.bottom).offset(2)
            make.leading.equalTo(bookCover.snp.trailing)
        }
        publishDate.snp.makeConstraints { (make) in
            make.top.equalTo(authorLabel.snp.bottom).offset(2)
            make.leading.equalTo(bookCover.snp.trailing)
        }
    }
    
    func set(coverURL: URL) {
        // TODO: add placeholder
        bookCover.sd_setImage(with: coverURL, placeholderImage: nil)
    }
    
    func set(title: String) {
        bookTitle.text = title
    }
    
    func set(authors: String) {
        authorLabel.text = "by \(authors)"
    }
    
    func set(publishDate: String) {
        self.publishDate.text = "published \(publishDate)"
    }
}
