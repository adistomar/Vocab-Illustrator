//
//  ListCreatorViewController.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit

class ListCreatorViewController: CoreDataStackViewController {

    @IBOutlet weak var vocabListTableView: UITableView!
    @IBOutlet weak var beginDoodlingBtn: UIButton!
    
    var vocabWords: [VocabWord] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vocabListTableView.dataSource = self
        vocabListTableView.delegate = self
    }
    
    func fetchWordInfoCompletionHandler(index: Int, vocabWordInfo: VocabWordInfoResponse?, error: Error?) {
        vocabWords[index].definition = vocabWordInfo?.definition
        vocabWords[index].example = vocabWordInfo?.example
        
        let vocabWordsIncomplete = vocabWords.filter { $0.definition == nil }
        if vocabWordsIncomplete.count == 0 && vocabWords.count > 0 {
            DispatchQueue.main.async {
                guard let vocabBuilderVC = self.storyboard?.instantiateViewController(withIdentifier: "vocabBuilderVC") as? VocabBuilderViewController else { return }
                vocabBuilderVC.dataController = self.dataController
                vocabBuilderVC.wordList = self.vocabWords
                vocabBuilderVC.randomModeOn = false
                self.navigationController?.pushViewController(vocabBuilderVC, animated: true)
            }
        }
    }
    
    @IBAction func beginDoodling_btnTap(_ sender: Any) {
        for vocabWordIndex in 0..<vocabWords.count {
            let vocabWord = vocabWords[vocabWordIndex]
            let vocabListCell = vocabListTableView.cellForRow(at: IndexPath(row: vocabWordIndex, section: 0))
            switch vocabWord.inputType {
            case .text:
                let vocabListCellTyped = vocabListCell as? ListCreatorTypedWordCell
                vocabWord.word = vocabListCellTyped?.vocabWordTextField.text
            case .doodled:
                let vocabListCellDoodled = vocabListCell as? ListCreatorDoodledWordCell
                vocabWord.word = vocabListCellDoodled?.detectedTextField?.text
            }
            
            FlaskServerClient.getInfoForWord(word: vocabWord.word ?? "unknown") { responseObject, error in
                self.fetchWordInfoCompletionHandler(index: vocabWordIndex, vocabWordInfo: responseObject, error: error)
            }
        }
        
    }
    
    @IBAction func addWordBtn(_ sender: Any) {
        let alertVC = UIAlertController(title: "Type of input", message: "Type or doodle?", preferredStyle: .actionSheet)
        
        alertVC.addAction(UIAlertAction(title: "Type", style: .default, handler: { alertAction in
            self.vocabWords.append(VocabWord(inputType: .text))
            self.vocabListTableView.beginUpdates()
            self.vocabListTableView.insertRows(at: [IndexPath(row: self.vocabWords.count-1, section: 0)], with: .fade)
            self.vocabListTableView.endUpdates()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Doodle", style: .default, handler: { alertAction in
            self.vocabWords.append(VocabWord(inputType: .doodled))
            self.vocabListTableView.beginUpdates()
            self.vocabListTableView.insertRows(at: [IndexPath(row: self.vocabWords.count-1, section: 0)], with: .fade)
            self.vocabListTableView.endUpdates()
        }))
        
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertVC, animated: true, completion: nil)
    }
    
    
}

extension ListCreatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ListCreatorViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabWords.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentWord = vocabWords[indexPath.row]
        
        switch currentWord.inputType {
        case .text:
            return 75
        case .doodled:
            return 191
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentWord = vocabWords[indexPath.row]
        
        switch currentWord.inputType {
        case .text:
            if let cell = vocabListTableView.dequeueReusableCell(withIdentifier: "typedVocabWordCell") as? ListCreatorTypedWordCell {
                cell.selectionStyle = .none
                cell.vocabWordTextField.delegate = self
                return cell
            }
        case .doodled:
            if let cell = vocabListTableView.dequeueReusableCell(withIdentifier: "doodledWordCell") as? ListCreatorDoodledWordCell {
                cell.selectionStyle = .none
                cell.drawingArea.isUserInteractionEnabled = false
                cell.detectedTextField.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ListCreatorDoodledWordCell, let handwriteWordVC = storyboard?.instantiateViewController(withIdentifier: "handwriteWordVC") as? HandwriteWordViewController {
            handwriteWordVC.linesArrayForDrawingArea = cell.drawingArea.lineArray
            handwriteWordVC.onHandwriteCompletion = { lines in
                cell.setDrawingAreaText(linesArray: lines)
            }
            navigationController?.pushViewController(handwriteWordVC, animated: true)
        }
    }
    
    
}
