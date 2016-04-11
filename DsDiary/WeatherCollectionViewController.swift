//
//  WeatherCollectionViewController.swift
//  DsDiary
//
//  Created by wangenyong on 15/11/13.
//  Copyright © 2015年 ___WANGDASHUI___. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class WeatherCollectionViewController: UICollectionViewController {
    var delegate: SavingWeatherControllerDelegate?
    var weathers = [Weathers.Cloud, Weathers.Rain, Weathers.Snow, Weathers.Sun, Weathers.Wind]
    var numOfClu: CGFloat = 3

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    override func loadView() {
        super.loadView()
        
        self.flowLayout.minimumLineSpacing = 1.0
        self.flowLayout.minimumInteritemSpacing = 0.0
        
        let itmeSize: CGFloat = (240 - (numOfClu - 1)) / numOfClu
        
        //print("\(self.collectionView!.frame.size.width), \(itmeSize)")
        
        self.flowLayout.itemSize = CGSizeMake(itmeSize, itmeSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return weathers.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Weather", forIndexPath: indexPath) as! WeatherCollectionViewCell
        cell.label.text = NSLocalizedString(weathers[indexPath.row].rawValue, comment: "Weather")
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if delegate != nil {
            delegate?.saveWeather(weathers[indexPath.row])
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
}


protocol SavingWeatherControllerDelegate {
    func saveWeather(weather : Weathers)
}
