//
//  KolodaViewController.swift
//  
//
//  Created by Shantini Vyas on 2/17/18.
//

import UIKit
import Koloda


class MatchrViewController: UIViewController, KolodaViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.reloadData()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {

    }

}
