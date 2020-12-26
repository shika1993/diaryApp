//
//  CalenderViewController.swift
//  diaryApp
//
//  Created by 鹿内翔平 on 2020/09/12.
//  Copyright © 2020 鹿内翔平. All rights reserved.
//

import UIKit
import FSCalendar
import RealmSwift
import GoogleMobileAds

class CalenderViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let realm = try! Realm()
    let dateformatter = DateFormatter()
    var dateArray:[Date] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //カレンダーの設定
        calendar.delegate = self
        calendar.dataSource = self
        calendar.appearance.selectionColor = .blue
        
        
        //navigationBarの設定
        self.navigationBar.barTintColor = UIColor(named: K.color.mainBlue)
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        //広告の設定
        bannerView.adUnitID = "ca-app-pub-8751799063020237/1046240824"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let diarys = realm.objects(DiaryModel.self)
        for i in diarys{
            let dateString = i.createdAt
            let formatter = DateFormatter()
            formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy/MM/dd", options: 0, locale: Locale(identifier: "ja_JP"))
            let date = formatter.date(from: dateString)
            dateArray.append(date!)
            
        }
    }
    


    @IBAction func buckButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let dateString = formatter.string(from: date)
        let SB = UIStoryboard(name: K.storyBoardName.editDiary, bundle: nil)
        let VC = SB.instantiateViewController(withIdentifier: K.storyBoardID.editDiary) as! EditDiaryViewController
        VC.modalPresentationStyle = .fullScreen
        VC.dateString = dateString
        let result = realm.objects(DiaryModel.self).filter("createdAt == '\(dateString)'")
        if result.count != 0 {
            VC.ja1 = result[0].japanese1
            VC.ja2 = result[0].japanese2
            VC.ja3 = result[0].japanese3
            VC.ja4 = result[0].japanese4
            VC.ja5 = result[0].japanese5
            VC.en1 = result[0].english1
            VC.en2 = result[0].english2
            VC.en3 = result[0].english3
            VC.en4 = result[0].english4
            VC.en5 = result[0].english5
            VC.checkedLineNumber = result[0].checkedLineNumber
            self.present(VC, animated: true, completion: nil)
        }else{
            makesingleAlert(mainTitle: "この日の日記はありません", selection: "OK")
        }

        
    }
    
    func makesingleAlert(mainTitle:String, selection:String) {
        let alert = UIAlertController(title: mainTitle, message: nil, preferredStyle: .alert)
        let actin1 = UIAlertAction(title: selection, style: .default, handler: nil)
        alert.addAction(actin1)
        present(alert, animated: true, completion: nil
        )
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print(date)
        if self.dateArray.contains(date) {
                 return 1
        }
        
        return 0
    }
    

    
}
