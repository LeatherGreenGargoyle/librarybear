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
        imageView.contentMode = .scaleAspectFill
        imageView.sd_imageTransition = .fade
        imageView.backgroundColor = .gray
        return imageView
    }()
    private let bookTitle: UILabel = {
        let label = UILabel()
        label.font = .regular14
        label.textAlignment = .center
        return label
    }()
    private let bookAuthor: UILabel = {
        let label = UILabel()
        label.font = .regular10
        label.textAlignment = .center
        return label
    }()
    private let bookPublishDate: UILabel = {
        let label = UILabel()
        label.font = .regular10
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews([bookCover, bookTitle, bookAuthor, bookPublishDate])
        
        bookCover.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.76)
        }
        bookTitle.snp.makeConstraints { (make) in
            make.top.equalTo(bookCover.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(4)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        bookAuthor.snp.makeConstraints { (make) in
            make.top.equalTo(bookTitle.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(4)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
        bookPublishDate.snp.makeConstraints { (make) in
            make.top.equalTo(bookAuthor.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(4)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bookCover.setRoundCorners([.topLeft, .topRight], radius: 12)
    }
    
    func set(title: String, author: String, publishDate: String) {
        bookTitle.text = title
        bookAuthor.text = author
        bookPublishDate.text = publishDate
    }
    
    func set(coverURL: URL) {
        bookCover.sd_setImage(with: coverURL) { (image, _, _, _) in
            guard let image = image, image.size.width > 1 else {
                self.bookCover.contentMode = .center
                if let errorImage = UIImage(named: "icon_no_image") {
                    self.bookCover.image = errorImage
                }
                return
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
