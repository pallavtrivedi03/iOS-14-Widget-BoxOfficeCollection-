//
//  ViewController.swift
//  BoxOffice
//
//  Created by Pallav Trivedi on 01/09/20.
//

import UIKit
import WidgetKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        WidgetCenter.shared.reloadTimelines(ofKind: "BoxOfficeWidget")
    }
}

