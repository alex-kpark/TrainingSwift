//
//  ViewController.swift
//  FoodTracker
//
//  Created by kyung hopark on 2018. 9. 23..
//  Copyright © 2018년 Kyungho Park. All rights reserved.
//

import UIKit

//UIViewController, UITextFieldDelegate라는 프로토콜을 Adopt
class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    //Ctrl을 누른 상태로 Interface를 끌어 ViewController로 옮기면 메소드 생성
    //Implicitly Unwrapped Optional : 후에 어떤 값이 들어올 지 모르므로 IUOptional로 선언
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        // 이 창이 띄워졌을 때, nameTextField에 input이 들어왔을 때 다른 곳으로 보내지 않고, self로 선언하여 스스로가 Delegate가 되는 것임
        
        nameTextField.delegate = self
    }
    
    //MARK: UITextFieldDelegate
    //Delegate은 무언가 다른 Property와 커뮤니케이션이 있을 때 사용
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the Keyboard : 입력을 마치면 키보드 창이 들어가게 하는 기능
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // TextField에 쓰인 text를 mealNameLabel의 값으로 바꾸는 기능
        mealNameLabel.text = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // 유저가 캔슬함녀 이미지 선택창 사라지게 만듬
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        // selectedImage는 info dict(카메라 롤에 담긴 정보들)에서 정보를 가져온 것으로 지정
        // 만약에 Edit된 이미지가 가져와질 경우를 대비해, fatalError로 Console에 메시지를 띄워주어서 앱이 터지는 것을 방지
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        
        // 위에서 정의한 imagePickerController가 선택한 이미지로 photoImageView에 넣어줌
        photoImageView.image = selectedImage
        
        // 선택한 다음에 imagePicker를 죽임
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    //Action은 그냥 버튼을 눌렀을 때 일어나게 하는 (다른 Object와의 커뮤니케이션이 없음)
    //Ctrl을 누른 상태로 Interface를 끌어 Action으로 만들어서, Action에 대한 메소드 생성
    //UIButton이 무언가 action을 보낼 때 어떻게 받을 지에 대한 커뮤니케이션을 함수로 정의해줌
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Meal Name"
        //위의 Property에서 정의한 mealNameLabel의 .text를 변경시키는 Action을 짠 것
    }
    
    //Image를 눌렀을 때 사진을 찍거나, 앨범에서 가져올 수 있어야 함
    //UI Image 관련 Protocol을 Adopt하고 진행
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Image를 누르기 전에 TextField에 유저가 무언가를 입력하고 있었으면, 키보드 팝업을 우선 내려줌
        nameTextField.resignFirstResponder()
        
        // 사용성을 위해 imagePickerController를 정의해주고
        let imagePickerController = UIImagePickerController()
        
        // 이미지의 Source를 카메라 롤에서 가져오도록 세팅
        imagePickerController.sourceType = .photoLibrary

        // 이미지를 전송하거나 다른 Object와 커뮤할 수도 있으므로 delegate을 정의해주고
        imagePickerController.delegate = self
        // imagePicerController를 기능하게 만드는데, animated는 이미지 선택창이 나오게 하고, completion은 이 메소드 (imagePickerController)가 실행된 다음에 무엇을 하게할지 결정하는 Parameter
        present(imagePickerController, animated: true, completion: nil)
    }
    

}

