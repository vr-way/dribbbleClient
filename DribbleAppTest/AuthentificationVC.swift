import Foundation
import UIKit
import OAuthSwift

class AuthentificationNVC: UINavigationController {
    var onCloseButtonTap: (() -> Void)?
    fileprivate var authenticationVC: AuthentificationVC?
}

extension AuthentificationNVC: OAuthSwiftURLHandlerType {
    
    convenience init(title: String) {
        let vc = AuthentificationVC()
        vc.title = title
        self.init(rootViewController: vc)
        self.authenticationVC = vc
        vc.onCloseButtonTap = {[weak self] in
            self?.onCloseButtonTap?()
        }
    }
    
    func handle(_ url: Foundation.URL) {
        
        guard let authentificationVC = viewControllers.first as? AuthentificationVC else { return }
        guard let topController = UIApplication.topViewController else { return }
        
        DispatchQueue.main.async {
            topController.present(self, animated: true, completion: nil)
            authentificationVC.handle(url)
        }
    }
}

private class AuthentificationVC: UIViewController {
    
    fileprivate struct Const {
        
        static let cancelItemText = NSLocalizedString("Cancel", comment: "Cancel navigation bar item text")
        
        static let webViewFrame: CGRect = {
            let screenBounds = UIScreen.main.bounds
            let statusBarFrame = UIApplication.shared.statusBarFrame
            return CGRect(x: 0, y: statusBarFrame.height, width: screenBounds.width, height: screenBounds.height - statusBarFrame.height)
        }()
    }
    
    fileprivate(set) var targetURL: Foundation.URL?
    fileprivate lazy var webView: UIWebView? = {[weak self] in
        guard let `self` = self else { return nil }
        
        self.resetCookies()
        let wv = UIWebView()
        wv.frame = self.view.bounds
        wv.scalesPageToFit = true
        wv.delegate = self
        self.view.addSubview(wv)
        wv.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return wv
    }()
    
    fileprivate func resetCookies() {
        let storage: HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies ?? [] {
            storage.deleteCookie(cookie)
        }
        UserDefaults.standard.synchronize()
    }
    
    var onCloseButtonTap: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func handle(_ url: Foundation.URL) {
        loadAddressURL(url)
    }
    
    func loadAddressURL(_ url: Foundation.URL) {
        guard let webView = self.webView else {
            close()
            return
        }
        
        targetURL = url
        let req = URLRequest(url: url)
        webView.loadRequest(req)
    }
    
    func close() {
        super.dismiss(animated: true, completion: nil)
       
    }
}


//MARK: Web view delegate
extension AuthentificationVC: UIWebViewDelegate {
    
    @objc func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print ("AuthentificationVC load with request. URL: \(String(describing: request.url))")
        return true
    }
}


//MARK: Visibility customizations
extension AuthentificationVC {
    
    fileprivate func customizeNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Const.cancelItemText, style: UIBarButtonItemStyle.plain, target: self, action: #selector(AuthentificationVC.naigationBarCancelButtonHandler))
    }
    
    @objc fileprivate func naigationBarCancelButtonHandler() {
        self.dismiss(animated: true, completion: nil)
        onCloseButtonTap?()
    }
}
