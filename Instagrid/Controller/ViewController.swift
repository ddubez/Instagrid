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
    var imagesSet = ImagesSet()

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
		// Set interface in layout 1 at the start
		layout1Choosen()

		//set all the 4 images without any photos
		setAllImagesToDefault()

		// ask the screnne orientation at the start and set swipeView style
		if UIApplication.shared.statusBarOrientation.isLandscape {
			self.swipeView.style = .landscape
		} else {
			self.swipeView.style = .portrait
		}

		// Gesture reconizer for sharing grid images
		let swipeGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(shareGrid))
		swipeView.addGestureRecognizer(swipeGestureReconizer)
		// Gesture reconizer for erase grid images
		let eraseAllGestureReconizer = UITapGestureRecognizer(target: self, action: #selector(eraseAllImage))
		eraseAllGestureReconizer.numberOfTapsRequired = 2
		eraseAllGestureReconizer.numberOfTouchesRequired = 2
		swipeView.addGestureRecognizer(eraseAllGestureReconizer)
	}

	// monitor the change of screnn orientation and set swipeView style
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
		imagesSet.setLayout(layout: .oneHightTwoLow)
        setGridViewLayout()
    }

    private func layout2Choosen() {
        // method that set the interface (button, grid) when layout 2 is chosen
        button1.setImage(nil, for: .normal)
        button2.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
        button3.setImage(nil, for: .normal)
		imagesSet.setLayout(layout: .twoHightOneLow)
		setGridViewLayout()
	}

    private func layout3Choosen() {
        // method that set the interface (button, grid) when layout 3 is chosen
        button1.setImage(nil, for: .normal)
        button2.setImage(nil, for: .normal)
        button3.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		imagesSet.setLayout(layout: .twoHightTwoLow)
        setGridViewLayout()
    }

    private func setGridViewLayout() {
        // method that fill the grid whith images depending of the layout chosed
        for subViews in stackGrid.arrangedSubviews {
            // function that remove all subviews from the stackView and from the view hierarchy
            stackGrid.removeArrangedSubview(subViews)
            subViews.removeFromSuperview()
        }

        for row in 0..<imagesSet.images.count {
            // loop that iterate in the array of combinedPhotos,
            // create a stackView vith new buttons created with images in imagesSet and add to stackGrid
			let subStackView = UIStackView()
			subStackView.axis = .horizontal
			subStackView.alignment = .fill
			subStackView.distribution = .fillEqually
			subStackView.spacing = 8
			for column in 0..<imagesSet.images[row].count {
				let imageButton = UIButton()
				imageButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
				imageButton.setImage(imagesSet.images[row][column], for: .normal)
				imageButton.addTarget(self, action: #selector(imageButtonTapped(sender:)), for: .touchUpInside)
				subStackView.addArrangedSubview(imageButton)
			}
            stackGrid.addArrangedSubview(subStackView)
        }
    }

	func imageButtonTapped(sender: UIButton) {
		// method that runs when one of the images buttons is tapped
		imagesSet.replaceImageAt(xaxis: findButtonTapped(sender: sender).x,
								 yaxis: findButtonTapped(sender: sender).y,
								 with: #imageLiteral(resourceName: "Selected"))
		setGridViewLayout()
	}

	func findButtonTapped(sender: UIButton) -> (x: Int, y: Int) {
		//method that find the location of the button that was tapped
		var xButton = 0
		var yButton = 0
		for row in 0..<imagesSet.images.count {
			for column in 0..<imagesSet.images[row].count where stackGrid.arrangedSubviews[row].subviews[column] == sender {
				yButton = row
				xButton = column
			}
		}
		return (xButton, yButton)
	}

	func displayAlertToChangeImage() {
		// function for share a photo from the photo library
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self

		let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alertController.addAction(cancelAction)

		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let photoLibraryAction = UIAlertAction(title: "photo library", style: .default, handler: {_ in
				imagePicker.sourceType = .photoLibrary
				self.present(imagePicker, animated: true, completion: nil)
			})
			alertController.addAction(photoLibraryAction)
			}
		present(alertController, animated: true, completion: nil)
	}

	func shareGrid() {
		// function for share the grid image 
		let capturedGridView = UIGraphicsImageRenderer(size: gridView.bounds.size)
		let imagecapturedGridView = capturedGridView.image {_ in gridView.drawHierarchy(
			in: gridView.bounds, afterScreenUpdates: true)
		}
		//let capturedGridView = gridView.snapshotView(afterScreenUpdates: false)
		let activityController = UIActivityViewController(activityItems: [imagecapturedGridView], applicationActivities: nil)
		present(activityController, animated: true, completion: nil)
	}

	func eraseAllImage() {
		// function that create a alert controler and ask if you waunt to erase all the images

		let alertController = UIAlertController(title: "Erase all images ?", message: nil, preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let confirmationAction = UIAlertAction(title: "yes", style: .default) { _ in
			self.setAllImagesToDefault()
		}

		alertController.addAction(cancelAction)
		alertController.addAction(confirmationAction)

 		present(alertController, animated: true, completion: nil)
	}

	func setAllImagesToDefault() {
		// function that set all images to default and refresh the grid
		imagesSet.image1 = imagesSet.makeDefaultImage()
		imagesSet.image2 = imagesSet.makeDefaultImage()
		imagesSet.image3 = imagesSet.makeDefaultImage()
		imagesSet.image4 = imagesSet.makeDefaultImage()
		imagesSet.setLayout(layout: imagesSet.layout)
		setGridViewLayout()
	}
}
