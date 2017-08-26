//
//  Quiz.swift
//  iQuiz
//
//  Created by Fahim Shahrier Rasel on 8/26/17.
//  Copyright © 2017 Fahim Shahrier Rasel. All rights reserved.
//

import UIKit

protocol Correctness {
    func isAnswerCorrectFor(option answer: String) -> Bool
}

struct Quiz: Correctness {
    let question: String
    let options: [String]
    let answer: String
    let explanation: String
    let explanationImage: String

    init(question: String, options: [String], answer: String,
         explanation: String, explanationImage: String) {

        self.question = question
        self.options = options
        self.answer = answer
        self.explanation = explanation
        self.explanationImage = explanationImage
    }

    func isAnswerCorrectFor(option answer: String) -> Bool {
        return self.answer == answer ? true : false
    }
}

enum PListFileConverterError: Error {
    case invalidResource
    case conversionFailure
}

enum QuizUnarchiverError: Error {
    case noData
}

class PListFileConverter {
    static func dictionary(fromFile name: String, ofType type: String)
    throws -> [String: AnyObject] {

        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PListFileConverterError.invalidResource
        }
        guard let dictionary = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            throw PListFileConverterError.invalidResource
        }

        return dictionary
    }
}


class QuizUnarchiver {
    static func quizList(fromDictionary dictionary: [String: AnyObject]) throws
                    -> [Quiz] {

        var quizzes = [Quiz]()

        for (_, value) in dictionary {
            if let quizDictionary = value as? [String: AnyObject],
               let question = quizDictionary["question"] as? String,
               let options = quizDictionary["option"] as? [String],
               let answer = quizDictionary["answer"] as? String,
               let explanation = quizDictionary["explaination"] as? String,
               let explanationImage = quizDictionary["explainationImage"] as? String {
                quizzes.append(Quiz(question: question, options: options, answer: answer, explanation: explanation,
                        explanationImage: explanationImage))
            } else {
                throw QuizUnarchiverError.noData
            }
        }
        return quizzes
    }
}


















