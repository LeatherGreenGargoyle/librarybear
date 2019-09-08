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

class BookDetailsView: UIScrollView {
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.sd_imageTransition = .fade
        return imageView
    }()
    private let title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .bold18
        return label
    }()
    private let subtitleContainer: UIView = {
        let view = UIView()
        return view
    }()
    private let titleDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    private let author: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let publishingDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let isbnLabel: UILabel = {
        let label = UILabel()
        label.text = "ISBN numbers:"
        label.textAlignment = .center
        label.font = .regular10
        label.textColor = .lbGreen
        return label
    }()
    private let isbnList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let isbnMarginBottom: UIView = {
        let view = UIView()
        return view
    }()
    private let contributorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Contributors:"
        label.textAlignment = .center
        label.font = .regular10
        label.textColor = .lbGreen
        return label
    }()
    private let contributorsList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let contributorMarginBottom: UIView = {
        let view = UIView()
        return view
    }()
    private let numberOfEditions: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let publishersLabel: UILabel = {
        let label = UILabel()
        label.text = "Publishers:"
        label.textAlignment = .center
        label.font = .regular10
        label.textColor = .lbGreen
        return label
    }()
    private let publishersList: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = .regular14
        return label
    }()
    private let publishersMarginBottom: UIView = {
        let view = UIView()
        return view
    }()
    let actionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brown
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([coverImage,
                          titleDivider,
                          title,
                          subtitleContainer,
                          isbnLabel, isbnList, contributorsLabel, contributorsList, isbnMarginBottom,
                          contributorMarginBottom,
                          publishersLabel, publishersList, publishersMarginBottom,
                          actionButton])
        subtitleContainer.addSubviews([author, publishingDate, numberOfEditions])
        
        coverImage.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(300)
            make.bottom.equalTo(titleDivider.snp.top)
        }
        titleDivider.snp.makeConstraints { (make) in
            make.top.equalTo(coverImage.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalTo(title.snp.top)
        }
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(titleDivider.snp.bottom)
            make.bottom.equalTo(subtitleContainer.snp.top)
        }
        subtitleContainer.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(65)
            make.bottom.equalTo(contributorsLabel.snp.top)
        }
            author.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.centerX.equalToSuperview()
                make.bottom.equalTo(publishingDate.snp.top)
            }
            publishingDate.snp.makeConstraints { (make) in
                make.top.equalTo(author.snp.bottom)
                make.centerX.equalToSuperview()
                make.bottom.equalTo(numberOfEditions.snp.top)
            }
            numberOfEditions.snp.makeConstraints { (make) in
                make.top.equalTo(publishingDate.snp.bottom)
                make.centerX.equalToSuperview()
            }
        
        contributorsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleContainer.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contributorsList.snp.top)
        }
        contributorsList.snp.makeConstraints { (make) in
            make.top.equalTo(contributorsLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(contributorMarginBottom.snp.top)
        }
        contributorMarginBottom.snp.makeConstraints { (make) in
            make.top.equalTo(contributorsList.snp.bottom)
            make.bottom.equalTo(isbnLabel.snp.top)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
        }
        isbnLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contributorMarginBottom.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(isbnList.snp.top)
        }
        isbnList.snp.makeConstraints { (make) in
            make.top.equalTo(isbnLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(isbnMarginBottom.snp.top)
        }
        isbnMarginBottom.snp.makeConstraints { (make) in
            make.top.equalTo(isbnList.snp.bottom)
            make.bottom.equalTo(publishersLabel.snp.top)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
        }
        publishersLabel.snp.makeConstraints { (make) in
            make.top.equalTo(isbnMarginBottom.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(publishersList.snp.top)
        }
        publishersList.snp.makeConstraints { (make) in
            make.top.equalTo(publishersLabel.snp.bottom)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(publishersMarginBottom.snp.top)
        }
        publishersMarginBottom.snp.makeConstraints { (make) in
            make.top.equalTo(publishersList.snp.bottom)
            make.bottom.equalTo(actionButton.snp.top)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
        }
        actionButton.snp.makeConstraints { (make) in
            make.top.equalTo(publishersMarginBottom.snp.bottom)
            make.centerX.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setCoverImage(url: URL) {
        coverImage.sd_setImage(with: url) { (image, _, _, _) in
            guard let image = image, image.size.width > 1 else {
                self.coverImage.contentMode = .center
                if let errorImage = UIImage(named: "icon_no_image") {
                    self.coverImage.image = errorImage
                }
                return
            }
        }
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
}
