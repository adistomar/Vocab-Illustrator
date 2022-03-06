//
//  ViewController.swift
//  LancerHacks Project 2022
//
//  Created by Rohan Sinha on 3/5/22.
//

import UIKit
import CoreData

class PastDoodlesViewController: CoreDataStackViewController {
    
    @IBOutlet weak var pastDoodlesTableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<DoodleVocabWord>?
    
    func configureFetchedResultsController() {
        
        guard let dataController = dataController else { return }
        
        let fetchRequest: NSFetchRequest<DoodleVocabWord> = DoodleVocabWord.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "doodleId", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController?.delegate = self
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastDoodlesTableView.dataSource = self
        pastDoodlesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFetchedResultsController()
        
        pastDoodlesTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController?.delegate = nil
        fetchedResultsController = nil
    }


}

extension PastDoodlesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "vocabWordCell") as? DoodleCell, let vocabWord = fetchedResultsController?.object(at: indexPath), let vocabDoodle = vocabWord.doodleImage {
            cell.selectionStyle = .none
            cell.vocabWordTitleLbl.text = vocabWord.word
            cell.definitionTxtView.text = vocabWord.definition
            cell.wordDoodleImg.image = UIImage(data: vocabDoodle)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { action, targetView, completionHandler in
            guard let objToDelete = self.fetchedResultsController?.object(at: indexPath) else {
                completionHandler(false)
                return
            }
            
            let alertVC = UIAlertController(title: "Warning", message: "Are you sure you want to delete this doodle? This action can't be undone.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { alertAction in
                self.dataController?.viewContext.delete(objToDelete)
                do {
                    try self.dataController?.viewContext.save()
                    completionHandler(true)
                } catch {
                    completionHandler(false)
                }
            }))
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alertAction in
                completionHandler(false)
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension PastDoodlesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pastDoodlesTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        pastDoodlesTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                pastDoodlesTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath, indexPath != newIndexPath {
                pastDoodlesTableView.moveRow(at: indexPath, to: newIndexPath)
            }
        case .update:
            if let indexPath = indexPath {
                pastDoodlesTableView.reloadRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                pastDoodlesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert:
            pastDoodlesTableView.insertSections(indexSet, with: .fade)
        case .delete:
            pastDoodlesTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            break
        default: break
        }
    }
}

