//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Akhil Thata on 9/19/24.
//

import UIKit

class ArticleTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}

class ArticleTableViewCell: UITableViewCell {
    static let identifier = "articleTableViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let newImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }();
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(newImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        
        let padding = 20;
        NSLayoutConstraint.activate([
            newImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -CGFloat(padding)),
            newImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor),
            newImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: CGFloat(-padding/2)),
            newImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(padding/2)),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: newImageView.leftAnchor, constant: CGFloat(-padding/2)),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            subtitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            subtitleLabel.rightAnchor.constraint(equalTo: newImageView.leftAnchor, constant: CGFloat(-padding/2)),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ArticleTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        
        if let data = viewModel.imageData {
            newImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        newImageView.image = nil
    }
}
