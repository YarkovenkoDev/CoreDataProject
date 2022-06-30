//
//  DetailViewController.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit
import MobileCoreServices
import CoreData

class DetailViewController: UIViewController {
    var isEdit = true
    var user: User?

    //MARK: - Views

    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Strings.editButtonTitle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0.0
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var profileImageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.isEnabled = false
        button.addTarget(self, action: #selector(selectImageTap(_:)), for: .touchUpInside)
        button.backgroundColor = .systemFill
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.systemGray6.cgColor
        button.heightAnchor.constraint(equalToConstant: Metric.imageButtonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: Metric.imageButtonHeight).isActive = true
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Metric.imageButtonHeight / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var userTextField: UITextField = {
        let textField = UITextField()
        textField.isEnabled = false
        textField.font = .systemFont(ofSize: Metric.textFieldsFontSize)
        textField.placeholder = Strings.userPlaceholder
        textField.SetLeftSIDEImage(ImageName: "person")
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var BirthdayTextField: DatePickerTextField = {
        let textField = DatePickerTextField()
        textField.isEnabled = false
        textField.font = .systemFont(ofSize: Metric.textFieldsFontSize)
        textField.placeholder = Strings.birthdayPlaceholder
        textField.SetLeftSIDEImage(ImageName: "calendar")
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var gendersTextField: PickerTextField = {
        let textField = PickerTextField()
        textField.isEnabled = false
        textField.placeholder = Strings.gendersPlaceholder
        textField.font = .systemFont(ofSize: Metric.textFieldsFontSize)
        textField.SetLeftSIDEImage(ImageName: "person.fill.questionmark")
        textField.pickerDates = Strings.genders
        textField.displayNameHandler = { item in
            return (item as? String) ?? ""
        }
        textField.itemSelectionHendler = { index, item in
            print("\(index), \(item as! String)")
        }
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    //MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let button = self.navigationItem.rightBarButtonItem?.customView {
            button.frame = CGRect(x:0, y:0, width:70, height:32)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationConfig()
        loadData()
        setupHieracly()
        setupStackViewHieracly()
        setupLayout()
        configureView()
    }

    //MARK: - Private Func

    private func navigationConfig() {
        navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }

    private func loadData() {
        if let user = user {
            userTextField.text = user.name
            BirthdayTextField.text = user.birthday
            gendersTextField.text = user.gender

            if let profileImage = user.image {
                profileImageButton.setImage(UIImage(data: profileImage), for: .normal)
            }
        }
    }

    private func setupHieracly() {
        view.addSubview(profileImageButton)
        view.addSubview(stackView)
    }

    private func setupStackViewHieracly() {
        stackView.addArrangedSubview(userTextField)
        stackView.addSeparator(of: Metric.separatorHeight)
        stackView.addEmptyView(of: Metric.emptyViewHeight)
        stackView.addArrangedSubview(BirthdayTextField)
        stackView.addSeparator(of: Metric.separatorHeight)
        stackView.addEmptyView(of: Metric.emptyViewHeight)
        stackView.addArrangedSubview(gendersTextField)
        stackView.addSeparator(of: Metric.separatorHeight)
    }

    private func setupLayout() {
        profileImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        profileImageButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120).isActive = true

        stackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 50).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40).isActive = true

        gendersTextField.heightAnchor.constraint(equalToConstant: Metric.textfieldHeight).isActive = true
        BirthdayTextField.heightAnchor.constraint(equalToConstant: Metric.textfieldHeight).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: Metric.textfieldHeight).isActive = true
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
    }
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editingImage = info[UIImagePickerController.InfoKey(rawValue: convertInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage {

            self.profileImageButton.setImage(editingImage, for: .normal)
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func convertFromUIimageToDict(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {

        return Dictionary(uniqueKeysWithValues: input.map({key, value in (key.rawValue, value)
        }))
    }

    func convertInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension DetailViewController {
    enum Strings {
        static let genders: [String] = [
            "Agender",
            "Androgyne",
            "Androgynous",
            "Bigender",
            "Cis",
            "Cisgender",
            "Cis Female",
            "Cis Male",
            "Cis Man",
            "Cis Woman",
            "Cisgender Female",
            "Cisgender Male",
            "Cisgender Man",
            "Cisgender Woman",
            "Female to Male",
            "FTM",
            "Gender Fluid",
            "Gender Nonconforming",
            "Gender Questioning",
            "Gender Variant",
            "Genderqueer",
            "Intersex",
            "Male to Female",
            "MTF",
            "Neither",
            "Neutrois",
            "Non-binary",
            "Other",
            "Pangender",
            "Trans",
            "Trans Female",
            "Trans Male",
            "Trans Man",
            "Trans Person",
            "Trans Woman",
            "Transfeminine",
            "Transgender",
            "Transgender Female",
            "Transgender Male",
            "Transgender Man",
            "Transgender Person",
            "Transgender Woman",
            "Transmasculine",
            "Transsexual",
            "Transsexual Female",
            "Transsexual Male",
            "Transsexual Man",
            "Transsexual Person",
            "Transsexual Woman",
            "Two-Spirit",
        ]

        static let userPlaceholder = "Name"
        static let birthdayPlaceholder = "Birthday"
        static let gendersPlaceholder = "Genders"
        static let editButtonTitle = "Edit"
        static let saveButtonTitle = "Save"
    }

    enum Metric {
        static let imageButtonHeight: CGFloat = 170
        static let textFieldsFontSize: CGFloat = 20
        static let separatorHeight: CGFloat = 1
        static let emptyViewHeight: CGFloat = 20
        static let textfieldHeight: CGFloat = 40
    }
}

extension DetailViewController {
    @objc private func selectImageTap(_ sender: Any) {
        actionSheet()
    }

    private func actionSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Open Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (handler) in

        }))

        self.present(alert, animated: true, completion: nil)
    }

   private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.sourceType = .camera
            image.mediaTypes = [kUTTypeImage as String]
            self.present(image, animated: true, completion: nil)

        }
    }

    private func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let image = UIImagePickerController()
            image.allowsEditing = true
            image.delegate = self
            self.present(image, animated: true, completion: nil)
        }
    }

    @objc private func saveButtonTap() {

    if isEdit {
        self.userTextField.isEnabled = true
        self.BirthdayTextField.isEnabled = true
        self.gendersTextField.isEnabled = true
        self.profileImageButton.isEnabled = true
        editButton.setTitle(Strings.saveButtonTitle, for: .normal)
        isEdit = false
    } else {

        if userTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Input Error", message: "The field with name is not filled - saving is not possible", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {

            if let user = user {
                user.name = userTextField.text
                user.birthday = BirthdayTextField.text
                user.gender = gendersTextField.text

                if let image = profileImageButton.currentImage {
                user.image = image.pngData()
                }
                CoreDataManager.instance.saveContext()
            }

        }

        editButton.setTitle(Strings.editButtonTitle, for: .normal)
        self.userTextField.isEnabled = false
        self.BirthdayTextField.isEnabled = false
        self.gendersTextField.isEnabled = false
        self.profileImageButton.isEnabled = false
        isEdit = true
    }

    }

}


