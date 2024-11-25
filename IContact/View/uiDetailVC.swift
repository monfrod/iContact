//
//  uiDetailVC.swift
//  IContact
//
//  Created by yunus on 21.11.2024.
//
import UIKit

extension detailVC {
    func setupUI(){
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editButtonTapped))
        
        view.backgroundColor = .customGray
        
        var config = UIButton.Configuration.plain()
        config.imagePadding = 0
        config.imagePlacement = .top
        
        let buttonArray = [messageButton, callButton, faceTimeButton, emailButton]
        let titleButtonArray = ["Message", "Call", "FaceTime", "Email"]
        let imageButtonArray = ["message.fill", "phone.fill", "video.fill", "envelope.fill"]
        
        for i in 0..<buttonArray.count{
            buttonArray[i].setTitle(titleButtonArray[i], for: .normal)
            buttonArray[i].setTitleColor(.darkGray, for: .normal)
            buttonArray[i].setImage(UIImage(systemName: imageButtonArray[i]), for: .normal)
            buttonArray[i].backgroundColor = .white
            buttonArray[i].layer.cornerRadius = 10
            buttonArray[i].configuration = config
            HStack.addArrangedSubview(buttonArray[i])
        }
        
        messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        
        phoneView.backgroundColor = .white
        phoneView.layer.cornerRadius = 10
        phoneView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneView)
        
        phoneLabel.text = "Phone Number"
        phoneLabel.font = .systemFont(ofSize: 20, weight: .regular)
        phoneLabel.textColor = .black
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneView.addSubview(phoneLabel)
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: phoneView.topAnchor, constant: 15),
            phoneLabel.leadingAnchor.constraint(equalTo: phoneView.leadingAnchor, constant: 5),
            phoneLabel.widthAnchor.constraint(equalToConstant: 300),
            phoneLabel.heightAnchor.constraint(equalToConstant: 20)
        ])

        let attributeString = NSMutableAttributedString(
            string: phone,
            attributes: attrString
        )
        
        
        numberButton.translatesAutoresizingMaskIntoConstraints = false
        numberButton.setTitleColor(.blue, for: .normal)
        numberButton.setAttributedTitle(attributeString, for: .normal)
        numberButton.contentHorizontalAlignment = .leading
        numberButton.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        phoneView.addSubview(numberButton)
        NSLayoutConstraint.activate([
            numberButton.leadingAnchor.constraint(equalTo: phoneView.leadingAnchor, constant: 5),
            numberButton.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 7),
            numberButton.widthAnchor.constraint(equalToConstant: 200),
            numberButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        
        
        nameLabel.text = "Yunus Lalazov"
        nameLabel.textColor = .black
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        HStack.axis = .horizontal
        HStack.distribution = .fillEqually
        HStack.spacing = 10
        HStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(HStack)
        
        deleteButton.setTitle("Delete contact", for: .normal)
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.backgroundColor = .white
        deleteButton.layer.cornerRadius = 10
        deleteButton.addTarget(self, action: #selector(deleteContactTapped), for: .touchUpInside)
        view.addSubview(deleteButton)
        
        
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            HStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            HStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            HStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            HStack.heightAnchor.constraint(equalToConstant: 90),
            phoneView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            phoneView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            phoneView.topAnchor.constraint(equalTo: HStack.bottomAnchor, constant: 30),
            phoneView.heightAnchor.constraint(equalToConstant: 90),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            deleteButton.topAnchor.constraint(equalTo: phoneView.bottomAnchor, constant: 30),
            deleteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
