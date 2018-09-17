//
//  SwipeView.swift
//  Instagrid
//
//  Created by David DUBEZ on 17/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class SwipeView: UIView {

	@IBOutlet private var label: UILabel!
	@IBOutlet private var icon: UIImageView!

	var title = "" {
		didSet {
			label.text = title
		}
	}

	enum Style {
		case portrait, landscape
	}

	var style: Style = .portrait {
		didSet {
			setStyle()
		}
	}

	private func setStyle() {
		switch style {
		case .portrait:
			title = "Swipe up to share"
			icon.image = #imageLiteral(resourceName: "up arrow")
		case .landscape:
			title = "Swipe left to share"
			icon.image = #imageLiteral(resourceName: "left arrow")
		}
	}
}
