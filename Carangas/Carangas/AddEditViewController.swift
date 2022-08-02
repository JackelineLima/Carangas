//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 31/07/22.
//

import UIKit

class AddEditViewController: UIViewController {

    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Carangas?
    private var brands: [Brand] = []
    
    private lazy var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadBrands()
    }
    
    private func loadBrands() {
        CarangasBusiness.loadBrands { [weak self] brands in
            if let brands = brands {
                self?.brands = brands.sorted(by: {$0.nome < $1.nome})
                DispatchQueue.main.async {
                    self?.pickerView.reloadAllComponents()
                }
            }
        }
    }
    
    private func setupView() {
        if car != nil {
            tfBrand.text = car?.brand
            tfName.text = car?.name
            tfPrice.text = "\(car?.price)"
            scGasType.selectedSegmentIndex = car!.gasType
            btAddEdit.setTitle("Alterar carro", for: .normal)
        }
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let btnCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btnSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btnCancel, btnSpace, btnDone]
        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
    }
    
    @objc func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc func done() {
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].nome
        cancel()
    }
    
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
        if car == nil {
            car = Carangas()
        }
        car?.name = tfName.text!
        car?.brand = tfBrand.text!
        car?.price = Double(tfPrice.text ?? "0")!
        car?.gasType = scGasType.selectedSegmentIndex
        
        if car?.id == nil {
            CarangasBusiness.save(car: car!) { [weak self] _ in
                self?.goBack()
            }
        } else {
            CarangasBusiness.upDate(car: car!) { [weak self] _ in
                self?.goBack()
            }
        }
    }
    
    func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brands = brands[row]
        return brands.nome
    }
}
