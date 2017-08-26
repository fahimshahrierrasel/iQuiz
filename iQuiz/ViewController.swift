//
//  ViewController.swift
//  iQuiz
//
//  Created by Fahim Shahrier Rasel on 8/25/17.
//  Copyright © 2017 Fahim Shahrier Rasel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var resultLebel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var option1Button: UIButton!
    @IBOutlet weak var option2Button: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var explainButton: UIButton!
    
    var quizzes = [Quiz]()
    
    var currentQuestion = 0
    var quizTried = 0
    var totalCorrect = 0
    
    var correctAlertPlayer = AVAudioPlayer()
    var wrongAlertPlayer = AVAudioPlayer()
    
    required init?(coder aDecoder: NSCoder) {
        
        do{
            let dictionary = try PListFileConverter.dictionary(fromFile: "Quizes", ofType: "plist")
            quizzes = try QuizUnarchiver.quizList(fromDictionary: dictionary)
        } catch let error{
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setQuestion(forQuiz: quizzes[currentQuestion])
        
        do{
            correctAlertPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "correct", ofType: "mp3")!))
            wrongAlertPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "wrong", ofType: "mp3")!))
        }catch let error {
            print("\(error)")
        }
    }

    @IBAction func optionClicked(_ sender: Any) {
        
        let tappedButton = sender as? UIButton
        
        let givenAnswer = tappedButton?.currentTitle ?? "Default"
        let correctAnswer = quizzes[currentQuestion].answer
        
        quizTried += 1
        
        if quizzes[currentQuestion].isAnswerCorrectFor(option: givenAnswer) {

            tappedButton?.backgroundColor = UIColor.green
            view.backgroundColor = UIColor(red:0.76, green:0.89, blue:0.75, alpha:1.00)
            totalCorrect += 1
            correctAlertPlayer.play()
        }else{

            tappedButton?.backgroundColor = UIColor.red
            view.backgroundColor = UIColor(red:0.98, green:0.78, blue:0.80, alpha:1.00)
            findCorrectButton(forAnswer: correctAnswer)
            wrongAlertPlayer.play()
        }
        
        resultLebel.text = "\(totalCorrect) correct out of \(quizTried) try"

        explainButton.isHidden = false

        optionButtonInteraction(makeDisable: true)
    }

    @IBAction func nextQuestion() {
        
        if currentQuestion+1 == quizzes.count {
            currentQuestion = 0
            quizTried = 0
            totalCorrect = 0
            resultLebel.text = "\(totalCorrect) correct out of \(quizTried) try"
        } else {
            currentQuestion += 1
        }
        setQuestion(forQuiz: quizzes[currentQuestion])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ExplainView" {
            let explainVC = segue.destination as? ExplainViewController
            explainVC?.quiz = quizzes[currentQuestion]
        }
    }
    
    func setQuestion(forQuiz quiz: Quiz){
        
        questionLabel.text = quiz.question
        
        optionButtonInteraction(makeDisable: false)
        
        option1Button.setTitle(quiz.options[0], for: .normal)
        option2Button.setTitle(quiz.options[1], for: .normal)
        option3Button.setTitle(quiz.options[2], for: .normal)
        option4Button.setTitle(quiz.options[3], for: .normal)
        
        option1Button.backgroundColor = UIColor.white
        option2Button.backgroundColor = UIColor.white
        option3Button.backgroundColor = UIColor.white
        option4Button.backgroundColor = UIColor.white
        
        explainButton.isHidden = true
        
        view.backgroundColor = UIColor(red:0.87, green:0.94, blue:0.94, alpha:1.00)
    }

    func optionButtonInteraction(makeDisable disable: Bool){
        option1Button.isUserInteractionEnabled = !disable
        option2Button.isUserInteractionEnabled = !disable
        option3Button.isUserInteractionEnabled = !disable
        option4Button.isUserInteractionEnabled = !disable
    }

    func findCorrectButton(forAnswer answer: String) {

        if option1Button.currentTitle! == answer {
            option1Button.backgroundColor = UIColor.green
        } else if option2Button.currentTitle! == answer {
            option2Button.backgroundColor = UIColor.green
        }else if option3Button.currentTitle! == answer {
            option3Button.backgroundColor = UIColor.green
        }else if option4Button.currentTitle! == answer {
            option4Button.backgroundColor = UIColor.green
        }

    }

}

