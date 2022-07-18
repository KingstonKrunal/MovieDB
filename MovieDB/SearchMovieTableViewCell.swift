//
//  MovieTableViewCell.swift
//  MovieDB
//
//  Created by Krunal Shah on 2022-07-10.
//

import UIKit

class SearchMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillCell(name: String) {
        movieTitle.text = name
    }

}
