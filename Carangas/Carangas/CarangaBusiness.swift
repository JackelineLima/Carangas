//
//  CarangaBusiness.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 01/08/22.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noRespose
    case noData
    case responseStatusCode(code: Int)
    case invalidJson
}

enum Operation {
    case save
    case update
    case delete
}

class CarangasBusiness {
    
    private static let BASE_URL = "https://carangas.herokuapp.com/cars"
    
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        //sessao funciona 3g ou 4g
        config.allowsCellularAccess = false
        //minha api nesta sessão são do tipo json
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        //tempo para a requisicao funcionar, se não ela vai ser cancelada
        config.timeoutIntervalForRequest = 30.0
        // 5 tarefas nessa sessao ao mesmo tempo
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
    class func loadCars(onCompletion: @escaping ([Carangas]) -> Void, onError: @escaping (CarError) -> Void) {
        guard let url = URL(string: BASE_URL) else {
            onError(.url)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noRespose)
                    return
                }
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onError(.noData)
                        return
                    }

                    do {
                        let response = try JSONDecoder().decode([Carangas].self, from: data)
                        onCompletion(response)
                    } catch {
                        onError(.invalidJson)
                    }
                    
                } else {
                    onError(.responseStatusCode(code: response.statusCode))
                }

            } else {
                onError(.taskError(error: error!))
            }
        }
        task.resume()
    }
    
    class func loadBrands(onCompletion: @escaping ([Brand]?) -> Void) {
        guard let url = URL(string: "https://parallelum.com.br/fipe/api/v1/carros/marcas") else {
            onCompletion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onCompletion(nil)
                    return
                }
                
                if response.statusCode == 200 {
                    guard let data = data else {
                        onCompletion(nil)
                        return
                    }

                    do {
                        let response = try JSONDecoder().decode([Brand].self, from: data)
                        onCompletion(response)
                    } catch {
                        onCompletion(nil)
                    }
                    
                } else {
                    onCompletion(nil)
                }

            } else {
                onCompletion(nil)
            }
        }
        task.resume()
    }
    
    class func save(car: Carangas, onCompletion: @escaping (Bool) -> Void) {
        apply(car: car, operation: .save, onCompletion: onCompletion)
    }
    
    class func delete(car: Carangas, onCompletion: @escaping (Bool) -> Void) {
        apply(car: car, operation: .delete, onCompletion: onCompletion)
    }
    
    
    class func upDate(car: Carangas, onCompletion: @escaping (Bool) -> Void) {
        apply(car: car, operation: .update, onCompletion: onCompletion)
    }
    
    private class func apply(car: Carangas, operation: Operation, onCompletion: @escaping (Bool) -> Void) {
        let urlBase = BASE_URL + "/" + (car.id ?? "")
        guard let url = URL(string: urlBase) else {
            onCompletion(false)
            return
        }
        
        var http = ""
        switch operation {
        case .save:
            http = "POST"
        case .update:
            http = "PUT"
        case .delete:
            http = "DELETE"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = http
        do {
            let json = try JSONEncoder().encode(car)
            request.httpBody = json
        } catch {
            onCompletion(false)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil {
                guard let _ = response as? HTTPURLResponse, let _ = data else {
                    onCompletion(false)
                    return
                }
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
        task.resume()
    }
}
