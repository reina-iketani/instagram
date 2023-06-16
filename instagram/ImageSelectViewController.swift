//
//  ImageSelectViewController.swift
//  instagram
//
//  Created by Reina Iketani on 2023/06/13.
//

import UIKit
import CLImageEditor


class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLImageEditorDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleLibraryButton(_ sender: Any) {
        //ライブラリを指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true ,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //UIImagePickerController画面を閉じる
        picker.dismiss(animated: true, completion: nil)
        //画像加工処理
        if info[.originalImage] != nil {
            //選択、撮影された画像を取得する
            let image = info[.originalImage] as! UIImage
            //あとでCLImageEditorライブラリで加工する
            print("DEBUG_PRINT: image = \(image)")
            //CLImageEditorにimageを渡して、加工画面を起動する。
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            self.present(editor,animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //UIImagePickerController画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    

    //CLImageEditorで加工が終わった時に呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //投稿画面を開く
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController,animated: true, completion: nil)
    }
    
    //CLImageEditorの編集がキャンセルされたときに呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        //画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }
}
