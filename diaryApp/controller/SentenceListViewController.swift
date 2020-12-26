//
//  SentenceListViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/14.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import Hero
import RealmSwift
import GoogleMobileAds

class SentenceListViewController: UIViewController {

    @IBOutlet weak var sentenceListTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var selectButtonItem: UISegmentedControl!
    @IBOutlet weak var checkMarkButton: UIButton!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var sentenceList:[[Any]] = []
    var language:String = "日本語"
    var checkedList:[Any] = []
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationvarの設定
        self.navigationBar.barTintColor = UIColor(named: K.color.mainBlue)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        selectButtonItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.white], for: .normal)
        
        sentenceListTableView.delegate = self
        sentenceListTableView.dataSource = self
        sentenceListTableView.backgroundColor = UIColor(named: K.color.mainBlue)
        sentenceListTableView.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        
        let diaryData = realm.objects(DiaryModel.self)
        for data in diaryData {
            var sentences:[Any] = []
            sentences.append(data.checkedJapanese)
            sentences.append(data.checkedEnglish)
            sentences.append(data.createdAt)
            sentences.append(false)
            sentenceList.append(sentences)
        }
     
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/5291989047"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    

    @IBAction func backBarButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkMarkButtonPressed(_ sender: UIButton) {
        sentenceList.removeAll()
        if checkMarkButton.imageView?.image == UIImage(named: K.image.check){
            let diaryData = realm.objects(DiaryModel.self)
            for data in diaryData {
                var sentences:[Any] = []
                sentences.append(data.checkedJapanese)
                sentences.append(data.checkedEnglish)
                sentences.append(data.createdAt)
                sentences.append(false)
                sentenceList.append(sentences)
            }
        }
        
        checkMarkButton.imageView?.image == UIImage(named: K.image.check) ? checkMarkButton.setImage(UIImage(named: K.image.uncheck), for: .normal) : checkMarkButton.setImage(UIImage(named: K.image.check), for: .normal)
        for i in checkedList{
            sentenceList.append(i as! [Any])
        }
        checkedList.removeAll()
        sentenceListTableView.reloadData()
    }
    
    @IBAction func selectButtonPressed(_ sender: UISegmentedControl) {
        
        language = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        sentenceListTableView.reloadData()
    }
    
    @objc func sentenceCheckButtonPressed(_ sender:UIButton) {
        
        checkedList.removeAll()
        //画像変更
        sender.imageView?.image == UIImage(named: K.image.check) ? sender.setImage(UIImage(named: K.image.uncheck), for: .normal) : sender.setImage(UIImage(named: K.image.check), for: .normal)
        
        //Bool値変更
        if sentenceList[sender.tag][3] as? Bool == true {
            sentenceList[sender.tag][3] = false
        }else{
            sentenceList[sender.tag][3] = true
        }
       
        for i in sentenceList{
            if i[3] as? Bool == true{
                checkedList.append(i)
            }
        }
 
    }
    
}


//MARK:- TableViewdelegate & TableviewDatasource
extension SentenceListViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentenceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
 
        let cell = sentenceListTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCellTableViewCell
        cell.checkButton.addTarget(self, action: #selector(sentenceCheckButtonPressed(_:)), for: .touchUpInside)
        cell.checkButton.tag = indexPath.row
        cell.backgroundColor = UIColor(named: K.color.mainBlue)
        if language == "日本語" {
            cell.sentenceLabel.text = sentenceList[indexPath.row][0] as? String
        }else{
            cell.sentenceLabel.text = sentenceList[indexPath.row][1] as? String
        }
        cell.dateLabel.text = sentenceList[indexPath.row][2] as? String
        
        //チェックボタン画像決める
        if sentenceList[indexPath.row][3] as? Bool == true {
            cell.checkButton.setImage(UIImage(named: K.image.check), for: .normal)
        }else{
            cell.checkButton.setImage(UIImage(named: K.image.uncheck), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let SB = UIStoryboard(name: K.storyBoardName.Translate, bundle: nil)
        let VC = SB.instantiateViewController(withIdentifier: K.storyBoardID.Translate) as! TranslateViewController
        VC.modalPresentationStyle = .fullScreen
        VC.ja = sentenceList[indexPath.row][0] as! String
        VC.en = sentenceList[indexPath.row][1] as! String
        VC.language = language
        self.present(VC, animated: true, completion: nil)
      
    }
}
