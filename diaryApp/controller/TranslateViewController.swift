//
//  TranslateViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/16.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import Hero
import GoogleMobileAds

class TranslateViewController: UIViewController {

    
    @IBOutlet weak var sentenceLabel: UILabel!
    @IBOutlet weak var buckButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    var ja:String = ""
    var en:String = ""
    var language:String = "日本語"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //画面遷移アニメーション
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .cover(direction: .left), dismissing: .cover(direction: .right))
        
        //戻るボタンの見た目
        buckButton.layer.cornerRadius = 15.0
        buckButton.layer.shadowColor = UIColor.black.cgColor
        buckButton.layer.shadowOpacity = 0.1
        buckButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        if language == "日本語"{
            sentenceLabel.text = en
        }else{
            sentenceLabel.text = ja
        }
        
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/5983938397"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    @IBAction func buckButtonPressed(_ sender: UIButton) {
        hero.dismissViewController()
    }
    

}
