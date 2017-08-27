//
//  MovieCollectionViewCell.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 24/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    //put the model here
    
    //if the cell is selected: change the image accordingly
    
    //the cell should know if it's in editing mode. 
    //if in editing show the deletion image... else hide them.
    
    
    
    var isEditing:Bool = false{
        didSet{
            checkedImageView.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool{
        didSet{
            checkedImageView.image = isSelected ? #imageLiteral(resourceName: "icons8-checked") : #imageLiteral(resourceName: "icons8-unchecked")
        }
        
    }
}
