//
//  UIScrollView+Extensions.swift
//  RBT
//
//  Created by WSLOSX121 on 03/02/2021.
//

import Foundation
import UIKit
import EmptyDataSet_Swift

extension UIScrollView {
    
    func showEmptyDataSet(title: String = "",
                          description: String = "",
                          buttonTitle: String = "",
                          image: UIImage = UIImage(),
                          backgroundColor: UIColor = UIColor.clear,
                          customButtonImage: UIImage? = nil,
                          verticalOffset:CGFloat=0,
                          onButtonPressed: (()->())? = nil,
                          descTextColor: UIColor = UIColor.primary,
                          titleTextColor: UIColor =  UIColor.textPrimary_33_F2, space: CGFloat = 18, onViewTap: (()->())? = nil) {
        
//        let titleAttributes = [NSAttributedString.Key.font: FontUI.font(TargetFont.primary.weight(.medium), size: 15),
//                               NSAttributedString.Key.foregroundColor: titleTextColor]
        let titleAttributes = [NSAttributedString.Key.foregroundColor: titleTextColor]

        let titleString = NSAttributedString(string: title, attributes: titleAttributes)
        let descriptionAttribues = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                                     NSAttributedString.Key.foregroundColor: descTextColor
        ]
        let detailString = NSAttributedString(string: description, attributes: descriptionAttribues)
        let buttonTitleAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0),
            NSAttributedString.Key.foregroundColor :  UIColor.primary
        ]
        
        let buttontitleString = NSAttributedString(string: (buttonTitle==nil ? "":buttonTitle), attributes: buttonTitleAttributes)
        var buttonImage:UIImage = UIImage()
        if customButtonImage != nil {
            buttonImage = customButtonImage!
        } else {
            if buttonTitle != nil {
                // buttonImage = (UIImage.init(named: "albania-backgroumd-button")?.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withAlignmentRectInsets(rectInsets))!
            }
            
        }
        let capInsets = UIEdgeInsets(top: 25, left: 100, bottom: 25, right: 100)
        let rectInsets = UIEdgeInsets(top: 0, left: -70, bottom: 0, right: -70)
        emptyDataSetView { view in
            view.titleLabelString(titleString)
                .detailLabelString(detailString)
                .image(image)
                .dataSetBackgroundColor(backgroundColor)
                .buttonTitle(buttontitleString, for: .normal)
                .buttonImage(buttonImage, for: .normal)
                .shouldFadeIn(true)
                .isTouchAllowed(true)
                .isScrollAllowed(false)
                .verticalSpace(space)
                .verticalOffset(verticalOffset)
                .isImageViewAnimateAllowed(false)
                .didTapDataButton {
                    onButtonPressed?()
                }
            view.addTapGesture {
                onViewTap?()
            }
        }
        reloadEmptyDataSet()
    }
    
    func startLoading(title: String? = nil, loaderImageName: String = "loading", offset: CGFloat) {
        var titleAttributedString:NSAttributedString?
        if let title = title {
            let titleAttributes = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
            titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)
        }
        
        let animation = CABasicAnimation.init(keyPath: "transform")
        animation.fromValue = NSValue.init(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue.init(caTransform3D: CATransform3DMakeRotation(.pi/2, 0.0, 0.0, 1.0))
        animation.duration = 0.25
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        emptyDataSetView { view in
            let image = UIImage(named: loaderImageName)
            
            image?.accessibilityFrame.size.width = 40
            
            view.titleLabelString(titleAttributedString)
                .image(image)
                .imageAnimation(animation)
                .dataSetBackgroundColor(UIColor.clear)
                .shouldFadeIn(true)
                .verticalSpace(18)
                .verticalOffset(offset)
                .isTouchAllowed(true)
                .isScrollAllowed(false)
                .isImageViewAnimateAllowed(true)
            
            
            
        }
        reloadEmptyDataSet()
    }
}
