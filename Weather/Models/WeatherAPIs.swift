//
//  WeatherAPIModel.swift
//  Weather
//
//  Created by Mac on 18/05/1443 AH.
//

import Foundation

class WeatherAPIs {
    
    static func getAllWeatherData(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
       
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=25.8759&lon=45.3731&appid=f2763f64328617a339894577e9107052&units=metric")
        

        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        
        task.resume()
        
    }

}
