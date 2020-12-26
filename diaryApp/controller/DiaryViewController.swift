//
//  DiaryViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/12.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class DiaryViewController: UIViewController {
    
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var checkButton1: [UIButton]!
    @IBOutlet var checkButton2: [UIButton]!
    @IBOutlet var checkButton3: [UIButton]!
    @IBOutlet var checkButton4: [UIButton]!
    @IBOutlet var checkButton5: [UIButton]!
    @IBOutlet var chackButtons: [UIButton]!
    @IBOutlet var jaTextLabel: [UITextField]!
    @IBOutlet var enTextLabel: [UITextField]!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationvarの設定
        self.navigationBar.barTintColor = UIColor(named: K.color.mainBlue)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        //yyyy/mm/ddでの年月日表示
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
        dateLabel.text = formatter.string(from: Date())
        
        //各パーツの設定
        recordButton.layer.cornerRadius = 15.0
        recordButton.layer.shadowColor = UIColor.black.cgColor
        recordButton.layer.shadowOpacity = 0.4
        recordButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        jaTextLabel[0].becomeFirstResponder()
        
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/9805949121"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    

    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "投稿せずに戻りますか？", message: nil, preferredStyle: .alert)
        let actin1 = UIAlertAction(title: "戻らない", style: .default, handler: nil)
        let actin2 = UIAlertAction(title: "戻る", style: .default) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actin1)
        alert.addAction(actin2)
        present(alert, animated: true, completion: nil
        )
        
    }
    
    
    @IBAction func checkButtonPressed1(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            for i in checkButton1{
                buttonImageChange(i, sender.tag)
            }
        case 2:
            for i in checkButton2{
                buttonImageChange(i, sender.tag)
            }
        case 3:
            for i in checkButton3{
               buttonImageChange(i, sender.tag)
            }
        case 4:
            for i in checkButton4{
               buttonImageChange(i, sender.tag)
            }
        case 5:
            for i in checkButton5{
               buttonImageChange(i, sender.tag)
            }
        default:
            return
        }
    }
    
    func buttonImageChange(_ i:UIButton, _ t:Int) {
  
       
        if jaTextLabel[t-1].text! != "" && enTextLabel[t-1].text! != "" {
            i.imageView?.image == UIImage(named: K.image.check) ? i.setImage(UIImage(named: K.image.uncheck), for: .normal): i.setImage(UIImage(named: K.image.check), for: .normal)
        }
        
    }
    
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        
        var flag = 0
        for button in chackButtons {
            if button.imageView?.image == UIImage(named: K.image.check) {
                flag = flag + 1
            }
        }
        if flag == 0 {
            makesingleAlert(mainTitle: "リストに保存したい文を１ペアチェックしてください", selection: "OK")
        }else if flag == 2 {
            let alert = UIAlertController(title: "今日の日記を投稿しますか？", message: nil, preferredStyle: .alert)
            let actin1 = UIAlertAction(title: "いいえ", style: .default, handler: nil)
            let actin2 = UIAlertAction(title: "はい", style: .default) { (UIAlertAction) in
                
                let diary = DiaryModel()
                var checkFlag = 0
                diary.japanese1 = self.jaTextLabel[0].text!
                diary.japanese2 = self.jaTextLabel[1].text!
                diary.japanese3 = self.jaTextLabel[2].text!
                diary.japanese4 = self.jaTextLabel[3].text!
                diary.japanese5 = self.jaTextLabel[4].text!
                diary.english1 = self.enTextLabel[0].text!
                diary.english2 = self.enTextLabel[1].text!
                diary.english3 = self.enTextLabel[2].text!
                diary.english4 = self.enTextLabel[3].text!
                diary.english5 = self.enTextLabel[4].text!
                
                //チェックボタンが押されている
                for i in self.chackButtons {
                    if i.imageView?.image == UIImage(named: K.image.check){
                        diary.checkedLineNumber = i.tag
                        checkFlag = i.tag - 1
                    }
                }
                diary.checkedJapanese = self.jaTextLabel[checkFlag].text!
                diary.checkedEnglish = self.enTextLabel[checkFlag].text!
                diary.createdAt = self.dateLabel.text!
                let realm = try! Realm()
                try! realm.write {
                  realm.add(diary)
                }
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actin1)
            alert.addAction(actin2)
            present(alert, animated: true, completion: nil)
        }else if flag >= 3 {
            makesingleAlert(mainTitle: "文は１ペアだけチェックしてください", selection: "OK")
        }
        
    }
    
    
    func makesingleAlert(mainTitle:String, selection:String) {
        let alert = UIAlertController(title: mainTitle, message: nil, preferredStyle: .alert)
        let actin1 = UIAlertAction(title: selection, style: .default, handler: nil)
        alert.addAction(actin1)
        present(alert, animated: true, completion: nil
        )
    }
    
}
