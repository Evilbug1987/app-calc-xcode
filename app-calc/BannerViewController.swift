//
//  BannerViewController.swift
//  app-calc
//
//  Created by DP on 2022/07/22.
//

import UIKit
import WebKit

class BannerViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    
    static var url: URL? = nil
    
    //alert 처리
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void){
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil) }

    //confirm 처리
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
        self.present(alertController, animated: true, completion: nil) }
    
    //MARK: 중복 리로드 방지
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lUrl = BannerViewController.url!
        
        if (lUrl.description.lowercased().range(of: "open.kakao.com/") != nil) {
            let kakaoTalkURL = lUrl
            
            //canOpenURL(_:) 메소드를 통해서 URL 체계를 처리하는 데 앱을 사용할 수 있는지 여부를 확인
            if (UIApplication.shared.canOpenURL(kakaoTalkURL as URL)) {
        
                //open(_:options:completionHandler:) 메소드를 호출해서 카카오톡 앱 열기
                UIApplication.shared.open(kakaoTalkURL as URL)
            }
            //사용 불가능한 URLScheme일 때(카카오톡이 설치되지 않았을 경우)
            else {
                print("No kakaotalk installed.")
            }
        }
        
        let request = URLRequest(url: lUrl)
        
        self.webView?.allowsBackForwardNavigationGestures = true
        webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.load(request)
    }
}
