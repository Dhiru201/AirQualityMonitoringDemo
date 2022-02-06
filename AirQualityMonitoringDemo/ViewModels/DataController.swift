//
//  DataController.swift
//  AirQualityMonitoringDemo
//
//  Created by Dhirendra Verma on 05/02/22.
//


import Foundation
import Starscream

protocol DataControllerDelegate {
    func didReceive(response: Result<[DataResponse], Error>)
}

class DataController {
    
    var delegate: DataControllerDelegate?
    var socket: WebSocket? = {
        guard let url = URL(string: APIHelper.url) else {
            print("invalid URL- \(APIHelper.url)")
            return nil
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        var socket = WebSocket(request: request)
        return socket
    }()
    
    func subscribe() {
        self.socket?.delegate = self
        self.socket?.connect()
    }
    
    func unsubscribe() {
        self.socket?.disconnect()
    }
    
    // disconnect and remove socket
    deinit {
        self.socket?.disconnect()
        self.socket = nil
    }
    
}

extension DataController: WebSocketDelegate {
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                debugPrint("connected: \(headers)")
            case .disconnected(let reason, let code):
                debugPrint("disconnected: \(reason) with code: \(code)")
            case .text(let string):
                handleText(text: string)
            case .binary(let data):
                debugPrint("data: \(data.count)")
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                debugPrint(" cancelled")
            case .error(let error):
            debugPrint("error: \(String(describing: error?.localizedDescription))")
                handleError(error: error)
            }
    }
    
    private func handleText(text: String) {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do {
            let resArray = try decoder.decode([DataResponse].self, from: jsonData)
            self.delegate?.didReceive(response: .success(resArray))
            
        } catch {
            self.delegate?.didReceive(response: .failure(error))
            print(error.localizedDescription)
        }
    }
    
    private func handleError(error: Error?) {
        if let e = error {
            self.delegate?.didReceive(response: .failure(e))
        }
    }
}
