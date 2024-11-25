//
//  uiContactVC.swift
//  IContact
//
//  Created by yunus on 19.11.2024.
//
import UIKit

extension ViewController {
    func setupUI() {
        
        view.backgroundColor = .customGray
        title = "Contacts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addContact))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .customGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        segment.insertSegment(withTitle: "First Name", at: 0, animated: true)
        segment.insertSegment(withTitle: "Last Name", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .systemBlue
        segment.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segment)
            
        NSLayoutConstraint.activate([
            segment.widthAnchor.constraint(equalToConstant: 200),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            //tableView
            tableView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
}
