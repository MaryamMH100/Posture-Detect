//
//  PostureDetector.swift
//  PostureDetect
//
//  Created by Maryam on 07/03/2025.
//

import CoreML
import Vision
import CoreImage

class PostureDetector {
    private var model: VNCoreMLModel?

    init() {
        do {
            let postureModel = try PostureDetectModel1(configuration: MLModelConfiguration()).model
            model = try VNCoreMLModel(for: postureModel)
        } catch {
            print("Failed to load model: \(error)")
        }
    }

    func detectPosture(from image: CIImage, completion: @escaping (String?, Float) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { // Run on background thread
            guard let model = self.model else {
                DispatchQueue.main.async {
                    completion(nil, 0.0)
                }
                return
            }

            let request = VNCoreMLRequest(model: model) { request, error in
                if let error = error {
                    print("Error during classification: \(error)")
                    DispatchQueue.main.async {
                        completion(nil, 0.0)
                    }
                    return
                }

                if let results = request.results as? [VNClassificationObservation], let firstResult = results.first {
                    print("Posture detected: \(firstResult.identifier) with confidence: \(firstResult.confidence)")
                    DispatchQueue.main.async {
                        completion(firstResult.identifier, firstResult.confidence)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, 0.0)
                    }
                }
            }

            let handler = VNImageRequestHandler(ciImage: image, options: [:])

            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform classification: \(error)")
                DispatchQueue.main.async {
                    completion(nil, 0.0)
                }
            }
        }
    }
}
