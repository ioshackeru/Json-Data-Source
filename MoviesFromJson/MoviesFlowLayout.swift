//
//  MoviesFlowLayout.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 27/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit

class MoviesFlowLayout: UICollectionViewFlowLayout {
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        if velocity.x == 0 {
            return mostRecentOffset
        }
        
        if let cv = self.collectionView {
            
            let cvBounds = cv.bounds
            let halfWidth = cvBounds.size.width * 0.5;
            
            
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
                
                var candidateAttributes : UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    // == Skip comparison with non-cell items (headers and footers) == //
                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
                        continue
                    }
                    
                    if (attributes.center.x == 0) || (attributes.center.x > (cv.contentOffset.x + halfWidth) && velocity.x < 0) {
                        continue
                    }
                    candidateAttributes = attributes
                }
                
                // Beautification step , I don't know why it works!
                if(proposedContentOffset.x == -(cv.contentInset.left)) {
                    return proposedContentOffset
                }
                
                guard let _ = candidateAttributes else {
                    return mostRecentOffset
                }
                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
                return mostRecentOffset
                
            }
        }
        
        // fallback
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        if let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath){
            
            var c: CGPoint = attributes.center
            c.y -= self.collectionViewContentSize.height
            c.x += self.collectionViewContentSize.width
            attributes.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            attributes.zIndex = 10
            
            attributes.center = c
            return attributes
            
            
            
            //            return attributes
        }
        
        return nil
    }
    
    
    
 
}

//Insets for Sections

//extension MoviesCollectionViewController : UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//         return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//    }
//}
