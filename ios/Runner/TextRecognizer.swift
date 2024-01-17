//
//  TextRecognizer.swift
//  Runner
//
//  Created by Tak Ting Ho on 4/1/2024.
//

import MLKitTextRecognitionChinese
import MLKitTextRecognition
import MLKitVision
import UIKit


let textRecognizer = TextRecognizer.textRecognizer()

// When using Chinese script recognition SDK
let chineseOptions = ChineseTextRecognizerOptions()
let chineseTextRecognizer = TextRecognizer.textRecognizer()


// // When using Chinese script recognition
// let options = TextRecognizerOptions()
// options.recognizedLanguages = ["zh"]
// let chineseTextRecognizer = TextRecognizer.textRecognizer(options: options)
