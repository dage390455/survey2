//
//  LocationViewController.swift
//  Runner
//
//  Created by liwanchun on 2019/8/17.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    typealias fucBlock = (String) ->()
    //创建block变量
    var blockproerty:fucBlock!
    @IBOutlet weak var textView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: UIButton) {
        if let _ = blockproerty{
            blockproerty(textView.text ?? "")
        }
        self.navigationController?.popViewController(animated: true);
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
