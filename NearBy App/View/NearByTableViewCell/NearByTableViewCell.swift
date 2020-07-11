//
//  NearByTableViewCell.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import UIKit

class NearByTableViewCell: UITableViewCell {

    
    @IBOutlet weak var NBImageView: UIImageView!
    @IBOutlet weak var NBTitle: UILabel!
    @IBOutlet weak var NBaddress: UILabel!
    
    var venue: Venue! {
        didSet {
            NBTitle.text = venue.name
            NBaddress.text = venue.location.address
            NBImageView.downloaded(from: "\(venue.categories.first?.icon.iconPrefix ?? "")\(venue.categories.first?.icon.suffix ?? "")")
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}


extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
