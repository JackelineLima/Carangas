//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 31/07/22.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Carangas!

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(car.price)"
            scGasType.selectedSegmentIndex = car!.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        if car == nil {
            car = Carangas()
        }
        car?.name = tfName.text!
        car?.brand = tfBrand.text!
        car?.price = Double(tfPrice.text ?? "0")!
        car?.gasType = scGasType.selectedSegmentIndex
        
        if car?.id == nil {
            CarangasBusiness.save(car: car!) { _ in
                self.goBack()
            }
        } else {
            CarangasBusiness.upDate(car: car!) { _ in
                self.goBack()
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
