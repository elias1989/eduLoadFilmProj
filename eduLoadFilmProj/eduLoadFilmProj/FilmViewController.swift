//
//  FilmViewController.swift
//  eduLoadFilmProj
//
//  Created by Joseph on 17/12/2023.
//

import UIKit

class FilmViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
        let label = UILabel()
        label.text = "Hello World"
        label.textColor = .white
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 30)
        view.addSubview(label)
        
    }
    
    
}
