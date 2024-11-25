//
//  ViewController.swift
//  IContact
//
//  Created by yunus on 18.11.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    let tableView = UITableView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let segment = UISegmentedControl()
    var models = [Contact]()
    var allContactName: [String] = []
    var allContactSurname: [String] = []
    var groupedContactName: [String: [String]] = [:]
    var groupedContactSurname: [String: [String]] = [:]
    var sectionTitlesName: [String] = []
    var sectionTitlesSurname: [String] = []
    
    
    
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        tableView.reloadData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.global().async {
            self.getAllContact()
            self.makeEmptyContact()
            self.initGroupedContacts()
        }
        tableView.reloadData()
    }
    
    @objc func addContact() {
        let alert = UIAlertController(title: "Create new contact", message: "Please write for all fields", preferredStyle: .alert)
        let placeholderArray = ["Name", "Surname", "Phone"]
        for i in placeholderArray {
            alert.addTextField { textField in
                textField.placeholder = i
                textField.borderStyle = .roundedRect
                
                if i == "Phone" {
                    textField.keyboardType = .numberPad
                    textField.addTarget(self, action: #selector(self.formattedInNumber), for: .editingChanged)
                }
            }
        }
        let OKButton = UIAlertAction(title: "OK", style: .default, handler: { _ in
            let name = alert.textFields![0].text ?? ""
            let surname = alert.textFields![1].text ?? ""
            let phone = alert.textFields![2].text ?? ""
            
            if name.isEmpty || surname.isEmpty || phone.isEmpty {
                let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
                let OKButton = UIAlertAction(title: "OK", style: .default)
                alert.addAction(OKButton)
                self.present(alert, animated: true)
            } else {
                DispatchQueue.global().async {
                    self.createNewContact(name: name, surname: surname, phone: phone)
                    self.makeEmptyContact()
                    self.initGroupedContacts()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
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
    
}


// MARK: TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionTitleName = sectionTitlesName[indexPath.section]
        cell.backgroundColor = .customGray
        cell.textLabel?.textColor = .black
        let contactName = groupedContactName[sectionTitleName]?[indexPath.row]
        
        cell.textLabel?.text = contactName
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitlesName[section]
        return groupedContactName[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionTitleName = sectionTitlesName[indexPath.section]
        if let contactName = groupedContactName[sectionTitleName]?[indexPath.row] {
            if let selectedContact = models.first(where: {
                "\($0.name ?? "") \($0.surname ?? "")" == contactName
            }) {
                let vc = detailVC()
                vc.name = selectedContact.name! + " " + selectedContact.surname!
                vc.phone = selectedContact.phone ?? ""
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitlesName.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitlesName[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitlesName
    }
    
    //swipeDelete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionTitleName = sectionTitlesName[indexPath.section]
            if let contactName = groupedContactName[sectionTitleName]?[indexPath.row] {
                if let selectedContact = models.first(where: {
                    "\($0.name ?? "") \($0.surname ?? "")" == contactName
                }) {
                    deleteContact(contact: selectedContact)
                    groupedContactName[sectionTitleName]?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    DispatchQueue.global().async {
                        self.getAllContact()
                        self.makeEmptyContact()
                        self.initGroupedContacts()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: CoreData func
extension ViewController{
    func createNewContact(name: String, surname: String, phone: String){
        let newContact = Contact(context: context)
        newContact.name = name
        newContact.surname = surname
        newContact.phone = phone
        
        do {
            try context.save()
            getAllContact()
        } catch{
            print(error)
        }
    }
    
    func getAllContact(){
        let fetchingContact = Contact.fetchRequest()
        do {
            models = try context.fetch(fetchingContact)
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

//MARK: GroupedContact
extension ViewController{
    func initGroupedContacts(){
        for i in 0..<models.count {
            allContactName.append(models[i].name! + " " + models[i].surname!)
        }
        for i in 0..<models.count {
            allContactSurname.append(models[i].surname! + " " + models[i].name!)
        }
        for contact in allContactName {
            let firstLetter = String(contact.first!.uppercased())
            if groupedContactName[firstLetter] == nil {
                groupedContactName[firstLetter] = []
            }
            groupedContactName[firstLetter]?.append(contact)
        }
        for contact in allContactSurname {
            let firstLetter = String(contact.first!.uppercased())
            if groupedContactSurname[firstLetter] == nil {
                groupedContactSurname[firstLetter] = []
            }
            groupedContactSurname[firstLetter]?.append(contact)
        }
    
        sectionTitlesName = groupedContactName.keys.sorted()
        sectionTitlesSurname = groupedContactSurname.keys.sorted()
        
    }
    func makeEmptyContact(){
        allContactName.removeAll()
        allContactSurname.removeAll()
        groupedContactName.removeAll()
        groupedContactSurname.removeAll()
        sectionTitlesName.removeAll()
        sectionTitlesSurname.removeAll()
    }
}
