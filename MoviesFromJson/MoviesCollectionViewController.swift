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
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        //1) add a new Movie to the dataSource
        let movie = Movie(title: "Add Title", poster: "", genres: [String]())
        
        movies.insert(movie, at: 0)
        //2) notify the collection view that we added new items.
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        self.collectionView?.insertItems(at: [indexPath])
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MoviesDataSource.getMovies { (movies) in
            self.movies = movies
            self.collectionView?.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        //get the Layout as! FlowLayout: (The Layout has the itemSize property that we need to set)
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        //Detemine the item size:
        //        let itemHeight = ((collectionView?.frame.size.height)! / 2)
        let itemWidth = ((collectionView?.frame.size.width)! / 3)
        
        //        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        //        
        
        layout.itemSize.width = itemWidth
    }

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
        
        return cell
    }

    // MARK: UICollectionViewDelegate

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
