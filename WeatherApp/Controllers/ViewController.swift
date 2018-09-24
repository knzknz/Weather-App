import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var forecasts = [Forecast]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadForecast()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self    }
    
    func loadForecast() {
        ForecastAPIClient.manager.getForecast(completionHandler: { (forecasts) in
            self.forecasts = forecasts
        }, errorHandler: {print($0)})
    }
}


//MARK: - Collection View Setup
extension ViewController:  UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecasts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell", for: indexPath) as! ForecastCell
        cell.backgroundColor = UIColor.init(red: 0.49, green: 0.75, blue: 0.91, alpha: 1)
        
        cell.dateLabel.text = forecasts[indexPath.row].dateTimeISO.components(separatedBy: "T")[0]
        cell.highLabel.text = "\(forecasts[indexPath.row].maxTempF)°F"
        cell.lowLabel.text = "\(forecasts[indexPath.row].minTempF)°F"
        cell.iconView.image = UIImage(named: forecasts[indexPath.row].icon)

        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width / CGFloat(2.0) , height: collectionView.bounds.height)
    }
}
