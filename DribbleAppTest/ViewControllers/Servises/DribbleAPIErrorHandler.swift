import Foundation

enum DribbleAPIErrorHandler {
    
    static func handleDribbleError(error: Error) {
        print(error.localizedDescription)
    }
}
