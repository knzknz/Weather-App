import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var conversionControl: UISegmentedControl!
    
    @IBOutlet weak var backgroundView: UIImageView!
    
    
    var forecasts = [Forecast]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadForecast()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
    }
    
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
        
        cell.backgroundColor = UIColor.init(red: 131/255, green: 129/255, blue: 107/255, alpha: 0.75)
        cell.dateLabel.text = forecasts[indexPath.row].dateTimeISO.components(separatedBy: "T")[0]
        cell.iconView.image = UIImage(named: forecasts[indexPath.row].icon)
        
        //set up temperature conversion
        if conversionControl.selectedSegmentIndex == 0 {
            cell.highLabel.text = "\(forecasts[indexPath.row].maxTempF)°F"
            cell.lowLabel.text = "\(forecasts[indexPath.row].minTempF)°F"
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            cell.highLabel.text = "\(forecasts[indexPath.row].maxTempC)°C"
            cell.lowLabel.text = "\(forecasts[indexPath.row].minTempC)°C"
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width / CGFloat(2.0) , height: collectionView.bounds.height)
    }
}
