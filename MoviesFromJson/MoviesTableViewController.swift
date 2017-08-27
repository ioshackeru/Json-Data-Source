//
//  MoviesTableViewController.swift
//  MoviesFromJson
//
//  Created by Tomer Buzaglo on 21/08/2017.
//  Copyright © 2017 iTomerBu. All rights reserved.
//

import UIKit
import SDWebImage


class MoviesTableViewController: UITableViewController {
    
    var movies = [Movie]()
    var indicator:UIActivityIndicatorView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addIndicator()
        MoviesDataSource.getMovies { (movies) in
            //do what you want with movies:
            self.movies = movies
            self.tableView.reloadData()
            self.indicator?.stopAnimating()
        }
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    func addIndicator(){
        let screenWidth = self.view.frame.width
        let screenHeight = self.view.frame.height
        
        let halfWidth = screenWidth / 2
        let halfHeight = screenHeight / 2
        
        let xPos = halfWidth - 15
        let yPos = halfHeight - 15
        
        let origin = CGPoint(x: xPos, y: yPos)
        
        let rect = CGRect(origin: origin, size: CGSize(width: 30, height: 30))
        
        self.indicator = UIActivityIndicatorView(frame: rect)
        self.indicator?.startAnimating()
        self.view.addSubview(indicator!)
    }
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieTableViewCell
        
        // Configure the cell...
        let movie = movies[indexPath.row]
        
        cell.movieTitle?.text = movie.title
        cell.movieGenre?.text = movie.genres[0]
        
        //https://...movie.poster
        cell.moviePoster.sd_setImage(with: URL(string: movie.poster), placeholderImage: #imageLiteral(resourceName: "place"))
        
        roundCornersForView(view: cell.moviePoster)
        return cell
    }
    
    func roundCornersForView(view:UIView){
        view.clipsToBounds  = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        performSegue(withIdentifier: "masterToDetail", sender: movie)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let sender = sender as? Movie, let dest = segue.destination as? MovieDetailsViewController{
            dest.data = sender
        }
    }
    
    
}













