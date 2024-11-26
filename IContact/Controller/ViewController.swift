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
    var groupedContactName: [String: [Contact]] = [:]
    var groupedContactSurname: [String: [Contact]] = [:]
    var sectionTitlesName: [String] = []
    var sectionTitlesSurname: [String] = []
    
    var sectionTitle: [String] = []
    var groupedContact: [String: [Contact]] = [:]
    
    var segmentedIndex: Int = 0
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllContact()
        makeEmptyContact()
        initGroupedContacts()
        if segmentedIndex == 0{
            groupedContact = groupedContactName
            sectionTitle = sectionTitlesName
        } else {
            groupedContact = groupedContactSurname
            sectionTitle = sectionTitlesSurname
        }
        tableView.reloadData()
        
    }
    
    @objc func refrechingTableView(){
        DispatchQueue.global().async {
            self.getAllContact()
            self.makeEmptyContact()
            self.initGroupedContacts()
            if self.segmentedIndex == 0{
                self.groupedContact = self.groupedContactName
                self.sectionTitle = self.sectionTitlesName
            } else {
                self.groupedContact = self.groupedContactSurname
                self.sectionTitle = self.sectionTitlesSurname
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
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
                    if self.segmentedIndex == 0{
                        self.groupedContact = self.groupedContactName
                        self.sectionTitle = self.sectionTitlesName
                    } else {
                        self.groupedContact = self.groupedContactSurname
                        self.sectionTitle = self.sectionTitlesSurname
                    }
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
    
    @objc func segmentedChanged(){
        segmentedIndex = segment.selectedSegmentIndex
        if segmentedIndex == 0{
            groupedContact = groupedContactName
            sectionTitle = sectionTitlesName
            updateUI()
        } else {
            groupedContact = groupedContactSurname
            sectionTitle = sectionTitlesSurname
            updateUI()
        }
    }
    
}


// MARK: TableView
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .customGray
        cell.textLabel?.textColor = .black
        let sectionTitleName = sectionTitle[indexPath.section]
        if let contact = groupedContact[sectionTitleName]?[indexPath.row] {
            if segmentedIndex == 0{
                cell.textLabel?.text = contact.name! + " " + contact.surname!
            } else {
                cell.textLabel?.text = contact.surname! + " " + contact.name!
            }
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitle[section]
        return groupedContact[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sectionTitleName = sectionTitle[indexPath.section]
        if let contact = groupedContact[sectionTitleName]?[indexPath.row] {
            let vc = detailVC()
            vc.contact = contact
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitle
    }
    
    //swipeDelete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionTitleName = sectionTitle[indexPath.section]
            if let contact = groupedContact[sectionTitleName]?[indexPath.row] {
                deleteContact(contact: contact)
                groupedContact[sectionTitleName]?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                DispatchQueue.global().async {
                    self.getAllContact()
                    self.makeEmptyContact()
                    self.initGroupedContacts()
                    if self.segmentedIndex == 0{
                        self.groupedContact = self.groupedContactName
                        self.sectionTitle = self.sectionTitlesName
                    } else {
                        self.groupedContact = self.groupedContactSurname
                        self.sectionTitle = self.sectionTitlesSurname
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: CoreData func
extension ViewController{
    public func createNewContact(name: String, surname: String, phone: String){
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
    
    public func getAllContact(){
        let fetchingContact = Contact.fetchRequest()
        do {
            models = try context.fetch(fetchingContact)
        } catch{
         print(error)
        }
    }
    
    public func deleteContact(contact: Contact){
        context.delete(contact)
        
        do{
            try context.save()
        } catch {
            print("Error delete item")
        }
    }
    
    public func updateItem(updatedContact: Contact, newName: String, newSurname: String, newPhone: String){
        updatedContact.name = newName
        updatedContact.surname = newSurname
        updatedContact.phone = newPhone
        
        do{
            try context.save()
            getAllContact()
        } catch {
            print("Error update contact")
        }
    }
}

//MARK: GroupedContact
extension ViewController{
    func initGroupedContacts(){
        for contact in models {
            let firstLetter = String(contact.name!.first!.uppercased())
            if groupedContactName[firstLetter] == nil {
                groupedContactName[firstLetter] = []
            }
            groupedContactName[firstLetter]?.append(contact)
        }
        for contact in models {
            let firstLetter = String(contact.surname!.first!.uppercased())
            if groupedContactSurname[firstLetter] == nil {
                groupedContactSurname[firstLetter] = []
            }
            groupedContactSurname[firstLetter]?.append(contact)
        }
        sectionTitlesName = groupedContactName.keys.sorted()
        sectionTitlesSurname = groupedContactSurname.keys.sorted()
        
    }
    func makeEmptyContact(){
        groupedContactName.removeAll()
        groupedContactSurname.removeAll()
        sectionTitlesName.removeAll()
        sectionTitlesSurname.removeAll()
    }
    
    func updateUI(){
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
