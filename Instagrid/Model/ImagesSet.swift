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

	func replaceImageAt(xaxis: Int, yaxis: Int, with newImage: UIImage) {
		// remplace image at the location with a new image
		let location = [yaxis, xaxis]
		switch location {
		case [0, 0]:
			image1 = newImage
		case [0, 1]:
			image2 = newImage
		case [1, 0]:
			if layout == .oneHightTwoLow {
				image2 = newImage
			} else {
				image3 = newImage
			}
		case [1, 1]:
			if layout == .twoHightTwoLow {
				image4 = newImage
			} else {
				image3 = newImage
			}
		default :
			break
		}
		setLayout(layout: layout)

//		switch layout {
//		case .oneHightTwoLow :
//			if yaxis == 0, xaxis == 0 {image1 = newImage}
//			if yaxis == 1, xaxis == 0 {image2 = newImage}
//			if yaxis == 1, xaxis == 1 {image3 = newImage}
//		case .twoHightOneLow :
//			if yaxis == 0, xaxis == 0 {image1 = newImage}
//			if yaxis == 0, xaxis == 1 {image2 = newImage}
//			if yaxis == 1, xaxis == 0 {image3 = newImage}
//		case .twoHightTwoLow :
//			if yaxis == 0, xaxis == 0 {image1 = newImage}
//			if yaxis == 0, xaxis == 1 {image2 = newImage}
//			if yaxis == 1, xaxis == 0 {image3 = newImage}
//			if yaxis == 1, xaxis == 1 {image4 = newImage}
//		}
		}
}
