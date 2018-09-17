//
//  CombinedPhotos.swift
//  Instagrid
//
//  Created by David DUBEZ on 13/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import Foundation
import UIKit

class CombinedPhotos {
	// creation of CombinedPhotos Class to manage the photos

	// MARK: - PROPERTIES
	var image1: UIImageView {
		return setNewImage()
	}
	var image2: UIImageView {
		return setNewImage()
	}
	var image3: UIImageView {
		return setNewImage()
	}
	var image4: UIImageView {
		return setNewImage()
	}

	var images = [[UIImageView]]()
	var gridLayout: GridLayout = .twoHightOneLow

	// MARK: - ENUM
	enum GridLayout {
		case twoHightOneLow
		case twoHightTwoLow
		case oneHightTwoLow
	}

	// MARK: - METHODS
	func setGridLayout(gridLayout: GridLayout) {
		self.gridLayout = gridLayout
		switch gridLayout {
		case .oneHightTwoLow :
			images = [[image1],
					  [image2, image3]]
		case .twoHightOneLow :
			images = [[image1, image2],
					  [image3]]
		case .twoHightTwoLow :
			images = [[image1, image2],
					  [image3, image4]]
		}
	}
	private func setNewImage() -> (UIImageView) {
		let newimage = UIImageView()
		newimage.image = #imageLiteral(resourceName: "Icon Plus")
		newimage.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		newimage.contentMode = .center
		return newimage
	}
}
