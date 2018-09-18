//
//  ViewController.swift
//  Instagrid
//
//  Created by David DUBEZ on 03/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - OUTLET
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var stackGrid: UIStackView!
	@IBOutlet weak var swipeView: SwipeView!
	@IBOutlet weak var gridView: UIView!

	// MARK: - PROPERTIES
    var imageViewSet = ImageViewSet()

    // MARK: - ACTION
    @IBAction func didTapButton1() {
        layout1Choosen()
    }

    @IBAction func didTapButton2() {
        layout2Choosen()
    }

    @IBAction func didTapButton3() {
        layout3Choosen()
    }

    // MARK: - METHODS
	override func viewDidLoad() {
		super.viewDidLoad()
		// set all the 4 imageView without any photos
		imageViewSet.imageView1 = imageViewSet.setStartImageView()
		imageViewSet.imageView2 = imageViewSet.setStartImageView()
		imageViewSet.imageView3 = imageViewSet.setStartImageView()
		imageViewSet.imageView4 = imageViewSet.setStartImageView()

		// Set interface in layout 1 at the start
		layout1Choosen()

		// ask the orientation at the start and set swipeView style
		if UIApplication.shared.statusBarOrientation.isLandscape {
			self.swipeView.style = .landscape
		} else {
			self.swipeView.style = .portrait
		}

		// Gesture reconizer
		let tapGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(changeImage(_:)))
		stackGrid.addGestureRecognizer(tapGestureReconizer)
		let swipeGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(shareGrid))
		swipeView.addGestureRecognizer(swipeGestureReconizer)
	}

	// monitor the change of orientation and set swipeView style
	override func willTransition(
		to newCollection: UITraitCollection,
		with coordinator: UIViewControllerTransitionCoordinator) {
		coordinator.animate(alongsideTransition: { _ in
			if UIApplication.shared.statusBarOrientation.isLandscape {
				self.swipeView.style = .landscape
			} else {
				self.swipeView.style = .portrait
			}
		})
	}

       private func layout1Choosen() {
        // method that set the interface (button, grid) when layout 1 is chosen
        button1.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
        button2.setImage(nil, for: .normal)
        button3.setImage(nil, for: .normal)
        imageViewSet.setGridLayout(gridLayout: .oneHightTwoLow)
        setGridViewLayout()
    }

    private func layout2Choosen() {
        // method that set the interface (button, grid) when layout 2 is chosen
        button1.setImage(nil, for: .normal)
        button2.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
        button3.setImage(nil, for: .normal)
        imageViewSet.setGridLayout(gridLayout: .twoHightOneLow)
        setGridViewLayout()
	}

    private func layout3Choosen() {
        // method that set the interface (button, grid) when layout 3 is chosen
        button1.setImage(nil, for: .normal)
        button2.setImage(nil, for: .normal)
        button3.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
        imageViewSet.setGridLayout(gridLayout: .twoHightTwoLow)
        setGridViewLayout()
    }

    private func setGridViewLayout() {
        // method that fill the grid whith images depending of the layout chosed
        for subViews in stackGrid.arrangedSubviews {
            // function that remove all subviews from the stackView and from the view hierarchy
            stackGrid.removeArrangedSubview(subViews)
            subViews.removeFromSuperview()
        }
        var row = 0
        for _ in imageViewSet.images {
            // loop that iterate in the array of combinedPhotos,
            // create a stackView vith the imageViews and add it to the stackGrid
            let subStackView = UIStackView(arrangedSubviews: imageViewSet.images[row])
            subStackView.axis = .horizontal
            subStackView.alignment = .fill
            subStackView.distribution = .fillEqually
            subStackView.spacing = 8
            stackGrid.addArrangedSubview(subStackView)
            row += 1
        }
    }

	@objc func changeImage(_ sender: UITapGestureRecognizer) {
		// function that select the imageView witch is tap and change the image
		var row = 0
		var imageViewToChange = UIImageView()
		for _ in imageViewSet.images {
			var column = 0
			for image in imageViewSet.images[row] {
				let target = stackGrid.arrangedSubviews[row].convert(
					stackGrid.arrangedSubviews[row].subviews[column].frame,
					to: stackGrid)
				if target.contains(sender.location(in: stackGrid)) {
					print("touch")
					print("\(target)")
					imageViewToChange = image
				}
				column += 1
			}
			row += 1
		}
		// displayAlertToChangeImage()
		let newImage = #imageLiteral(resourceName: "Selected")
		imageViewSet.setNewImageIn(imageViewToChange, with: newImage)
	}

	func displayAlertToChangeImage() {
		let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}

	@objc func shareGrid() {
		let capturedGridView = UIGraphicsImageRenderer(size: gridView.bounds.size)
		let imagecapturedGridView = capturedGridView.image {_ in gridView.drawHierarchy(
			in: gridView.bounds, afterScreenUpdates: true)
		}
		//let capturedGridView = gridView.snapshotView(afterScreenUpdates: false)
		let activityController = UIActivityViewController(activityItems: [imagecapturedGridView], applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
	}
}
