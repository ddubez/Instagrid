//
//  ImageViewSet.swift
//  Instagrid
//
//  Created by David DUBEZ on 13/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import Foundation
import UIKit

class ImageViewSet {
	// creation of CombinedPhotos Class to manage the photos

	// MARK: - PROPERTIES
	// creation of the 4 imageViews possibles in the imageViewSet
	var imageView1 = UIImageView()
	var imageView2 = UIImageView()
	var imageView3 = UIImageView()
	var imageView4 = UIImageView ()

	// creation of an 2D array of imageViews
	var images = [[UIImageView]]()

	// creation of gridLayout : the layout of imageViews
	var gridLayout: GridLayout = .twoHightOneLow

	// MARK: - ENUM
	// creation of enum of different style possible for the grid layout
	enum GridLayout {
		case twoHightOneLow
		case twoHightTwoLow
		case oneHightTwoLow
	}

	// MARK: - METHODS
	func setGridLayout(gridLayout: GridLayout) {
		//arrange the 4 images in function of the layout chosen
		self.gridLayout = gridLayout
		switch gridLayout {
		case .oneHightTwoLow :
			images = [[imageView1],
					  [imageView2, imageView3]]
		case .twoHightOneLow :
			images = [[imageView1, imageView2],
					  [imageView3]]
		case .twoHightTwoLow :
			images = [[imageView1, imageView2],
					  [imageView3, imageView4]]
		}
	}

	func makeStartImageView() -> (UIImageView) {
		// set imageView for waiting an image
		let newimage = UIImageView()
		newimage.image = #imageLiteral(resourceName: "Icon Plus")
		newimage.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		newimage.contentMode = .center
//		newimage.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//		newimage.isUserInteractionEnabled = true
		return newimage
	}

	func setNewImageIn(_ imageView: UIImageView, with newImage: UIImage) {
		// set a new image in imageView
		imageView.image = newImage
	}
}
