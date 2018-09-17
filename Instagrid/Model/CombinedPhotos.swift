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
	var image1 = UIImageView(
		image: #imageLiteral(resourceName: "Icon Plus"))
	var image2 = UIImageView(
		image: #imageLiteral(resourceName: "Icon Plus"))
	var image3 = UIImageView(
		image: #imageLiteral(resourceName: "Icon Plus"))
	var image4 = UIImageView(
		image: #imageLiteral(resourceName: "Icon Plus"))

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
}
