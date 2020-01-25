//
//  ViewController.swift
//  ML Core
//
//  Created by Muhammed Essa on 1/21/20.
//  Copyright © 2020 Muhammed Essa. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             imageView.image = userPickerImage
            guard let ciimage = CIImage(image: userPickerImage) else {
                fatalError("Failed to convert UI image to ciimage")
            }
             detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage){
      
        guard   let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
                fatalError("Core ML loading failed")
        }
         
        let request = VNCoreMLRequest(model: model ) {   (request, error ) in
       guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Core ML process failed")
             }
          //  print(results)
            if let fisrtresult = results.first {
                if fisrtresult.identifier.contains("desktop computer"){
                    self.showLabel.text = "desktop computer"
                }else{
                     self.showLabel.text = "Not computer"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
           do {
               try handler.perform([request])
           } catch {
               print("Failed to perform classification.\n\(error.localizedDescription)")
           }
        
        
    }
    
    @IBAction func cameraBTN(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    



}

