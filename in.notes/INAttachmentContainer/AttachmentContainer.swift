//
//  AttachmentContainer.swift
//  in.notes
//
//  Created by Michael Babiy on 6/24/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

@objc protocol AttachmentContainerDelegate
{
    func attachmentContainerDidRemoveImageWithRequest(request: Int)
}

class AttachmentContainer: UIImageView, UICollisionBehaviorDelegate, AttachmentViewDelegate {
    
    weak var delegate: AttachmentContainerDelegate?
    let attachmentView: AttachmentView!
    let animator: UIDynamicAnimator!
    
    init(frame: CGRect)
    {
        super.init(frame: frame)
        image = UIImage(named: "bg-attachment")
        userInteractionEnabled = true
        attachmentView = AttachmentView(frame: CGRectMake(10.0, self.frame.size.height + 98.0, 300.0, 196.0), delegate: self)
        addSubview(attachmentView)
        addMotionEffectToView(attachmentView, magnitude: 3.0)
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    func setAttachmentImage(image: UIImage) -> Void
    {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.attachmentView.image = UIImage.resizeImage(image, toSize: CGSizeMake(300.0, 196.0), cornerRadius: 1.0)
            self.attachmentView.frame = CGRectMake(10.0, 10.0, 300.0, 196.0)
        }, completion: nil)
    }
    
    func setAttachmentImage(image: UIImage, usingSpringWithDamping usingSpring: Bool) -> Void
    {
        if usingSpring {
            setAttachmentImage(image)
        } else {
            self.attachmentView.image = UIImage.resizeImage(image, toSize: CGSizeMake(300.0, 196.0), cornerRadius: 1.0)
            self.attachmentView.frame = CGRectMake(10.0, 10.0, 300.0, 196.0)
        }
    }
    
    func moveToPoint(point: CGPoint) -> Void
    {
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)
        }, completion: nil)
    }
    
    func moveToPoint(point: CGPoint, usingSpringWithDamping usingSpring: Bool) -> Void
    {
        if usingSpring {
            moveToPoint(point)
        } else {
            UIView.animateWithDuration(0.3, animations: {
                self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)
            })
        }
    }
    
    func addMotionEffectToView(view: UIView, magnitude: Float) -> Void
    {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        xMotion.minimumRelativeValue = (-magnitude)
        xMotion.maximumRelativeValue = (magnitude)
        yMotion.minimumRelativeValue = (-magnitude)
        yMotion.maximumRelativeValue = (magnitude)
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(motionGroup)
    }
    
    func imageDataForCurrentImage() -> NSData
    {
        return UIImageJPEGRepresentation(attachmentView.image, 0.8)
    }
    
    func imageNameForParse() -> String
    {
        return NSUUID.UUID().UUIDString
    }
    
    // AttachmentViewDelegate
    func didSelectActionSheetButtonAtIndex(index: Int) -> Void
    {
        resetDynamicAnimator()
        if index == 0 {
            resetAttachmentView()
            delegate!.attachmentContainerDidRemoveImageWithRequest(0)
        } else if (index == 1) {
            resetAttachmentView()
            delegate!.attachmentContainerDidRemoveImageWithRequest(1)
        } else if (index == 2) {
            // Action was canceled. Nothing to do.
        }
    }
    
    func resetAttachmentView() -> Void
    {
        let intermediateView = attachmentView.snapshotViewAfterScreenUpdates(false)
        insertSubview(intermediateView, aboveSubview: attachmentView)
        attachmentView.frame = CGRectMake(10.0, self.frame.size.height + 98.0, 300.0, 196.0)
        attachmentView.image = nil
        
        let items = [intermediateView]
        
        let gravity = UIGravityBehavior(items: items)
        let itemBehaviour = UIDynamicItemBehavior(items: items)
        
        itemBehaviour.angularResistance = 1.0
        itemBehaviour.addAngularVelocity(2.0, forItem: intermediateView)
        
        animator.addBehavior(itemBehaviour)
        animator.addBehavior(gravity)
    }
    
    func resetDynamicAnimator() -> Void
    {
        animator.removeAllBehaviors();
    }
}
