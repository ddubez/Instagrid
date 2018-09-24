//
//  ImagesSet.swift
//  Instagrid
//
//  Created by David DUBEZ on 20/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import Foundation
import UIKit

class ImagesSet {
	// creation of a set of managed photos

	// MARK: - PROPERTIES
	// creation of the 4 UIImages possibles in the grid
	var image1 = UIImage()
	var image2 = UIImage()
	var image3 = UIImage()
	var image4 = UIImage()
	var imagefromLibrary = UIImage()
	var imageToChangeLocation = [0, 0]

	// creation of an 2D array of images
	var images = [[UIImage]]()

	// creation of the layout of images set
	var layout: ImageSetLayout = .twoHightOneLow

	// MARK: - ENUM
	// creation of enum of different style possible for the layout
	enum ImageSetLayout {
		case twoHightOneLow
		case twoHightTwoLow
		case oneHightTwoLow
	}

	// MARK: - METHODS
	func setLayout(layout: ImageSetLayout) {
		//arrange the 4 images in function of the layout chosen
		self.layout = layout
		switch layout {
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

	func makeDefaultImage() -> (UIImage) {
		// set default image when new image have not been set
		let defaultImage: UIImage = #imageLiteral(resourceName: "Icon Plus")
		return defaultImage
	}

	func replaceImage() {
		// remplace image at the location with image selected in library
		switch imageToChangeLocation {
		case [0, 0]:
			image1 = imagefromLibrary
		case [0, 1]:
			image2 = imagefromLibrary
		case [1, 0]:
			if layout == .oneHightTwoLow {
				image2 = imagefromLibrary
			} else {
				image3 = imagefromLibrary
			}
		case [1, 1]:
			if layout == .twoHightTwoLow {
				image4 = imagefromLibrary
			} else {
				image3 = imagefromLibrary
			}
		default :
			break
		}
		setLayout(layout: layout)
	}
}
