//
//  TestTableViewController.swift
//  ExpandCollapse
//
//  Created by Don Mag on 5/6/19.
//  Copyright © 2019 Don Mag. All rights reserved.
//

import UIKit

class FaqLabelCell: UITableViewCell {
	
	@IBOutlet var questionLabel: UILabel!
	@IBOutlet var answerLabel: UILabel!
	@IBOutlet var arrowImageView: UIImageView!

	// the answer label is embedded in the sizingView
	@IBOutlet var sizingView: UIView!
	@IBOutlet var sizingViewExpandedHeightConstraint: NSLayoutConstraint!
	@IBOutlet var sizingViewCollapsedHeightConstraint: NSLayoutConstraint!

	// this sits at the bottom of the cell, to cover any visible answer text while row is collapsed
	@IBOutlet var coverView: UIView!
	
	var expanded: Bool = false {
		didSet {
			// set constraint priorities and arrow image based on expanded True or False
			sizingViewCollapsedHeightConstraint.priority = .init(expanded ? 1 : 999)
			sizingViewExpandedHeightConstraint.priority = .init(expanded ? 999 : 1)
			arrowImageView.image = UIImage(named: expanded ? "arrowUp" : "arrowDn")

			// set background color
			var c = expanded ?
				UIColor(red: 227.0 / 255.0, green: 241.0 / 255.0, blue: 254.0 / 255.0, alpha: 1.0)
				:
				UIColor.white
			
			contentView.backgroundColor = c
			coverView.backgroundColor = c
			
			// set question text color
			c = expanded ?
				UIColor(red: 35.0 / 255.0, green: 144.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
				:
				UIColor.black
			
			questionLabel.textColor = c
			
			// set question font to bold or light
			if let fs = questionLabel.font {
			
				questionLabel.font = expanded ?
					UIFont.systemFont(ofSize: fs.pointSize, weight: .bold)
					:
					UIFont.systemFont(ofSize: fs.pointSize, weight: .light)
	
			}
		}
	}

}

class TestTableViewController: UITableViewController {

	var theFAQs: [String] = [String]()
	var theAnswers: [String] = [String]()

	// track which rows are expanded
	var expandedRows: [Bool]!
	
	// set to
	//	true to allow only one row expanded at a time
	//	false to allow multiple rows expanded
	var singleExpand: Bool = true
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// first FAQ question
		theFAQs.append("What is a FAQ?")
		
		// add 20 numbered questions
		for i in 1...20 {
			theFAQs.append("FAQ Question \(i)?")
		}
		
		// first FAQ answer
		theAnswers.append("A FAQ is a Freqently Asked Question. You can find examples of this all over the World Wide Web and in Applications. Usually found in a \"Help\" section.")
		
		// add 20 numbered answers
		for i in 1..<theFAQs.count {
			theAnswers.append("This is the answer to FAQ Question \(i)?")
		}
		
		// we'll change a few answers to enough text to wrap onto multiple rows
		theFAQs[3].append(" (long answer)")
		theAnswers[3] = "Here is a longer answer to question 3. It helps to demonstrate the auto-sizing behavior when the text wraps onto multiple rows."
		theFAQs[8].append(" (long answer)")
		theAnswers[8] = "This answer to question 8 has some\nembedded line-feeds\nto manually generate\nseveral rows."
		theFAQs[11].append(" (really long answer)")
		theAnswers[11] = "The answer to question 11 is really, really long. We're doing this just to see how the UI will look when the answer has a bunch of text.\n\nWe've also added embedded line-breaks for blank lines within this answer.\n\nThis is the last line of the answer to question number 11."
		theFAQs[14].append(" (long answer)")
		theAnswers[14] = "This answer to question 14 also has some\nembedded line-feeds\nto manually generate\nseveral rows."

		// and set one question to be long enough to wrap
		theFAQs[5] = "This FAQ question will demonstrate that it also handles word-wrapping."
		theAnswers[5] = "Along with the wrapping question, this answer is long enough to wrap."

		// init with all rows collapsed
		expandedRows = Array(repeating: false, count: theFAQs.count)
		
		// separator lines full width
		tableView.separatorInset = .zero
		
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theFAQs.count
    }

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "FaqLabelCell", for: indexPath) as! FaqLabelCell
		
		// set the question and answer labels
		cell.questionLabel.text = theFAQs[indexPath.row]
		cell.answerLabel.text = theAnswers[indexPath.row]
		
		// tell the cell to configure itself as expanded or not
		cell.expanded = expandedRows[indexPath.row]
		
		// disable row highlighting
		cell.selectionStyle = .none
		
		return cell
		
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		if let c = tableView.cellForRow(at: indexPath) as? FaqLabelCell {
			tableView.beginUpdates()
			c.expanded = !c.expanded
			expandedRows[indexPath.row] = c.expanded
			tableView.endUpdates()
		}
		
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		
		if singleExpand {
			if let c = tableView.cellForRow(at: indexPath) as? FaqLabelCell {
				tableView.beginUpdates()
				c.expanded = false
				expandedRows[indexPath.row] = c.expanded
				tableView.endUpdates()
			}
		}
		
	}
	
}
