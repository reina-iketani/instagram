//
//  LoginViewController.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/13.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    @IBOutlet weak var mailAddressTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextfield.text, let password = passwordTextField.text{
            //アドレスとパスワードのいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty{
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: password){ AuthDataResult, error in
                if let error = error{
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                
                print("DEBUG_PRINT: ログインに成功しました")
                
                SVProgressHUD.dismiss()
                
                //画面を閉じでタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAddressTextfield.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            //アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です")
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            SVProgressHUD.show()
            
            //アドレスとパスワードでユーザ作成。ユーザ作成に成功すると、自動的にログインする
            Auth.auth().createUser(withEmail: address, password: password){ AuthDataResult, error in
                if let error = error{
                    //エラーがあったら原因をprintしてreturnすることで以降の処理を実行せずに処理終了する
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。 ")
                
                //表示名を設定する
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges{ error in
                        if let error = error{
                            //プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                            
                            
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                        
                        SVProgressHUD.dismiss()
                        
                        //画面を閉じでタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    

}
