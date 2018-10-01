//
//  ViewController.swift
//  Instagrid
//
//  Created by David DUBEZ on 03/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
	UIGestureRecognizerDelegate {

    // MARK: - OUTLET
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var stackGrid: UIStackView!
	@IBOutlet weak var swipeView: SwipeView!
	@IBOutlet weak var gridView: UIView!

	// MARK: - PROPERTIES
    var imagesSet = ImagesSet()
	var lastButtonTappedLocation = (row: 0, column: 0)
	var buttonToMove = UIView()
	var buttonToMoveRow = 0
	var buttonToMoveColumn = 0
	var gridFrames = [[CGRect]]()

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

		// Gesture recognizer for sharing grid images
		let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGrid(_:)))
		leftSwipeGestureRecognizer.direction = .left
		leftSwipeGestureRecognizer.delegate = self
		gridView.addGestureRecognizer(leftSwipeGestureRecognizer)

		let upSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGrid(_:)))
		upSwipeGestureRecognizer.direction = .up
		upSwipeGestureRecognizer.delegate = self
		gridView.addGestureRecognizer(upSwipeGestureRecognizer)

		// Gesture recognizer for erase grid images (BONUS1)
		let eraseAllGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayAlertToEraseAllImage))
		eraseAllGestureRecognizer.numberOfTapsRequired = 2
		eraseAllGestureRecognizer.numberOfTouchesRequired = 2
		eraseAllGestureRecognizer.delegate = self
		self.view.addGestureRecognizer(eraseAllGestureRecognizer)

		// Gesture recognizer for move images (BONUS2)
		let gridViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveButtonGrid(sender:)))
		gridViewPanGestureRecognizer.require(toFail: leftSwipeGestureRecognizer)
		gridViewPanGestureRecognizer.require(toFail: upSwipeGestureRecognizer)
		gridViewPanGestureRecognizer.delegate = self
		gridView.addGestureRecognizer(gridViewPanGestureRecognizer)
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
            // loop that remove all subviews from the stackView and from the view hierarchy
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
				imageButton.imageView!.contentMode = .scaleAspectFill
				imageButton.addTarget(self, action: #selector(imageButtonTapped(sender:)), for: .touchUpInside)
				subStackView.addArrangedSubview(imageButton)
			}
            stackGrid.addArrangedSubview(subStackView)
        }
    }

	func imageButtonTapped(sender: UIButton) {
		// method that runs when one of the images buttons is tapped
		lastButtonTappedLocation = (findButtonTapped(sender: sender).row, findButtonTapped(sender: sender).column)
		displayAlertToChangeImage()
	}

	private func findButtonTapped(sender: UIButton) -> (row: Int, column: Int) {
		//method that find the location of the button that was tapped
		var buttonRow = 0
		var buttonColomn = 0
		for row in 0..<imagesSet.images.count {
			for column in 0..<imagesSet.images[row].count where stackGrid.arrangedSubviews[row].subviews[column] == sender {
				buttonRow = row
				buttonColomn = column
			}
		}
		return (buttonRow, buttonColomn)
	}

	func displayAlertToChangeImage() {
		// function for use a photo from the photo library
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self

		let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let photoLibraryAction = UIAlertAction(title: "photo library", style: .default, handler: {_ in
				imagePicker.sourceType = .photoLibrary
				self.present(imagePicker, animated: true, completion: nil)
			})
			alertController.addAction(photoLibraryAction)
			}

		alertController.addAction(cancelAction)

		present(alertController, animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
		// function that capture image that user selected in his phone library
		if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imagesSet.replaceImage(imageToChangeLocation: lastButtonTappedLocation, with: selectedImage)
			setGridViewLayout()
			dismiss(animated: true, completion: nil)
		}
	}

	func swipeGrid(_ sender: UISwipeGestureRecognizer) {
		// function that swipe the grid if the gesture is up of left depending of orientation screen
		switch sender.direction {
		case UISwipeGestureRecognizerDirection.up where UIApplication.shared.statusBarOrientation.isPortrait :
			animateExitOfGridView(inDirectiononx: 0, ony: -UIScreen.main.bounds.height)
		case UISwipeGestureRecognizerDirection.left where UIApplication.shared.statusBarOrientation.isLandscape :
			animateExitOfGridView(inDirectiononx: -UIScreen.main.bounds.width, ony: 0)
		default :
			break
		}
	}

	private func animateExitOfGridView(inDirectiononx: CGFloat, ony: CGFloat) {
		// function that animate the gridView
		let translationTranform = CGAffineTransform(translationX: inDirectiononx, y: ony)
		UIView.animate(withDuration: 0.5, animations: {self.gridView.transform = translationTranform},
					   completion: {(success) in
			if success {
				self.shareGrid()
			}
		})
	}

	private func animateBackOfGridView() {
		// function that animate gridView back
		UIView.animate(withDuration: 0.5, animations: {self.gridView.transform = .identity}, completion: nil)
	}

	private func shareGrid() {
		// function for share the grid image 
		let capturedGridView = UIGraphicsImageRenderer(size: gridView.bounds.size)
		let imagecapturedGridView = capturedGridView.image {_ in gridView.drawHierarchy(
			in: gridView.bounds, afterScreenUpdates: true)
		}
		let activityController = UIActivityViewController(activityItems: [imagecapturedGridView], applicationActivities: nil)
		activityController.completionWithItemsHandler = {(activityType, completed, returnedItems, error) in
				self.animateBackOfGridView()
		}
		present(activityController, animated: true, completion: nil)

	}

	private func setAllImagesToDefault() {
		// function that set all images to default and refresh the grid
		imagesSet.image1 = imagesSet.makeDefaultImage()
		imagesSet.image2 = imagesSet.makeDefaultImage()
		imagesSet.image3 = imagesSet.makeDefaultImage()
		imagesSet.image4 = imagesSet.makeDefaultImage()
		imagesSet.setLayout(layout: imagesSet.layout)
		setGridViewLayout()
	}

	// MARK: - BONUS 1:
	func displayAlertToEraseAllImage() {
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

	// MARK: - BONUS 2:
	@objc func moveButtonGrid(sender: UIPanGestureRecognizer) {
		// method that runs when one of the images buttons is touched with pan gesture
		switch sender.state {
		case .began:
			buttonToMoveRow = findButtonPan(sender: sender).row
			buttonToMoveColumn = findButtonPan(sender: sender).column
			buttonToMove = stackGrid.arrangedSubviews[buttonToMoveRow].subviews[buttonToMoveColumn]
		case .changed:
			let transform = CGAffineTransform(translationX: sender.translation(in: gridView).x,
											  y: sender.translation(in: gridView).y)
			buttonToMove.transform = transform
			buttonToMove.layer.opacity = 0.8
			buttonToMove.layer.shadowOpacity = 1
			buttonToMove.layer.shadowOffset = CGSize(width: 10, height: 10)
			buttonToMove.layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
			buttonToMove.layer.zPosition = 1
		case .ended:
			for rowTarget in 0..<gridFrames.count {
				for columnTarget in 0..<gridFrames[rowTarget].count {
					let target = gridFrames[rowTarget][columnTarget]
					if target.contains(sender.location(in: stackGrid)) {
						imagesSet.replaceImage(imageToChangeLocation: (row: rowTarget, column: columnTarget),
											   with: imagesSet.images[buttonToMoveRow][buttonToMoveColumn])
						setGridViewLayout()
					}
				}
			}
			moveButtonEnded()
		default:
			break
		}
	}

	private func moveButtonEnded() {
		// method that animate the return of the button moved
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
					   initialSpringVelocity: 2.0, options: [], animations: {
			self.buttonToMove.transform = .identity
			self.buttonToMove.layer.opacity = 1
			self.buttonToMove.layer.shadowOpacity = 0
			self.buttonToMove.layer.zPosition = 0
		}, completion: nil)
	}

	private func findButtonPan(sender: UIPanGestureRecognizer) -> (row: Int, column: Int) {
		//method that find the location of the button that was paned
		gridFrames = listFramesFor()
		var buttonRow = 0
		var buttonColomn = 0
		for row in 0..<imagesSet.images.count {
			for column in 0..<imagesSet.images[row].count {
				let target = stackGrid.arrangedSubviews[row].convert(
					stackGrid.arrangedSubviews[row].subviews[column].frame,
					to: stackGrid)
				if target.contains(sender.location(in: stackGrid)) {
					buttonRow = row
					buttonColomn = column
				}
			}
		}
		return (buttonRow, buttonColomn)
	}

	private func listFramesFor() -> [[CGRect]] {
		// method that set the list of button frames in the grid before moving a button
		var frames = [[CGRect]]()
		for row in 0..<imagesSet.images.count {
			frames.append([])
			for column in 0..<imagesSet.images[row].count {
				let target = stackGrid.arrangedSubviews[row].convert(
					stackGrid.arrangedSubviews[row].subviews[column].frame,
					to: stackGrid)
				frames[row].append(target)
			}
		}
		return frames
	}
}
