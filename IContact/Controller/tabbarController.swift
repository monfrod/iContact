//
//  tabbarController.swift
//  IContact
//
//  Created by yunus on 18.11.2024.
//

import UIKit

class tabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.backgroundColor = .lightGray
        let vc1 = createVC(vc: ViewController(), image: "person.crop.circle.fill", title: "Contacts")
        let vc2 = createVC(vc: NumPadViewController(), image: "square.grid.3x3.fill", title: "Keypad")
        self.setViewControllers([vc1, vc2], animated: false)
        
    }
    func createVC(vc: UIViewController, image: String, title: String)-> UINavigationController{
        let viewC = UINavigationController(rootViewController: vc)
        viewC.tabBarItem.title = title
        viewC.tabBarItem.image = UIImage(systemName: image)
        return viewC
    }
}
