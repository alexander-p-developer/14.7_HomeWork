//
//  UserDefaultsViewController.swift
//  14.7_HomeWork
//
//  Created by Саша on 09.09.2021.
//

import UIKit

class UserDefaultsViewController: UIViewController {

    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yellowView.layer.cornerRadius = 20
        nameTextField.delegate = self
        surnameTextField.delegate = self
        nameTextField.text = Persistance.shared.userName
        surnameTextField.text = Persistance.shared.userSurname
        
        /*
         Здесь производятся первоначальные настройки вьюшки, подписка делегатов полей ввода.
         Так же в полях ввода загружаются сохранённые данные из UserDefaults.
         */
    }
    
    private func saveTextField (_ textField: UITextField) {
        if textField == nameTextField {
            Persistance.shared.userName = nameTextField.text
        }
        if textField == surnameTextField {
            Persistance.shared.userSurname = surnameTextField.text
        }
        /*
         В этом методе данные из полей ввода сохраняются в UserDefaults.
         */
    }
    
    private func resign() {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        /*
         При вызове этого метода клавиатура скрывается.
         */
    }
    
    @IBAction func onTapGestureRecognized(_ sender: UITapGestureRecognizer) {
        resign()
        /*
         Этот метод реагирует на касание фона.
         */
    }
}

//MARK: - UITextFieldDelegate -

extension UserDefaultsViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        saveTextField(textField)
        /*
         Этот метод вызывается после окончания редактирования текста в поле ввода.
         */
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resign()
        return true
        /*
         Этот метод вызывается, когда пользователь нажмёт кнопку "Ввод" на клавиатуре.
         */
    }
}
