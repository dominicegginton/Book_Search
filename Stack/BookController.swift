//
//  BookController.swift
//  Stack
//
//  Created by Dominic Egginton on 25/09/2019.
//  Copyright © 2019 Dominic Egginton. All rights reserved.
//

import UIKit

class BookController: UIViewController {
    
    // IBOutlets for views
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var descriptionView: UIView!
    
    //IBOutlets for view constrains
    @IBOutlet weak var summaryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionViewHeightConstraint: NSLayoutConstraint!
    
    //IBOutlets for book content
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    
    var bookID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = self.bookID {
            print(id)
            try? Books.sharedInstance.getDetails(withID: id, {(bookDetails) in
                DispatchQueue.main.async {
                    // Display Book Details
                    self.bookTitleLabel.text = bookDetails.title
                    self.bookDescriptionLabel.text = bookDetails.description
                    self.bookDescriptionLabel.sizeToFit()
                    
                    // Update View Heights
                    self.summaryViewHeightConstraint.constant = self.bookImageView.frame.height + 16
                    self.descriptionViewHeightConstraint.constant = self.bookDescriptionLabel.frame.height + 16
                    let frameHeight = self.summaryViewHeightConstraint.constant + self.descriptionViewHeightConstraint.constant + 25
                    print("frame height \(frameHeight)")
                    let size = CGSize(width: self.contentView.frame.width, height: frameHeight)
                    self.contentView.frame.size = size
                    self.scrollView.contentSize = size
                    self.summaryView.sizeToFit()
                }
            })
        }
        // Do any additional setup after loading the view.
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
