//
//  detailVC.swift
//  IContact
//
//  Created by yunus on 21.11.2024.
//
import UIKit
import CoreData
import MessageUI


class detailVC: UIViewController {
    
    let HStack = UIStackView()
    let messageButton = UIButton()
    let callButton = UIButton()
    let emailButton = UIButton()
    let faceTimeButton = UIButton()
    let deleteButton = UIButton()
    let progressViewTimer = UIProgressView()
    
    let forImageView = UIView()
    let firstLetterNameSurnameLabel = UILabel()
    let nameLabel = UILabel()
    let phoneView = UIView()
    let phoneLabel = UILabel()
    let numberButton = UIButton()
    let attrString: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 17),
          .foregroundColor: UIColor.blue,
          .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    var timer: Timer?
    var timerInt: Float = 5.0
    
    let vc = ViewController()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var contact: Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
        
    }
    
    @objc func editButtonTapped() {
        let alert = UIAlertController(title: "Edit contact", message: "Edit your contact", preferredStyle: .alert)
        let TextArray = [contact!.name, contact!.surname, contact!.phone]
        for i in TextArray {
            alert.addTextField { textField in
                textField.text = i
                textField.borderStyle = .roundedRect
                
                if i == self.contact!.phone {
                    textField.keyboardType = .numberPad
                    textField.addTarget(self, action: #selector(self.formattedInNumber), for: .editingChanged)
                }
            }
        }
        let OKButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
            let name = alert.textFields![0].text ?? ""
            let surname = alert.textFields![1].text ?? ""
            let phone = alert.textFields![2].text ?? ""
            
            var textFieldText = [name, surname, phone]
            let ourValues = [self.contact!.name, self.contact!.surname, self.contact!.phone]
            
            for i in 0..<textFieldText.count {
                if textFieldText[i].isEmpty {
                    textFieldText[i] = ourValues[i]!
                }
            }
            
            DispatchQueue.global().async {
                self.vc.updateItem(updatedContact: self.contact!, newName: textFieldText[0], newSurname: textFieldText[1], newPhone: textFieldText[2])
                DispatchQueue.main.async {
                    self.setupUI()
                }
            }
        })
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(OKButton)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func formattedInNumber(_ textField: UITextField){
        guard let currentText = textField.text else { return }
 
        textField.text = currentText.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacementCharacter: "#")
        let maxLength = 17
        if let text = textField.text, text.count > maxLength {
            textField.text = String(text.prefix(maxLength))
        }
    }
    
    @objc func callTapped(){
        guard let url = URL(string: "tel://\(contact!.phone!)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func deleteContactTapped(){
        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
            
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(cancelButton)
        present(alert, animated: true)
    }
    
    @objc func facetimeCallTapped() {
        guard let url = URL(string: "facetime://\(contact!.phone!)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func startTimer(){
        if timerInt == 0 {
            timerInt = 5.0
            progressViewTimer.isHidden = true
            self.vc.deleteContact(contact: self.contact!)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        progressViewTimer.isHidden = false
        deleteButton.setTitle("Undo Delete", for: .normal)
        deleteButton.setTitleColor(.blue, for: .normal)
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.addTarget(self, action: #selector(undoDeleteContact), for: .touchUpInside)
        progressViewTimer.progress = timerInt/5.0
        timerInt -= 1.0
    }
    
    @objc func undoDeleteContact(){
        timer?.invalidate()
        timerInt = 5.0
        progressViewTimer.isHidden = true
        deleteButton.setTitle("Delete contact", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.addTarget(self, action: #selector(deleteContactTapped), for: .touchUpInside)
    }
}


extension String {
    func applyPatternOnNumbers(pattern: String, replacementCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}

//MARK: MessageUI
extension detailVC: MFMessageComposeViewControllerDelegate {
    @objc func sendMessage(){
        let messageVC = MFMessageComposeViewController()
        messageVC.recipients = [contact!.phone!]
        messageVC.body = ""
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
