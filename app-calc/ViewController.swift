//
//  ViewController.swift
//  app-calc
//
//  Created by DP on 2022/07/04.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var indicator : UIActivityIndicatorView!
    
    /*
    override func loadView() {
        super.loadView()

        webView = WKWebView(frame: self.view.frame)
        webView.uiDelegate = self
        webView.navigationDelegate = self

        self.view = self.webView
    }
     */
    
    /*
    //MARK: - href="_blank" 새 창 열기
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //navagationAction내에 새로 요청하는 webview에 대한 정보가 들어있다
        //아래와 같은 형식으로 request를 받아 새 웹뷰를 띄우거나 기존 웹뷰에 load해 줄 수 있다
        //if let url = navigationAction.request.url {...}
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
     */
    
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
    
    //MARK: - href="_blank" 새 창 열기
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        //navagationAction내에 새로 요청하는 webview에 대한 정보가 들어있다
        //아래와 같은 형식으로 request를 받아 새 웹뷰를 띄우거나 기존 웹뷰에 load해 줄 수 있다
        //if let url = navigationAction.request.url {...}
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    // spec URL handler
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        print("=================================")
        print("url address is : \(url!)" )

        if (url?.description.lowercased().range(of: "/gud154") != nil || url?.description.lowercased().range(of: "carmart25.com/pp") != nil || url?.description.lowercased().range(of: "open.kakao.com/") != nil) {
            BannerViewController.url = url
            print("yes there is footer link")
            decisionHandler(.cancel)
            
            self.performSegue(withIdentifier: "bannerSegue", sender: nil)
            return
        }else{
            print("no there is no url")
            decisionHandler(.allow)
            return
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("로드 시작")
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("로딩완료")
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "서버 오류", message: "서버접속에 문제가 있습니다. 관리자에게 문의 주세요.", preferredStyle: UIAlertController.Style.alert)
        
        let yesCertAction = UIAlertAction(title: "확인", style: .default) { (action) in
            // 앱 종료
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
            return
        }
        
        alert.addAction(yesCertAction)
        
        self.present(alert, animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 모달 뷰 관련 함수를 이곳에 작성
        webView.navigationDelegate = self
        
        if NetworkCheck.shared.isConnected {
            let url = URL(string: "http://221.143.40.24:58080/")
            //let url = URL(string: "https://www.naver.com")
            let request = URLRequest(url: url!)
            self.webView?.allowsBackForwardNavigationGestures = true
            webView.configuration.preferences.javaScriptEnabled = true  //자바스크립트 활성화
            webView.uiDelegate = self
            
            print("=================================")
            webView.load(request)
        }else{
            let alert = UIAlertController(title: "네트워크 오류", message: "네트워크 연결 상태를 확인해주세요", preferredStyle: UIAlertController.Style.alert)
            
            let yesCertAction = UIAlertAction(title: "확인", style: .default) { (action) in
                // 앱 종료
                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    exit(0)
                }
                return
            }
            
            alert.addAction(yesCertAction)
            
            self.present(alert, animated: false, completion: nil)
        }
    }
    
}

