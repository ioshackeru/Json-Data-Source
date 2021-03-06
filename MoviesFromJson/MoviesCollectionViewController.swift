//
//  MoviesCollectionViewController.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 24/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit


//remove this line if you don't cerate the cells from code. (We use the story board)
//private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {
    
    var movies = [Movie]() //new Movie Array()...
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ////navigationController.toolb wait for xcode auto complete
        navigationController?.setToolbarHidden(true, animated: false)
        //navigationController?.isToolbarHidden = true
        
        
        //navigationController?.setToolbarHidden(true, animated: false)
        MoviesDataSource.getMovies { (movies) in
            self.movies = movies
            self.collectionView?.reloadData()
        }
        
        //get the Layout as! FlowLayout: (The Layout has the itemSize property that we need to set)
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        let factor = CGFloat(3)
        //Detemine the item size:
        let itemHeight = ((collectionView?.frame.size.height)!  / factor )
        let itemWidth = ((collectionView?.frame.size.width)! / factor)
        layout.itemSize.width = itemWidth
        layout.itemSize.height = itemHeight
        
        
        //hide the insert item button / show the edit button
        //toggles into editing mode
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        //self.navigationItem.rightBarButtonItem?.isEnabled = !isEditing
    }
    /*
     override  func scrollViewDidScroll(_ scrollView: UIScrollView) {
     let paths = collectionView?.indexPathsForVisibleItems
     paths?.forEach { (path) -> () in
     guard let cell = self.collectionView?.cellForItem(at: path) as?
     MovieCollectionViewCell else {return}
     //let attr = collectionView?.layoutAttributesForItem(at: path)
     
     let progress = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.bounds.size.width)
     
     print(progress)
     UIView.animate(withDuration: 0.3, animations: {
     cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
     }, completion: { (completed) in
     cell.transform = CGAffineTransform.identity
     })
     }
     }
     
     */
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        //1) add a new Movie to the dataSource
        let movie = Movie(title: "Add Title", poster: "", genres: [String]())
        
        movies.insert(movie, at: 0)
        //2) notify the collection view that we added new items.
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        self.collectionView?.insertItems(at: [indexPath])
        
        
    }
    
    @IBAction func performDelete(_ sender: UIBarButtonItem) {
        
        //1) delete the items from the datasource
        guard let pathsToDelete:[IndexPath] = collectionView?.indexPathsForSelectedItems else {return}
        
        var indicesToDelete:[Int] = []
        for path in pathsToDelete{
            indicesToDelete.append(path.row)
        }
        
        
        var newMovies = [Movie]()
        
        
        for (index, movie) in movies.enumerated(){
            //if should not delete
            //append it to newMovies
            
            if !indicesToDelete.contains(index){
                newMovies.append(movie)
            }
        }
        //🔝delete the movies from the datasource
        self.movies = newMovies
        
        
        //2) tell the collectionView delete the items
        collectionView?.deleteItems(at: pathsToDelete)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing{
            navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let count = collectionView.indexPathsForSelectedItems?.count ?? 0
        let shouldHide = count == 0
        navigationController?.setToolbarHidden(shouldHide, animated: true)
    }
 
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView?.allowsMultipleSelection = isEditing
        
        //notify all your cells that we are in editing mode:

        collectionView?.indexPathsForVisibleItems.forEach({ (indexPath) in
            
            guard let cell = collectionView?.cellForItem(at: indexPath)
                as? MovieCollectionViewCell else {return}
            
            collectionView?.deselectItem(at: indexPath, animated: true)
            cell.isEditing = isEditing
        })
        
        if !editing{
            navigationController?.setToolbarHidden(true, animated: true)
        }
    }

    /*
     override func setEditing(_ editing: Bool, animated: Bool) {
     super.setEditing(editing, animated: animated)
     
     //Now We would like to iterate over all the cells in the collection view.
     //set their isEditing property.  (We need only iterate the visible cells since cells are recycled!!!
     // for the new cells to come, we should set their property in cell for item at index path
     
     collectionView?.allowsMultipleSelection  = editing
     
     self.navigationItem.rightBarButtonItem?.isEnabled = !editing
     
     collectionView?.visibleCells.forEach({ (cell) in
     guard let cell = cell as? MovieCollectionViewCell else {return}
     //memory erasure :) //we could also iterate over collectionView?.indexPathsForVisibleItems
     
     collectionView?.deselectItem(at: collectionView!.indexPath(for: cell)!, animated: false)
     cell.isEditing = editing
     })
     }
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        // Configure the cell
        let movie = movies[indexPath.item]
        
        let url = URL(string: movie.poster)
        
        cell.posterImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "place"))
        cell.isEditing = isEditing
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 canMoveItemAt indexPath: IndexPath) -> Bool {
        return  isEditing
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView,
                                 moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let from = sourceIndexPath.item
        let to = destinationIndexPath.item
        
        let movieToRemove = movies.remove(at: from)
        movies.insert(movieToRemove, at: to)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
