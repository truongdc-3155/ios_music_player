//
//  SongTableViewCell.swift
//  ios_audio_player
//
//  Created by dang.chi.truong on 4/5/26.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbNailImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var performerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func configCell(song: Song) {
        thumbNailImage.image = UIImage(named: song.thumbnail)
        titleLabel.text = song.name
        performerLabel.text = song.performer
    }
}
