//
//  TextField.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit

extension UITextField {

    func SetLeftSIDEImage(ImageName: String) {
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit

        let leftView = UIView()

        leftView.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
        leftImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.leftViewMode = .always
        self.leftView = leftView

        let image = UIImage(systemName: ImageName)?.withRenderingMode(.alwaysTemplate)
        leftImageView.image = image
        leftImageView.tintColor = .secondaryLabel
        leftImageView.tintColorDidChange()

        leftView.addSubview(leftImageView)
    }

}

