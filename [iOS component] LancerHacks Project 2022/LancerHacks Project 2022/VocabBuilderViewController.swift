//
//  VocabBuilderViewController.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class VocabBuilderViewController: CoreDataStackViewController {
    
    @IBOutlet weak var vocabWordTextField: UITextField!
    
    @IBOutlet weak var showHideDefinitionBtn: UIButton!
    @IBOutlet weak var showHideExampleBtn: UIButton!
    @IBOutlet weak var saveNextWordBtn: UIButton!
    
    @IBOutlet weak var definitionStackView: UIStackView!
    @IBOutlet weak var definitionTextView: UITextView!
    
    @IBOutlet weak var exampleStackView: UIStackView!
    @IBOutlet weak var exampleTextView: UITextView!
    
    @IBOutlet weak var drawingTab: VocabBuilderDoodleContainerView!
    
    @IBOutlet weak var loadingVocabWordActivityIndicator: UIActivityIndicatorView!
    
    var randomModeOn = true
    
    var definitionIsHidden: Bool = false
    var exampleIsHidden: Bool = false
    
    var currentWord: VocabWord?
    
    var wordList: [VocabWord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize current word
        
        loadingVocabWordActivityIndicator.isHidden = true

        if randomModeOn && wordList.count == 0 {
            //get random word & assign to currentWord - make request
            currentWord = VocabWord(inputType: .text)
            loadingVocabWordActivityIndicator.isHidden = false
            loadingVocabWordActivityIndicator.startAnimating()
            FlaskServerClient.getRandomWord(completionHandler: randomWordCompletionHandler(responseObject:error:))
        } else {
            randomModeOn = false
            currentWord = wordList[0]
            
            if wordList.count == 1 {
                saveNextWordBtn.setTitle("Finish", for: .normal)
            }
        }
        
        configureViewWithWord()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if randomModeOn && wordList.count == 0 {
            //get random word & assign to currentWord - make request
            currentWord = VocabWord(inputType: .text)
            loadingVocabWordActivityIndicator.isHidden = false
            loadingVocabWordActivityIndicator.startAnimating()
            FlaskServerClient.getRandomWord(completionHandler: randomWordCompletionHandler(responseObject:error:))
        }
    }
    
    func randomWordCompletionHandler(responseObject: RandomWordResponse?, error: Error?) {
        
        if let responseObject = responseObject {
            print(responseObject)
            currentWord?.word = responseObject.word
            currentWord?.definition = responseObject.definition
            currentWord?.example = responseObject.example
        }
        
        DispatchQueue.main.async {
            self.loadingVocabWordActivityIndicator.isHidden = true
            self.loadingVocabWordActivityIndicator.stopAnimating()
            print(self.currentWord)
            self.configureViewWithWord()
        }
        
    }
    
    func configureViewWithWord() {
        vocabWordTextField.text = currentWord?.word
        definitionTextView.text = currentWord?.definition
        exampleTextView.text = currentWord?.example
    }
    
    func showHideDefinition(isHidden: Bool) {
        definitionTextView.text = isHidden ? "Definition is hidden" : (currentWord?.definition ?? "Definition unavailable")
        isHidden ? showHideDefinitionBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal) : showHideDefinitionBtn.setImage(UIImage(systemName: "eye"), for: .normal)
        
    }
    
    func showHideExample(isHidden: Bool) {
        exampleTextView.text = isHidden ? "Example is hidden" : (currentWord?.definition ?? "Example unavailable")
        isHidden ? showHideExampleBtn.setImage(UIImage(systemName: "eye"), for: .normal) : showHideExampleBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        
    }
    
    @IBAction func onShowHideDefinition_btnTap(_ sender: Any) {
        definitionIsHidden = !definitionIsHidden
        
        showHideDefinition(isHidden: definitionIsHidden)
    }
    
    @IBAction func onShowHideExampleSentence_onBtnTap(_ sender: Any) {
        exampleIsHidden = !exampleIsHidden
        showHideExample(isHidden: exampleIsHidden)
    }
    
    @IBAction func onClearDoodle(_ sender: Any) {
        
    }
    
    @IBAction func onSaveDoodle(_ sender: Any) {

        guard let dataController = dataController, let currentWord = currentWord else { return }

        let vocabWordDoodle = DoodleVocabWord(context: dataController.viewContext)
        vocabWordDoodle.word = currentWord.word
        vocabWordDoodle.definition = currentWord.definition
        vocabWordDoodle.example = currentWord.example
        vocabWordDoodle.doodleImage = drawingTab.doodleView.exportAsImage()?.pngData()
        try? dataController.viewContext.save()
        
        if wordList.count == 1 {
            navigationController?.popToRootViewController(animated: true)
        }
        
        guard let nextVocabBuilderVC = storyboard?.instantiateViewController(withIdentifier: "vocabBuilderVC") as? VocabBuilderViewController else { return }
        
        if wordList.count > 1 {
            nextVocabBuilderVC.wordList = Array(wordList[1..<wordList.count])
            nextVocabBuilderVC.dataController = dataController
            nextVocabBuilderVC.randomModeOn = false
            
            navigationController?.pushViewController(nextVocabBuilderVC, animated: true)
        } else {
            nextVocabBuilderVC.dataController = dataController
            nextVocabBuilderVC.randomModeOn = true
            navigationController?.pushViewController(nextVocabBuilderVC, animated: true)
        }
        
    }
}
