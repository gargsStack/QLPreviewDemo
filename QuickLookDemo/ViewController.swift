//
//  ViewController.swift
//  QuickLookDemo
//
//  Created by Vivek on 2/3/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

import QuickLook

class ViewController: UIViewController {


    let itemUrl = NSURL(string: "http://www.pdf995.com/samples/pdf.pdf")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func displayFile(_ sender: UIButton){
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        self.present(previewController, animated: true, completion: nil)
        
    }
    
    func getPreviewItem() -> NSURL{
        
        let path = Bundle.main.path(forResource: "samplePDf", ofType: "pdf")
        let url = NSURL(fileURLWithPath: path!)
        
        return url
    }

}

//MARK:- QLPreviewController Datasource

extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let previewItem = self.getPreviewItem()
        return previewItem as QLPreviewItem
    }
}













