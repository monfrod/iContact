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
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let phoneView = UIView()
    let phoneLabel = UILabel()
    let numberButton = UIButton()
    let attrString: [NSAttributedString.Key: Any] = [
          .font: UIFont.systemFont(ofSize: 17),
          .foregroundColor: UIColor.blue,
          .underlineStyle: NSUnderlineStyle.single.rawValue
    ]
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [Contact]()
    
    var name: String = ""
    var phone: String = ""
    var indexPath: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllContact()
        setupUI()
        numberButton.setTitle(phone, for: .normal)
        nameLabel.text = name
    }
    
    @objc func editButtonTapped() {
        print("Edit button tapped")
    }
    
    @objc func callTapped(){
        guard let url = URL(string: "tel://\(phone)"),
                UIApplication.shared.canOpenURL(url) else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func deleteContactTapped(){
        let alert = UIAlertController(title: "Delete Contact", message: "Are you sure you want to delete this contact?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            if let selectedContact = self.models.first(where: {
                "\($0.name ?? "") \($0.surname ?? "")" == self.name
            }) {
                self.deleteContact(contact: selectedContact)
            }
            self.navigationController?.popViewController(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(yesAction)
        alert.addAction(cancelButton)
        present(alert, animated: true)
        
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

//MARK: CoreData
extension detailVC {
    func getAllContact(){
        let fetchingContact = Contact.fetchRequest()
        do {
            models = try context.fetch(fetchingContact)
            print(models)
        } catch{
         print(error)
        }
    }
    
    func deleteContact(contact: Contact){
        context.delete(contact)
        
        do{
            try context.save()
        } catch {
            print("Error delete item")
        }
    }
}

//MARK: MessageUI
extension detailVC: MFMessageComposeViewControllerDelegate {
    @objc func sendMessage(){
        let messageVC = MFMessageComposeViewController()
        messageVC.recipients = [phone]
        messageVC.body = ""
        messageVC.messageComposeDelegate = self
        present(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
