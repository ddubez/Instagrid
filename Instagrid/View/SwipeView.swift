//
//  SwipeView.swift
//  Instagrid
//
//  Created by David DUBEZ on 17/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class SwipeView: UIView {
	//creation of subclass of UIView for manage the swipeView

	// MARK: - OUTLETS

	@IBOutlet private var label: UILabel!
	@IBOutlet private var icon: UIImageView!

	// MARK: - PROPERTIES
	//creation of the text display
	var title = "" {
		didSet {
			label.text = title
		}
	}

	//creation of the style enum for set swipeView depending of the screen orientation
	enum Style {
		case portrait, landscape
	}

	//creation of the style
	var style: Style = .portrait {
		didSet {
			setStyle()
		}
	}

	// MARK: - METHODS
	private func setStyle() {
		// func that set the style of swipeView depending of style variable
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
