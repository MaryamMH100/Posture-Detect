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
            // قم بتحميل النموذج من ملف .mlmodel
            let postureModel = try PostureDetectModel1(configuration: MLModelConfiguration()).model
            model = try VNCoreMLModel(for: postureModel)
        } catch {
            print("Failed to load model: \(error)")
        }
    }
    
    // دالة للكشف عن الوضعية من صورة معينة
    func detectPosture(from image: CIImage, completion: @escaping (String?, Float) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { // تشغيل في خيط خلفي
            print("Detecting posture from image...")
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

            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request]) // لم يعد على الخيط الرئيسي
            } catch {
                print("Failed to perform classification: \(error)")
                DispatchQueue.main.async {
                    completion(nil, 0.0)
                }
            }
        }
    }

}
