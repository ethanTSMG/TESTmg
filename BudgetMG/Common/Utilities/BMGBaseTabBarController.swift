//
//  BMGBaseTabBarController.swift
//  Base TabBarController
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class BMGBaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        creatSubViewControllers()
    }
    
    func creatSubViewControllers(){
        
        setupChildController(childVC: BMGChartsViewController(), norImageName: "", selectedImageName: "", title: "Charts");
        setupChildController(childVC: TransactionsViewController(), norImageName: "", selectedImageName: "", title: "Transactions");
        setupChildController(childVC: CategoryViewController(), norImageName: "", selectedImageName: "", title: "Category");

    }
    
    /*
    // MARK: - Properties
    */
     func setupChildController(childVC: UIViewController, norImageName: String, selectedImageName: String, title: String) {
         childVC.title = title;
         childVC.tabBarItem.image = UIImage(named: norImageName)?.withRenderingMode(.alwaysOriginal);
         childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal);
                 
         let nav = BMGBaseNavigationViewController(rootViewController: childVC);
         addChild(nav);
     }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
