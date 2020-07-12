//
//  NearByTableViewCell.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import UIKit
import SDWebImage

class NearByTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NBImageView: UIImageView!
    @IBOutlet weak var NBTitle: UILabel!
    @IBOutlet weak var NBaddress: UILabel!
    
    var venue: Venue! {
        didSet {
            NBTitle.text = venue.name
            NBaddress.text = venue.location.address
            getImageURL(id: venue.id)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func getImageURL(id: String){
        
        APIManager.shared.getVenuPic(id: id) { (pic, error) in
            guard let pic = pic else {return}
            
            
            self.NBImageView.sd_setImage(with: URL(string: "\(pic.response.photos.items.first?.itemPrefix ?? "")100*100\(pic.response.photos.items.first?.suffix ?? "")"), completed: nil)
            
        }
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
