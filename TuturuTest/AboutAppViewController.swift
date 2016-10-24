//
//  AboutAppViewController.swift
//  TuturuTest
//
//  Created by Артем on 24/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

class AboutAppViewController: UIViewController {
    
    
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var copyright: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion.text = "Версия: \(version)"
        }
        if let copyright = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String {
            self.copyright.text = "©\(copyright)"
        }
    }
}
