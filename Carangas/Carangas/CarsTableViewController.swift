//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 31/07/22.
//

import UIKit

class CarsTableViewController: UITableViewController {
    
    var cars: [Carangas] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CarangasBusiness.loadCars { [weak self] response in
            self?.cars = response
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        } onError: { error in
            switch error {
            case .invalidJson:
                print("json invalido")
            case .responseStatusCode(code: 400):
                print("status code 400")
            case .noData:
                print("Dados errado")
            default:
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            let vc = segue.destination as? CarViewController
            //carro selecionado na tabela
            vc?.car = cars[tableView.indexPathForSelectedRow!.row]
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            CarangasBusiness.delete(car: car) { sucess in
                if sucess {
                    self.cars.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
