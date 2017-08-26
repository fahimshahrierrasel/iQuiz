//
//  ExplainViewController.swift
//  iQuiz
//
//  Created by Fahim Shahrier Rasel on 8/26/17.
//  Copyright © 2017 Fahim Shahrier Rasel. All rights reserved.
//

import UIKit

class ExplainViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exaplainImage: UIImageView!
    @IBOutlet weak var correctAnswer: UILabel!
    @IBOutlet weak var explainationLabel: UILabel!
    
    var quiz: Quiz?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let answer = quiz?.answer
        correctAnswer.text = "Correct Answer: \(answer!)"
        correctAnswer.sizeToFit()
        if let eImage = quiz?.explanationImage {
            exaplainImage.image = UIImage(named: eImage)
        }
        explainationLabel.text = quiz?.explanation
        explainationLabel.sizeToFit()
        
        scrollView.sizeToFit()
        
        view.addSubview(scrollView)
        // Do any additional setup after loading the view.
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 375, height: 900)
    }

}
