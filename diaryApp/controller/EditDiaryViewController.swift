//
//  EditDiaryViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/14.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMobileAds

class EditDiaryViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var jaTextField1: UITextField!
    @IBOutlet weak var jaTextField2: UITextField!
    @IBOutlet weak var jaTextField3: UITextField!
    @IBOutlet weak var jaTextField4: UITextField!
    @IBOutlet weak var jaTextField5: UITextField!
    @IBOutlet weak var enTextField1: UITextField!
    @IBOutlet weak var enTextField2: UITextField!
    @IBOutlet weak var enTextField3: UITextField!
    @IBOutlet weak var enTextField4: UITextField!
    @IBOutlet weak var enTextField5: UITextField!
    @IBOutlet var jaTextFields: [UITextField]!
    @IBOutlet var enTextFields: [UITextField]!
    @IBOutlet var check1: [UIButton]!
    @IBOutlet var check2: [UIButton]!
    @IBOutlet var check3: [UIButton]!
    @IBOutlet var check4: [UIButton]!
    @IBOutlet var check5: [UIButton]!
    @IBOutlet var checkButtons: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    var dateString:String = ""
    var ja1:String = ""
    var ja2:String = ""
    var ja3:String = ""
    var ja4:String = ""
    var ja5:String = ""
    var en1:String = ""
    var en2:String = ""
    var en3:String = ""
    var en4:String = ""
    var en5:String = ""
    var checkedLineNumber:Int = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationvarの設定
        self.navigationBar.barTintColor = UIColor(named: K.color.mainBlue)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        //UI設定
        dateLabel.text = dateString
        recordButton.layer.cornerRadius = 10
        recordButton.layer.shadowColor = UIColor.black.cgColor
        recordButton.layer.shadowOpacity = 0.4
        recordButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.shadowColor = UIColor.black.cgColor
        deleteButton.layer.shadowOpacity = 0.4
        deleteButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        //受け渡された値の反映
        jaTextField1.text = ja1
        jaTextField2.text = ja2
        jaTextField3.text = ja3
        jaTextField4.text = ja4
        jaTextField5.text = ja5
        enTextField1.text = en1
        enTextField2.text = en2
        enTextField3.text = en3
        enTextField4.text = en4
        enTextField5.text = en5
        
        for i in checkButtons {
            
            if i.tag == checkedLineNumber {
                i.setImage(UIImage(named: K.image.check), for: .normal)
            }
        }
        
           
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/8782503880"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "この日記を削除しますか？", message: nil, preferredStyle: .alert)
        let actin1 = UIAlertAction(title: "いいえ", style: .default, handler: nil)
        let actin2 = UIAlertAction(title: "削除", style: .default) { (UIAlertAction) in
            
            let today = self.realm.objects(DiaryModel.self).filter("createdAt == '\(self.dateLabel.text!)'")
            
            try! self.realm.write {
                self.realm.delete(today)
            }
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(actin1)
        alert.addAction(actin2)
        present(alert, animated: true, completion: nil
        )
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        
        var flag = 0
        for button in checkButtons {
            if button.imageView?.image == UIImage(named: K.image.check) {
                flag = flag + 1
            }
        }
        if flag == 0 {
            makesingleAlert(mainTitle: "リストに保存したい文を１ペアチェックしてください", selection: "OK")
        }else if flag == 2 {
            let alert = UIAlertController(title: "日記の内容を変更します", message: nil, preferredStyle: .alert)
            let actin1 = UIAlertAction(title: "いいえ", style: .default, handler: nil)
            let actin2 = UIAlertAction(title: "はい", style: .default) { (UIAlertAction) in
                
                let diary = DiaryModel()
                var checkFlag = 0
                diary.japanese1 = self.jaTextField1.text!
                diary.japanese2 = self.jaTextField2.text!
                diary.japanese3 = self.jaTextField3.text!
                diary.japanese4 = self.jaTextField4.text!
                diary.japanese5 = self.jaTextField5.text!
                diary.english1 = self.enTextField1.text!
                diary.english2 = self.enTextField2.text!
                diary.english3 = self.enTextField3.text!
                diary.english4 = self.enTextField4.text!
                diary.english5 = self.enTextField5.text!
                for i in self.checkButtons {
                    if i.imageView?.image == UIImage(named: K.image.check){
                        diary.checkedLineNumber = i.tag
                        checkFlag = i.tag - 1
                    }
                }
                diary.checkedJapanese = self.jaTextFields[checkFlag].text!
                diary.checkedEnglish = self.enTextFields[checkFlag].text!
                diary.createdAt = self.dateLabel.text!
                diary.createdAt = self.dateLabel.text!
                let today = self.realm.objects(DiaryModel.self).filter("createdAt == '\(self.dateLabel.text!)'")
                try! self.realm.write {
                    self.realm.delete(today)
                    self.realm.add(diary)
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
    
    @IBAction func checkButtonPressed(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            for i in check1{
                buttonImageChange(i, sender.tag)
            }
        case 2:
            for i in check2{
                buttonImageChange(i, sender.tag)
            }
        case 3:
            for i in check3{
                buttonImageChange(i, sender.tag)
            }
        case 4:
            for i in check4{
                buttonImageChange(i, sender.tag)
            }
        case 5:
            for i in check5{
                buttonImageChange(i, sender.tag)
            }
        default:
            return
        }
    }
    
    func buttonImageChange(_ i:UIButton, _ t:Int) {
        
        if jaTextFields[t-1].text! != "" && enTextFields[t-1].text! != "" {
            i.imageView?.image == UIImage(named: K.image.check) ? i.setImage(UIImage(named: K.image.uncheck), for: .normal): i.setImage(UIImage(named: K.image.check), for: .normal)
        }
    }
    
    
}
