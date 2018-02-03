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
    
    lazy var previewItem = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func displayLocalFile(_ sender: UIButton){
        
        let previewController = QLPreviewController()
        // Set the preview item to display
        self.previewItem = self.getPreviewItem(withName: "samplePDf.pdf")
        
        previewController.dataSource = self
        self.present(previewController, animated: true, completion: nil)
        
    }
    
    @IBAction func displayFileFromUrl(_ sender: UIButton){
        
        // Download file
        self.downloadfile(completion: {(success, fileLocationURL) in
            
            if success {
                // Set the preview item to display======
                self.previewItem = fileLocationURL! as NSURL
                // Display file
                let previewController = QLPreviewController()
                previewController.dataSource = self
                self.present(previewController, animated: true, completion: nil)
            }else{
                debugPrint("File can't be downloaded")
            }
        })
    }
    
    
    
    func getPreviewItem(withName name: String) -> NSURL{
        
        //  Code to diplay file from the app bundle
        let file = name.components(separatedBy: ".")
        let path = Bundle.main.path(forResource: file.first!, ofType: file.last!)
        let url = NSURL(fileURLWithPath: path!)
        
        return url
    }
    
    func downloadfile(completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        
        let itemUrl = URL(string: "https://images.apple.com/environment/pdf/Apple_Environmental_Responsibility_Report_2017.pdf")
        
        // then lets create your document folder url
        let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // lets create your destination file url
        let destinationUrl = documentsDirectoryURL.appendingPathComponent("filename.pdf")
        
        // to check if it exists before downloading it
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            debugPrint("The file already exists at path")
            completion(true, destinationUrl)
            
            // if the file doesn't exist
        } else {
            
            // you can use NSURLSession.sharedSession to download the data asynchronously
            URLSession.shared.downloadTask(with: itemUrl!, completionHandler: { (location, response, error) -> Void in
                guard let tempLocation = location, error == nil else { return }
                do {
                    // after downloading your file you need to move it to your destination url
                    try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                    print("File moved to documents folder")
                    completion(true, destinationUrl)
                } catch let error as NSError {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
            }).resume()
        }
    }
    
}

//MARK:- QLPreviewController Datasource

extension ViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem as QLPreviewItem
    }
}














