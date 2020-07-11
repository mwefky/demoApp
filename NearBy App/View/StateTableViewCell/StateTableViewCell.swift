//
//  StateTableViewCell.swift
//  NearBy App
//
//  Created by mina wefky on 7/10/20.
//  Copyright © 2020 mina wefky. All rights reserved.
//

import UIKit

class StateTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var stateImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    
    
    var state: TableState? {
        didSet {
            switch state {
            case .loading:
                stateImage.image = UIImage(named: "LoadingIndecator")
                stateLabel.text = "Please wait ..."
            case .error:
                stateImage.image = UIImage(named: "ErrorIndecator")
                stateLabel.text = "Something went wrong !!"
            case .empty:
                stateImage.image = UIImage(named: "emptyIndecator")
                stateLabel.text = "No data found !!"
            default:
                stateImage.image = UIImage(named: "LoadingIndecator")
                stateLabel.text = "Please wait ..."
            }
        }
    }
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
