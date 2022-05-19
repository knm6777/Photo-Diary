//
//  DiaryDetailViewController.swift
//  1891143-finalProject
//
//  Created by 김민경 on 2021/05/30.
//

import UIKit


class DiaryDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var contentTextField: UITextView!
    
    
    var diary: Diary?
    let dateFormatter = DateFormatter()
    let picker = UIImagePickerController()
    var selDate: String!
}



extension DiaryDetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        
        if selDate != nil {
            datePicker.date = dateFormatter.date(from: selDate)!
            print(selDate + "넘어온 데이트")
        
        }
        else {
            let date = dateFormatter.date(from: diary!.date)!
            datePicker.date = date
        }
        titleTextField.text = diary?.title
        //datePicker.date = date
        if diary?.image != nil {
            imageView.image = diary?.image
            imageView.contentMode = .scaleAspectFit
        }
        contentTextField.text = diary?.content
        
        //mainImageView.image = UIImage(named: "Image.jpg")
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(buttonTapped)))
        self.navigationItem.title = "Diary"
        
        picker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
}

extension DiaryDetailViewController{
    @objc func dismissKeyboard(sender: UIGestureRecognizer){
        contentTextField.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
}

extension DiaryDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            print(info)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension DiaryDetailViewController {
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
    }
}

extension DiaryDetailViewController {
    @objc func buttonTapped(sender: UITapGestureRecognizer) {
        if (sender.state == .ended) {
            print("터치 이벤트")
        }
        
        let alert =  UIAlertController(title: "이미지 가져오기", message: "이미지를 가져올 곳을 클릭하세요.", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) {
            (action) in self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

extension DiaryDetailViewController{
    @IBAction func saveDiary(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiaryDetailViewController {
    override func viewWillDisappear(_ animated: Bool) {
        if let diary = diary {
            diary.title = titleTextField.text!
            diary.date = dateFormatter.string(from: datePicker.date)
            print(diary.date + "저장 할 데이트")
            diary.image = imageView.image
            diary.content = contentTextField.text
        }
    }
}

