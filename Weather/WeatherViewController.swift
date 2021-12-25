//
//  ViewController.swift
//  Weather
//
//  Created by Mac on 18/05/1443 AH.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var weather: Weather?
    var hourArray : [Current]?
    var dailyArray : [Daily]?
    
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var highTemperature: UILabel!
    @IBOutlet weak var lowTemperature: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var HourlyCollectionView: UICollectionView!
    @IBOutlet weak var DailyCollectionView: UICollectionView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        HourlyCollectionView.dataSource = self
        HourlyCollectionView.delegate = self
        DailyCollectionView.dataSource = self
        DailyCollectionView.delegate = self
        

        self.cityName.text = "Riyadh"
        getData()
        
        collectionViewBorder()
        
    }
    
    
    func getData()  {
        
        WeatherAPIs.getAllWeatherData(completionHandler: {
            // see: Swift closure expression syntax
            data, response, error in
            print("in here get")
            
            // see: Swift nil coalescing operator (double questionmark)
            print(data ?? "no data get") // the "no data" is a default value to use if data is nil
            
            guard let myData = data else { return }
            do {
                
                let decoder = JSONDecoder()
                let jsonResult = try decoder.decode(Weather.self, from: myData)
                
                DispatchQueue.main.async {
                    self.weather = jsonResult
                    self.temperature.text = "\(String(Int(jsonResult.current.temp)))°"
                    self.weatherDescription.text = "\(jsonResult.current.weather[0].main)"
                    self.highTemperature.text = "H: \(String(Int(jsonResult.daily[0].temp.max)))° "
                    self.lowTemperature.text = "  L: \(String(Int(jsonResult.daily[0].temp.min)))°"
                    guard let img = self.loadImage(ImageUrl:jsonResult.current.weather[0].icon) else{return }
                    self.weatherImage.image = UIImage(data:img)
                    
                    self.hourArray = (self.weather?.hourly)!
                    self.dailyArray = (self.weather?.daily)!
                    
                    self.HourlyCollectionView.reloadData()
                    self.DailyCollectionView.reloadData()
                    
                    
                }
            } catch {
                print(error)
            }
        })
        
    }
    
    func loadImage(ImageUrl: String) -> Data?{
        
        print("----- \(ImageUrl)")
        //09n
        let imURL = "https://openweathermap.org/img/wn/\(ImageUrl)@2x.png"
        
        print(imURL)
        
        guard let url = URL(string: imURL) else {return Data()}
        
        if let data = try? Data(contentsOf: url){
            
            return data
            
        }
        return nil
    }
    
}


extension WeatherViewController: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView ==  HourlyCollectionView{
            guard let hourArray = hourArray else { return 0 }
            return hourArray.count}
        else {
              guard let dailyArray = dailyArray else { return 0 }
              return dailyArray.count
            }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if collectionView ==  HourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourCell", for: indexPath) as! HourlyCollectionViewCell
            guard let hourArray =  hourArray else { return cell }
            
            cell.hourLabel.text = timeFormatter(Time: hourArray[indexPath.item].dt)
            cell.tempLabel.text = "\(String(describing: hourArray[indexPath.item].temp))"
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCell", for: indexPath) as! DailyCollectionViewCell
            
            guard let dailyArray =  dailyArray else { return cell }
          
            cell.dayLabel.text = getDayName(date: dailyArray[indexPath.item].dt)
            cell.descriptionLabel.text = dailyArray[indexPath.row].weather[0].weatherDescription
            
            cell.minTemp.text = "\(Int(dailyArray[indexPath.row].temp.min))°"
            cell.maxTemp.text = "\(Int(dailyArray[indexPath.row].temp.max))°"

            return cell
            
            
        }
    }
    func timeFormatter(Time seconds: Int) -> String{
        let  formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
       let date = Date(timeIntervalSince1970: Double(seconds))
        
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    func getDayName(date:Int)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
     
        let  formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
       let convertedDate = Date(timeIntervalSince1970: Double(date))
        
        let dayInWeek = dateFormatter.string(from: convertedDate)
        return dayInWeek
    }
    
    func collectionViewBorder() {
      
        HourlyCollectionView.layer.borderWidth = 1.0
        HourlyCollectionView.layer.cornerRadius = 5.0
        HourlyCollectionView.layer.borderColor = UIColor.white.cgColor
        DailyCollectionView.layer.borderWidth = 1.0
        DailyCollectionView.layer.cornerRadius = 5.0
        DailyCollectionView.layer.borderColor = UIColor.white.cgColor
    }
    
    
}
