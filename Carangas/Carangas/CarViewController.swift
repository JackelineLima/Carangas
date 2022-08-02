//
//  CarViewController.swift
//  Carangas
//
//  Created by Jackeline Pires De Lima on 31/07/22.
//
import Foundation
import UIKit
import WebKit

class CarViewController: UIViewController {

    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var car: Carangas?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadInfoView()
    }
    
    private func loadInfoView() {
        title = car?.name
        lbBrand.text = car?.brand
        lbGasType.text = car?.gas
        lbPrice.text = "R$ \(car?.price)"
        
        let name = (title! + "+" + (car?.brand ?? "")).replacingOccurrences(of: "", with: "+")
        let urlString = "https://www.google.com.br/search?q=\(name)&tbm=isch"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        //usar swip da esquerda para direita
        webView.allowsBackForwardNavigationGestures = true
        //pre visualizar um link
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? AddEditViewController
        vc?.car = car
    }
}

extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
