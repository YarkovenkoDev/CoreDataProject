//
//  TableViewController.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit
import CoreData

class TableViewController: UIViewController {
    var user: User?

    private lazy var contactsTableView: UITableView = {
        let myTableView = UITableView()

        myTableView.translatesAutoresizingMaskIntoConstraints = false

        return myTableView
    }()

    private lazy var myTextField: UITextField = {
        let textField = UITextField()
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        button.backgroundColor = .systemGray3
        button.setTitle("Save", for: .normal)
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc private func saveButtonTap() {
        let text = myTextField.text
        if text!.isEmpty {
            let alert = UIAlertController(title: "Input Error", message: "The field with the text is not filled - saving is not possible", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let newUser = User()
            newUser.name = myTextField.text
            CoreDataManager.instance.saveContext()
            contactsTableView.reloadData()
        }
        myTextField.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequest()
        configureView()
        tableViewConfigure()
        navigationConfig()
        viewConfig()
        layouts()
    }

    private func fetchRequest() {
        Presenter.instance.fetchResultController.delegate = self
        do {
            try Presenter.instance.fetchResultController.performFetch()
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }

    private func configureView() {
        view.backgroundColor = .systemGroupedBackground
    }

    private func navigationConfig() {
        navigationItem.title = "Users"
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.setGradientBackground(colors: [.purple, .systemPink], startPoint: .bottomLeft, endPoint: .bottomRight)
    }

    private func tableViewConfigure() {
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        contactsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
    }

    private func viewConfig() {
        view.addSubview(contactsTableView)
        view.addSubview(myTextField)
        view.addSubview(button)
    }

    private func layouts() {
        contactsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contactsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        contactsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo: myTextField.topAnchor, constant: -10).isActive = true

        myTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        myTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        myTextField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5).isActive = true

        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant:  -20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 80).isActive = true
        button.heightAnchor.constraint(equalTo: myTextField.heightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = Presenter.instance.fetchResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = Presenter.instance.fetchResultController.object(at: indexPath) as! User
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = user.name
        return cell
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contactsTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                contactsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                contactsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                contactsTableView.deleteRows(at: [indexPath], with: .automatic)
            }

            if let newIndexPath = newIndexPath {
                contactsTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let user = Presenter.instance.fetchResultController.object(at: indexPath) as! User
                let cell = contactsTableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = user.name
            }
        @unknown default:
            break
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = Presenter.instance.fetchResultController.object(at: indexPath) as! User
            CoreDataManager.instance.context.delete(user)
            CoreDataManager.instance.saveContext()
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        contactsTableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = DetailViewController()
        let user  = Presenter.instance.fetchResultController.object(at: indexPath) as? User
        nextVC.user = user
        navigationController?.pushViewController(nextVC, animated: true)
        contactsTableView.deselectRow(at: indexPath, animated: true)
    }
}

