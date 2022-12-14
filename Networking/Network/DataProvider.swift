//
//  DataProvider.swift
//  Networking
//
//  Created by Павел Афанасьев on 20.09.2022.
//

import UIKit

class DataProvider: NSObject {
    
    private var downloadTask: URLSessionDownloadTask!
    var fileLocation: ((URL) -> ())?
    var onProgress: ((Double) -> ())?
    
    // Настройка конфигурации сессии
    private lazy var bgSession: URLSession = {
        
        let config = URLSessionConfiguration.background(withIdentifier: "pavelAfanasiev.Networking") // bundle name
//        config.isDiscretionary = true // оптимизация загрузки операционной системой
        config.sessionSendsLaunchEvents = true // по завершению загрузки данных приложение запустится в фоновом режиме, для backgroud по умолчанию true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3) // загрузка через 3 секунды после запуска задачи
//            downloadTask.countOfBytesExpectedToSend = 512
//            downloadTask.countOfBytesExpectedToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvider: URLSessionDelegate {
    //метод будет вызываться после завершения всех фоновых задач с нашим индификатором приложения
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let complitionHandler = appDelegate.bgSessionComplitionHandler
            else { return }
            
            appDelegate.bgSessionComplitionHandler = nil
            complitionHandler()
        }
    }
}

extension DataProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("Did finish downloading: \(location.absoluteString)")
        
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        
        print("Download progress: \(progress)")
        
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
