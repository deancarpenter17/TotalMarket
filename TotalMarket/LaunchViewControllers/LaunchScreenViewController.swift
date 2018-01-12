//
//  LaunchScreenViewController.swift
//  TotalMarket
//
//  Created by Dean Carpenter on 1/5/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
}

// To avoid redefining the theme colors this all over the place
public extension UIColor {
    static let themeGreen: UIColor = UIColor(red:0.43, green:0.85, blue:0.63, alpha:1.0)
    static let themeBlue: UIColor = UIColor(red:0.16, green:0.21, blue:0.25, alpha:1.0)
    static let placeholderGray: UIColor = UIColor(red:0.88, green:0.90, blue:0.93, alpha:0.8)
}
