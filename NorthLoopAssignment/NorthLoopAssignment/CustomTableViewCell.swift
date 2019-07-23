//
//  CustomTableViewCell.swift
//  NorthLoopAssignment
//
//  Created by Abhishek Vasudev on 22/07/19.
//  Copyright © 2019 Abhishek Vasudev. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    var data : ViewController.Launches? {
        didSet {
            capsuleNameLabel.text = data?.rocket.rocket_name
            let dateString:String = (data?.launch_date_local)!
            let dateValue = dateString.components(separatedBy: "T")
            launchDateLabel.text = dateValue[0]
            if let image = data?.links.mission_patch_small {
                circuilerImageView.downloadImage(from: image)
            }
        }
    }
    let horizontalPadding = CGFloat(40)
    let verticalPadding = CGFloat(20)
    
    let circuilerImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "rocket")
        let imageSize = 65
        imageView.layer.cornerRadius = CGFloat(imageSize/2)
        imageView.heightAnchor.constraint(equalToConstant: CGFloat(imageSize)).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: CGFloat(imageSize)).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let capsuleNameLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    
    let launchDateLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9568186402, green: 0.9572820067, blue: 0.9363238215, alpha: 1)
        addSubview(circuilerImageView)
        addSubview(capsuleNameLabel)
        addSubview(launchDateLabel)
        
        activateConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateConstraints() {
        
        circuilerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalPadding).isActive = true
        circuilerImageView.topAnchor.constraint(equalTo: self.topAnchor, constant:verticalPadding).isActive = true
        circuilerImageView.trailingAnchor.constraint(equalTo: capsuleNameLabel.leadingAnchor, constant: -horizontalPadding).isActive = true
        circuilerImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding).isActive = true
        circuilerImageView.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        
        
        capsuleNameLabel.leadingAnchor.constraint(equalTo: circuilerImageView.trailingAnchor, constant: horizontalPadding).isActive = true
        capsuleNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:verticalPadding).isActive = true
        capsuleNameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: launchDateLabel.leadingAnchor, constant: -horizontalPadding).isActive = true
        capsuleNameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding).isActive = true
        capsuleNameLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        
        
        launchDateLabel.leadingAnchor.constraint(equalTo: capsuleNameLabel.trailingAnchor, constant: horizontalPadding).isActive = true
        launchDateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant:verticalPadding).isActive = true
        launchDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalPadding).isActive = true
        launchDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -verticalPadding).isActive = true
        launchDateLabel.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
    }
    
}

// For downloading Image from url recieved in response
extension UIImageView {
    func downloadImage(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadImage(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadImage(from: url, contentMode: mode)
    }
}
