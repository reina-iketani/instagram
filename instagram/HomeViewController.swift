//
//  HomeViewController.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/13.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    var commentArray: [PostData.CommentData] = []
     
    //Firestoreのリスナー
    var listener: ListenerRegistration?
    
    
    
        
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        //ログイン済みか確認
        
        if Auth.auth().currentUser != nil{
            //listenerを登録して投稿データの更新を監視する
            let postsRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postsRef.addSnapshotListener() { (querySnapshot, error) in
                if  let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。　\(error)")
                }
                //取得したdocumentを元にpostdataを作成しpostarrayの配列にする
                self.postArray = querySnapshot!.documents.map { document in
                    let postData = PostData(document: document)
                    print("DEBUG_PRINT; \(postData)")
                    return postData
                }
                
                //tableviewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewwillDisappear")
        listener?.remove()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside )
        
        cell.commentButton.addTarget(self, action: #selector(handleCommentButton(_:forEvent:)), for: .touchUpInside )
        
        cell.commentViewButton.addTarget(self, action: #selector(handleCommentViewButton(_:forEvent:)), for: .touchUpInside )
        
        return cell
    }
    

    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent){
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        //タップされた時のインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue:FieldValue
            if postData.isLiked {
                //すでにいいねしている場合はいいね解除のためmyidを取り除く
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合はmyidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //更新データにデータを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
    
    @objc func handleCommentButton(_ sender: UIButton, forEvent event: UIEvent) {

        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        
        
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        
        commentViewController.postData = postData
        
        
        self.present(commentViewController,animated: true, completion: nil)
        
    }
    
    @objc func handleCommentViewButton(_ sender: UIButton, forEvent event: UIEvent) {

        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        
        
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        
        commentViewController.postData = postData
        
        
        self.present(commentViewController,animated: true, completion: nil)
        
    }
    

}
