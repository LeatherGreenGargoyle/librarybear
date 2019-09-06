//
//  BookDetailsView.swift
//  LibraryBear
//
//  Created by Andrew Tran on 9/5/19.
//  Copyright © 2019 Andrew Tran. All rights reserved.
//

import Foundation
import SnapKit
import UIKit

protocol BookDetailsViewDelegate: class {
    func onActionButtonPress()
}

class BookDetailsView: UIScrollView {
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    private let author: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    private let publishingDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.text = "ISBN numbers:"
        label.textAlignment = .center
        return label
    }()
    private let isbnList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    private let contributorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Contributors:"
        label.textAlignment = .center
        return label
    }()
    private let contributorsList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    private let numberOfEditions: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private let publishersLabel: UILabel = {
        let label = UILabel()
        label.text = "Publishers:"
        label.textAlignment = .center
        return label
    }()
    private let publishersList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    private let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        return button
    }()
    
    private weak var bookDetailsViewdelegate: BookDetailsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([coverImage,
                          title, author,
                          publishingDate,
                          isbnLabel, isbnList, contributorsLabel, contributorsList,
                          numberOfEditions,
                          publishersLabel, publishersList,
                          actionButton])
        
        coverImage.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalTo(title.snp.top)
        }
        title.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.top.equalTo(coverImage.snp.bottom)
            make.bottom.equalTo(author.snp.top)
        }
        author.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(publishingDate.snp.top)
        }
        publishingDate.snp.makeConstraints { (make) in
            make.top.equalTo(author.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.bottom.equalTo(contributorsLabel.snp.top)
        }
        contributorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(publishingDate.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.bottom.equalTo(contributorsList.snp.top)
        }
        contributorsList.snp.makeConstraints { (make) in
            make.top.equalTo(contributorsLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(numberOfEditions.snp.top)
        }
        numberOfEditions.snp.makeConstraints { (make) in
            make.top.equalTo(contributorsList.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.bottom.equalTo(isbnLabel.snp.top)
        }
        isbnLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numberOfEditions.snp.bottom)
            make.leading.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(isbnList.snp.top)
        }
        isbnList.snp.makeConstraints { (make) in
            make.top.equalTo(isbnLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(publishersLabel.snp.top)
        }
        publishersLabel.snp.makeConstraints { (make) in
            make.top.equalTo(isbnList.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(publishersList.snp.top)
        }
        publishersList.snp.makeConstraints { (make) in
            make.top.equalTo(publishersLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().offset(8)
            make.width.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalTo(actionButton.snp.top)
        }
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(publishersList.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(delegate: BookDetailsViewDelegate) {
        self.bookDetailsViewdelegate = delegate
    }
    func setCoverImage(url: URL) {
        coverImage.sd_setImage(with: url, placeholderImage: nil)
    }
    func set(title: String) {
        self.title.text = title
    }
    func set(authors: String) {
        self.author.text = "By \(authors)"
    }
    func set(publishingDate: String) {
        self.publishingDate.text = "Published \(publishingDate)"
    }
    func set(isbnList: String) {
        print(isbnList)
        self.isbnList.text = isbnList
    }
    func set(contributorsList: String) {
        print(contributorsList)
        self.contributorsList.text = contributorsList
    }
    func set(numberOfEditions: String) {
        self.numberOfEditions.text = "Number of Editions: \(numberOfEditions)"
    }
    func set(publishersList: String) {
        print(publishersList)
        self.publishersList.text = publishersList
    }
    func setButton(title: String, handler: Callback) {
        actionButton.setTitle(title, for: .normal)
        actionButton.addTarget(self, action: #selector(onButtonPress), for: .touchUpInside)
    }
    
    @objc private func onButtonPress() {
        guard let delegate = self.bookDetailsViewdelegate else {
            print("BookViewDelegate not set")
            return
        }
        delegate.onActionButtonPress()
    }
}
