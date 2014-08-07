//
//  AttachmentContainer.swift
//  in.notes
//
//  Created by Michael Babiy on 6/24/14.
//  Copyright (c) 2014 in.notes. All rights reserved.
//

import UIKit

let zero: CGFloat = 0.0
let default_animation_duration = 0.3
let default_spring_damping: CGFloat = 0.8
let default_delay = 0.0
let default_jpg_quality: CGFloat = 0.8

let attachment_container_visible_frame = CGRectMake(10.0, 10.0, 300.0, 196.0)
let attachment_view_image_size = CGSizeMake(300.0, 196.0)
var attachment_view_init_frame = CGRectZero
let attachment_image_corner_radius: CGFloat = 1.0

@objc protocol AttachmentContainerDelegate
{
    func attachmentContainerDidRemoveImageWithRequest(request: Int)
}

class AttachmentContainer: UIImageView, UICollisionBehaviorDelegate, AttachmentViewDelegate {
    
    weak var delegate: AttachmentContainerDelegate?
    let attachmentView: AttachmentView!
    let animator: UIDynamicAnimator!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        attachment_view_init_frame = CGRectMake(10.0, self.frame.size.height + 98.0, 300.0, 196.0)
        image = UIImage(named: "bg-attachment")
        userInteractionEnabled = true
        attachmentView = AttachmentView(frame: attachment_view_init_frame, delegate: self)
        addSubview(attachmentView)
        addMotionEffectToView(attachmentView, magnitude: 3.0)
        animator = UIDynamicAnimator(referenceView: self)
    }
    
    func setAttachmentImage(image: UIImage) -> Void
    {
        UIView.animateWithDuration(default_animation_duration, delay: default_delay, usingSpringWithDamping: default_spring_damping, initialSpringVelocity: zero, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.attachmentView.image = UIImage.resizeImage(image, toSize: attachment_view_image_size, cornerRadius: attachment_image_corner_radius)
            self.attachmentView.frame = attachment_container_visible_frame
        }, completion: nil)
    }
    
    func setAttachmentImage(image: UIImage, usingSpringWithDamping usingSpring: Bool) -> Void
    {
        if usingSpring {
            setAttachmentImage(image)
        } else {
            self.attachmentView.image = UIImage.resizeImage(image, toSize: attachment_view_image_size, cornerRadius: attachment_image_corner_radius)
            self.attachmentView.frame = attachment_container_visible_frame
        }
    }
    
    func moveToPoint(point: CGPoint) -> Void
    {
        UIView.animateWithDuration(default_animation_duration, delay: default_delay, usingSpringWithDamping: default_spring_damping, initialSpringVelocity: zero, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)
        }, completion: nil)
    }
    
    func moveToPoint(point: CGPoint, usingSpringWithDamping usingSpring: Bool) -> Void
    {
        if usingSpring {
            moveToPoint(point)
        } else {
            UIView.animateWithDuration(default_animation_duration, animations: {
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
        return UIImageJPEGRepresentation(attachmentView.image, default_jpg_quality)
    }
    
    func imageNameForParse() -> String
    {
        return NSUUID.UUID().UUIDString
    }
    
    // AttachmentViewDelegate
    func didSelectActionSheetButtonAtIndex(index: UInt) -> Void
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
        let attachmentViewFrame = attachment_view_init_frame
        attachmentView.frame = attachmentViewFrame
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
