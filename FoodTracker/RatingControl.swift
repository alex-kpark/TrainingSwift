//
//  RatingControl.swift
//  FoodTracker
//
//  Created by kyung hopark on 2018. 9. 25..
//  Copyright © 2018년 Kyungho Park. All rights reserved.
//

import UIKit

//@IBDesignable을 선언해서 디자인 모양새를 바꿀 수 있음을 알려줌
@IBDesignable class RatingControl: UIStackView {

    //MARK: Properties
    //Property1 : List of buttons (outside의 개입을 막기 위해 private으로 선언)
    private var ratingButtons = [UIButton]()
    
    //Property2 : Control's rating, 외부에서 읽거나 쓰기가 가능해야 하므로 private 선언하지 않음
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    //Interface Builder에서 Property에 다양한 값을 줄 수 있도록 @IBInspectable을 선언
    //Property Observer: 단순하게 값만 바꾸는 것이 아니라, 실제로 그 값이 적용될 Object를 명시해주는 기능
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet{
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    //MARK: Initialization
    //나중에 RatingControl을 끌어다 쓸 때, 이 기능이 Initialize 되어있어야 이용이 가능하다
    override init(frame: CGRect) {
        super.init(frame: frame)
        //setupButtons도 initialize
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        //setupButtons도 initialize
        setupButtons()
    }
    
    //MARK: Private Methods
    //기존에 UIKit에서 제공하는 메소드가 아닌, 내가 Custom하여 만드는 메소드를 정의해줌
    
    //Private method이기 때문에 private을 명시해서 정의해줌
    private func setupButtons() {

        //새롭게 버튼을 업데이트 하기 전에, 기존에 있던 버튼들을 모두 없애줌
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Assets 묶음에서 버튼에 쓰일 이미지를 불러오기
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)

        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            //Create Buttons
            let button = UIButton()
            button.backgroundColor = UIColor.red
            
            //버튼의 이미지를 불러와서 어떤 상태일때 이미지를 줄 것인지 정의해둠
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add constraints
            // Auto Generate되는 Constraint를 작동하지 않게 false처리 해준다 (정의 안해주면 true, 자기가 알아서 레이아웃을 배치해버림)
            button.translatesAutoresizingMaskIntoConstraints = false

            //heightAnchor, widthAnchor는 Layout의 Anchor를 알려주는 기능을 한다
            //constraint를 내가 놓고 싶은 곳에 맞게 만드는 기능을 함 (view로부터 얼마나 떨어져 있을지를 지정해줌)
            //.isActive는 constraint를 작동시킬지 작동시키지 않을지 결정하는 역할을 함
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            //Setup the button action (버튼 눌렀을 때 하는 Action을 정의)
            //Target은 self, 즉 RatingControl object를 의미한다
            //#selector는 button이 눌렸을 때 System이 action method를 불러오라는 명령을 정의해주는 것
            //.touchUpInside는 UIControlEvents의 한 종류로, 버튼을 누른채로 움직이면 Action을 줄 수 있음
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // Add the button to stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }
    
    //Mark: Button Action
    
    @objc func ratingButtonTapped(button: UIButton){

        //유저가 선택한 별의 index(순서)에 따라 숫자를 return하는 indexing 구현
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }

        //Calculate the rating of the selected button
        //0번째 누르면 1을 return, 3번째 누르면 4를 return
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
    
    }

    //버튼의 Appearance를 update하는 기능
    //5개 찍었다가 3개짜리 찍으면, 3개로 업데이트 하는 기능
    private func updateButtonSelectionStates() {
        
        for (index, button) in ratingButtons.enumerated() {
            
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
            
            
        }
    }
}
