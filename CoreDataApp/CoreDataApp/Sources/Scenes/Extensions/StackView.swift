//
//  StackView.swift
//  CoreDataApp
//
//  Created by Daniil Yarkovenko on 30.06.2022.
//

import UIKit

extension UIStackView {

    func addEmptyView(of size: CGFloat){
        let space = UIView()
        space.backgroundColor = .clear

        if axis == .vertical {
            space.heightAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            space.widthAnchor.constraint(equalToConstant: size).isActive = true
        }

        addArrangedSubview(space)
    }

    func addSeparator(of size: CGFloat) {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .separator

        if axis == .vertical {
            view.heightAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            view.widthAnchor.constraint(equalToConstant: size).isActive = true
        }

        addArrangedSubview(view)
    }

}

