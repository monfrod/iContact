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
        faceTimeButton.addTarget(self, action: #selector(facetimeCallTapped), for: .touchUpInside)
        emailButton.isSpringLoaded = true
        
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
            string: contact!.phone!,
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
        
        progressViewTimer.progress = 1
        progressViewTimer.progressTintColor = .red
        progressViewTimer.isHidden = true
        progressViewTimer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressViewTimer)
        
        firstLetterNameSurnameLabel.text = contact!.name!.first!.uppercased() + contact!.surname!.first!.uppercased()
        firstLetterNameSurnameLabel.textColor = .customGray
        firstLetterNameSurnameLabel.textAlignment = .center
        firstLetterNameSurnameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        firstLetterNameSurnameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        forImageView.addSubview(firstLetterNameSurnameLabel)
        forImageView.backgroundColor = .darkGray
        forImageView.layer.cornerRadius = 50
        forImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(forImageView)
        
        
        
        numberButton.setTitle(contact?.phone!, for: .normal)
        nameLabel.text = contact!.name! + " " + contact!.surname!
        
        NSLayoutConstraint.activate([
            progressViewTimer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressViewTimer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressViewTimer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressViewTimer.heightAnchor.constraint(equalToConstant: 10),
            
            forImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forImageView.topAnchor.constraint(equalTo: progressViewTimer.bottomAnchor, constant: 40),
            forImageView.widthAnchor.constraint(equalToConstant: 100),
            forImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: forImageView.safeAreaLayoutGuide.bottomAnchor, constant: 50),
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
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            firstLetterNameSurnameLabel.centerXAnchor.constraint(equalTo: forImageView.centerXAnchor),
            firstLetterNameSurnameLabel.centerYAnchor.constraint(equalTo: forImageView.centerYAnchor)
        ])
    }
}
