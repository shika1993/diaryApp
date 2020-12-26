//
//  FirstViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/12.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class FirstViewController: UIViewController {

    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var numberOfDiaryLabel: UILabel!
    @IBOutlet weak var diaryButton: UIButton!
    @IBOutlet weak var diaryView: UIView!
    @IBOutlet weak var calenderButton: UIButton!
    @IBOutlet weak var calenderView: UIView!
    @IBOutlet weak var sentenceListButton: UIButton!
    @IBOutlet weak var sentenceListView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let realm = try! Realm()
    var numberOfContinue:Int = 0
    var days:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationvarの設定
        self.navigationController?.navigationBar.barTintColor = UIColor(named: K.color.mainBlue)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //yyyy/mm/ddでの年月日表示
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        
        //各パーツの設定
        dateLabel.text = formatter.string(from: Date())
        diaryView.layer.cornerRadius = 30.0
        calenderView.layer.cornerRadius = 30.0
        sentenceListView.layer.cornerRadius = 30.0
        diaryView.layer.shadowColor = UIColor.black.cgColor
        diaryView.layer.shadowOpacity = 0.4
        diaryView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        calenderView.layer.shadowColor = UIColor.black.cgColor
        calenderView.layer.shadowOpacity = 0.4
        calenderView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        sentenceListView.layer.shadowColor = UIColor.black.cgColor
        sentenceListView.layer.shadowOpacity = 0.4
        sentenceListView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/6532918527"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let diary = realm.objects(DiaryModel.self)
        numberOfDiaryLabel.text = String(diary.count)
    }

    
    @IBAction func diaryButtonPressed(_ sender: UIButton) {
        
        let today = realm.objects(DiaryModel.self).filter("createdAt == '\(dateLabel.text!)'")
        if today.count != 0 {
            makesingleAlert(mainTitle: "今日の日記は投稿済みです", selection: "OK")
        }else{
            let SB = UIStoryboard(name: K.storyBoardName.diary, bundle: nil)
            let VC = SB.instantiateViewController(withIdentifier: K.storyBoardID.diary) as! DiaryViewController
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func calenderButtonPressed(_ sender: UIButton) {
        
        let SB = UIStoryboard(name: K.storyBoardName.calender, bundle: nil)
        let VC = SB.instantiateViewController(withIdentifier: K.storyBoardID.calender) as! CalenderViewController
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    
    @IBAction func sentenceListButtonPressed(_ sender: UIButton) {
        
        let SB = UIStoryboard(name: K.storyBoardName.sentencelist, bundle: nil)
        let VC = SB.instantiateViewController(withIdentifier: K.storyBoardID.sentencelist) as! SentenceListViewController
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
    }
    
    func makesingleAlert(mainTitle:String, selection:String) {
        let alert = UIAlertController(title: mainTitle, message: nil, preferredStyle: .alert)
        let actin1 = UIAlertAction(title: selection, style: .default, handler: nil)
        alert.addAction(actin1)
        present(alert, animated: true, completion: nil
        )
    }
}

