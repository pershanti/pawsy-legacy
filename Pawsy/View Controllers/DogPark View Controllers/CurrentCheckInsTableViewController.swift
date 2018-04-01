//
//  CurrentCheckInsTableViewController.swift
//  Pawsy
//
//  Created by Shantini Persaud on 3/30/18.
//  Copyright © 2018 Pawsy.dog. All rights reserved.
//

import UIKit
import Firebase
import Cloudinary

class CurrentCheckInsTableViewController: UITableViewController {



    @IBAction func dismissPage(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getListOfDogs()
        
    }

    func getListOfDogs(){

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return cell
    }

}
class DogCell: UITableViewCell {

    @IBOutlet weak var myimageView: UIImageView!

    override var bounds: CGRect {
        didSet {
            self.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.myimageView.layer.masksToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.setCircularImageView()
    }

    func setCircularImageView() {
        self.myimageView.frame = CGRect(x: 15, y: 15, width: 50, height: 50)
        self.myimageView.layer.cornerRadius = CGFloat(roundf(Float(self.myimageView.frame.size.width / 2.0)))
    }
}

