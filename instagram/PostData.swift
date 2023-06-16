//
//  PostData.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/14.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore



class PostData: NSObject {
    var id = ""
    var name = ""
    var caption = ""
    var date = ""
    var likes: [String] = []
    var isLiked: Bool = false
    var comments: [CommentData] = []
    
    struct CommentData {
        var id: String
        var username: String
        var text: String
        var date: String
    }
    
    
    
    
    init(document: QueryDocumentSnapshot){
        self.id = document.documentID
        
        let postDic = document.data()
        
        
        if let name = postDic["name"] as? String {
            self.name = name
        }
        
        if let caption = postDic["caption"] as? String{
            self.caption = caption
        }
        
        if let timestamp = postDic["date"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.date = formatter.string(from: timestamp.dateValue())
        }
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねしているかチェックする
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあればいいねを押していると認識する
                self.isLiked = true
            }
        }
        
        if let comments = postDic["comments"] as? [CommentData]{
            self.comments = comments
        }
        
        
        super.init()
        
        if let commentArray = postDic["comments"] as? [[String: Any]] {
            for commentDic in commentArray {
                if let commentData = createCommentData(from: commentDic) {
                    self.comments.append(commentData)
                } else {
                    print("Failed to create commentData from: \(commentDic)")
                }
            }
        }else {
            print("comments field not found or invalid format.")
        }
        
//        if let username = commentDic["username"] as? String {
//            self.name = username
//        }
//
//        if let text = commentDic["text"] as? String{
//            self.caption = text
//        }
//
//        if let timestamp = commentDic["date"] as? Timestamp {
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm"
//            self.date = formatter.string(from: timestamp.dateValue())
//        }
        
    }
    
    
    
    private func createCommentData(from commentDic: [String: Any]) -> CommentData? {
            guard let id = commentDic["id"] as? String,
                  let username = commentDic["username"] as? String,
                  let text = commentDic["text"] as? String,
                  let timestamp = commentDic["date"] as? String else {
                return nil
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            guard let date = formatter.date(from: timestamp) else {
                return nil
            }
            
            let dateString = formatter.string(from: date)
            
            return CommentData(id: id, username: username, text: text, date: dateString)
        }
    
    
    
    override var description: String {
        return "PostDate: name=\(name); caption=\(caption); date=\(date); likes\(likes.count); id=\(id);　comments=\(comments.count);"
    }
    
    
    
    
    
}
