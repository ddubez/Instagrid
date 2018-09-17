//
//  ViewController.swift
//  Instagrid
//
//  Created by David DUBEZ on 03/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	// MARK: - OUTLET
	//creation connexion between objects in the storyboard and variables in source code

	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!
	@IBOutlet weak var stackGrid: UIStackView!

	// MARK: - PROPERTIES
	var combinedPhotos = CombinedPhotos()

	// MARK: - ACTION
	//creation connexion between controls in the storyboard and methods in source code

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
	}

	private func layout1Choosen() {
		// method that set the interface (button, grid) when layout 1 is chosen
		button1.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		button2.setImage(nil, for: .normal)
		button3.setImage(nil, for: .normal)
		combinedPhotos.setGridLayout(gridLayout: .oneHightTwoLow)
		setLayoutGrid()
	}

	private func layout2Choosen() {
		// method that set the interface (button, grid) when layout 2 is chosen
		button1.setImage(nil, for: .normal)
		button2.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		button3.setImage(nil, for: .normal)
		combinedPhotos.setGridLayout(gridLayout: .twoHightOneLow)
		setLayoutGrid()
	}

	private func layout3Choosen() {
		// method that set the interface (button, grid) when layout 3 is chosen
		button1.setImage(nil, for: .normal)
		button2.setImage(nil, for: .normal)
		button3.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		combinedPhotos.setGridLayout(gridLayout: .twoHightTwoLow)
		setLayoutGrid()
	}

	private func setLayoutGrid() {
		// method that fill the grid whith images depending of the layout chosed
		for subViews in stackGrid.arrangedSubviews {
			// function that remove all subviews from the stackView and from the view hierarchy
			stackGrid.removeArrangedSubview(subViews)
			subViews.removeFromSuperview()
		}
		var row = 0
		for _ in combinedPhotos.images {
			// loop that iterate in the array of combinedPhotos,
			// create a stackView vith the imageViews and add it to the stackGrid
			let subStackView = UIStackView(arrangedSubviews: combinedPhotos.images[row])
			subStackView.axis = .horizontal
			subStackView.alignment = .fill
			subStackView.distribution = .fillEqually
			subStackView.spacing = 8
			stackGrid.addArrangedSubview(subStackView)
			row += 1
		}
	}
}
