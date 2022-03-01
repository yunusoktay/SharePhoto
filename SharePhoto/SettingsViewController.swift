//
//  SettingsViewController.swift
//  SharePhoto
//
//  Created by yunus oktay on 1.03.2022.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTappedButton(_ sender: Any) {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
    

}
