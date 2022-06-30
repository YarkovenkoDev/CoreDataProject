//
//  PickerTextField.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit

typealias PickerTextFieldDisplayNameHandler = ((Any) -> String)
typealias PickerTextFieldItemSelectionHendler = ((Int, Any) -> Void)

class PickerTextField: UITextField {

    public var pickerDates: [Any] = []
    public var datas: [Any] = []
    public var displayNameHandler: PickerTextFieldDisplayNameHandler?
    public var itemSelectionHendler: PickerTextFieldItemSelectionHendler?

    private let pickerView = UIPickerView()
    private var lastSelecetRow: Int?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return .zero
    }

    private func configureView() {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.inputView = self.pickerView

        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        toolbar.setItems([doneButton], animated: true)

        self.inputAccessoryView = toolbar
    }

    private func updateText() {
        if self.lastSelecetRow == nil {
            self.lastSelecetRow = 0
        }

        if self .lastSelecetRow! > self.pickerDates.count{
            return
        }
        let data = self.pickerDates[self.lastSelecetRow!]
        self.text = self.displayNameHandler?(data)
    }

    @objc func doneButtonTap() {
        self.resignFirstResponder()
    }

}

extension PickerTextField: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data = pickerDates[row]

        return self.displayNameHandler?(data)
    }
}

extension PickerTextField: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDates.count
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.lastSelecetRow = row
        self.updateText()
        let data = self.pickerDates[row]
        self.itemSelectionHendler?(row, data)
    }

}

