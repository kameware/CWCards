//
//  CustomCollectionViewFlowLayout.swift
//  CWCards
//
//  Created by nakamura on 2015/12/29.
//  Copyright © 2015年 Mineharu. All rights reserved.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment:CGFloat = MAXFLOAT as! CGFloat
        let horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView!.bounds) / 2.0)
        let targetRect = CGRectMake(proposedContentOffset.x,
            0.0,
            self.collectionView!.bounds.size.width,
            self.collectionView!.bounds.size.height)
        
        let array = self.layoutAttributesForElementsInRect(targetRect)
        
        for layoutAttributes:UICollectionViewLayoutAttributes in array! {
            if layoutAttributes.representedElementCategory != UICollectionElementCategory.Cell {
                continue
            }
            
            let itemHorizontalCenter = layoutAttributes.center.x
            offsetAdjustment = itemHorizontalCenter - horizontalCenter
            layoutAttributes.alpha = 0
            
            if (velocity.x < 0) {
                break
            }
        }
        
        return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
    }
}
