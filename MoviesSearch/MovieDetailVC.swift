//
//  MovieDetailVC.swift
//  MoviesSearch
//
//  Created by Azamuddin on 8/31/18.
//  Copyright © 2018 Azamuddin. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {
    
    
    @IBOutlet weak var detailPoster: UIImageView!
    @IBOutlet weak var detailOriginalTitle: UILabel!
    @IBOutlet weak var detailRating: UILabel!
    @IBOutlet weak var detailRelease: UILabel!
    @IBOutlet weak var detailOverview: UITextView!
    
    var profile: UIImage?
    var originalTitle: String?
    var rating: String?
    var release: String?
    var overview: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailPoster.image = profile
        detailOriginalTitle.text = originalTitle
        detailRating.text = rating
        detailRelease.text = release
        detailOverview.text = overview
        
    }
    
    
    
    
    
}

