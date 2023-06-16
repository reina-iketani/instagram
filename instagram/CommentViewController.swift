//
//  CommentViewController.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/15.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD



class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postData: PostData?
    
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldView: UITextField!
    
    
    
    var commentArray: [PostData.CommentData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let postData = postData {
            labelView.text = "\(postData.name) : \(postData.caption)"
            commentArray = postData.comments
            print("commentArray: \(commentArray)")
            
        }

        tableView.fillerRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
    }
    
    
//キャンセルボタン
    @IBAction func returnButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
//コメント投稿ボタン
    @IBAction func commentButton(_ sender: Any) {
        guard let postData = postData,
              let comment = textFieldView.text,
              let name = Auth.auth().currentUser?.displayName else{
            return
        }
        
        let commentData = PostData.CommentData(id: UUID().uuidString, username: name, text: comment, date: "")
        
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = formatter.string(from: Date())
        
        var updatedCommentData = commentData
            updatedCommentData.date = dateString
        
        let commentValue: [String: Any] = [
                "id": updatedCommentData.id,
                "username": updatedCommentData.username,
                "text": updatedCommentData.text,
                "date": dateString
            ]
        
        let updateValue: [String: Any] = [
                "comments": FieldValue.arrayUnion([commentValue])
            ]
        
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(updateValue) { error in
                if let error = error {
                    // 書き込みに失敗した場合の処理
                    print("Error updating comments: \(error.localizedDescription)")
                } else {
                    // 書き込みに成功した場合の処理
                    print("Comment posted successfully!")
                    
                    // 投稿処理が完了
                    SVProgressHUD.showSuccess(withStatus: "コメントを投稿しました")
                    
                    // 投稿処理が完了したので先頭画面に戻る
                    self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    
    //コメント表示
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let commentData = commentArray[indexPath.row]
        cell.textLabel?.text = "\(commentData.username): \(commentData.text)"
        cell.detailTextLabel?.text = nil
        
        
        
            
        
        return cell
    }
    

    
}
