//
//  ViewController.swift
//  Instagrid
//
//  Created by David DUBEZ on 03/09/2018.
//  Copyright © 2018 David DUBEZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var button1: UIButton!
	@IBOutlet weak var button2: UIButton!
	@IBOutlet weak var button3: UIButton!

	@IBAction func didTapButton1() {
		layout1Choosen()
	}

	@IBAction func didTapButton2() {
		layout2Choosen()
	}

	@IBAction func didTapButton3() {
		layout3Choosen()
	}

	private func layout1Choosen () {
		button1.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		button2.setImage(nil, for: .normal)
		button3.setImage(nil, for: .normal)
	}

	private func layout2Choosen () {
		button1.setImage(nil, for: .normal)
		button2.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
		button3.setImage(nil, for: .normal)
	}
	private func layout3Choosen () {
		button1.setImage(nil, for: .normal)
		button2.setImage(nil, for: .normal)
		button3.setImage(#imageLiteral(resourceName: "Selected"), for: .normal)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}
