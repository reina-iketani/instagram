//
//  PostTableViewCell.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/14.
//

import UIKit
import FirebaseStorageUI
import SVProgressHUD

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    
    @IBOutlet weak var commentLavel: UILabel!
    @IBOutlet weak var commentCountLavel: UILabel!
    
    @IBOutlet weak var commentViewButton: UIButton!
    
    
    
    func setPostData(_ postData: PostData) {
        //画像の表示
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションの表示
        self.captionLabel.text = "\(postData.name) : \(postData.caption)"
        
        //日時の表示
        self.dateLabel.text = postData.date
        
        //いいね数の表示
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        //いいねボタンの表示
        if postData.isLiked{
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
        
        
        
        var commentText = ""
        let maxDisplayCount = min(3, postData.comments.count)
        
        for i in 0..<maxDisplayCount {
            let commentData = postData.comments[i]
            commentText += "\(commentData.username): \(commentData.text)\n"
        }
        commentLavel.text = commentText
        print(commentText)
        
        let commentNumber = postData.comments.count
        commentCountLavel.text = "\(commentNumber)"
        
        
        if postData.comments.count > 3 {
            commentViewButton.isHidden = false
            commentViewButton.setTitle("コメントを全て表示する", for: .normal)
        } else {
            commentViewButton.isHidden = true
        }
        
        
    }
        
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    
    
    
    
}
