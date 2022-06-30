//
//  DateTextField.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit

final class DatePickerTextField: UITextField {
    let datePicker = UIDatePicker()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createDatePicker()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.createDatePicker()
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }

    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        self.inputView = datePicker
        self.inputAccessoryView = createToolbar()
    }
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTap))
        toolbar.setItems([doneButton], animated: true)

        return toolbar
    }

    @objc private func doneTap() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        self.endEditing(true)
        self.text = dateFormatter.string(from: datePicker.date)
    }
}

