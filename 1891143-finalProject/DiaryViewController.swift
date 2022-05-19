//
//  DiaryViewController.swift
//  1891143-finalProject
//
//  Created by 김민경 on 2021/05/26.
//

import UIKit
import FSCalendar

class DiaryViewController: UIViewController {
    
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var diaryTableView: UITableView!
    
    let dateFormatter = DateFormatter()
    var diaryGroup: DiaryGroup!
    var selectedDiaries: [Diary]!
    var selectedDate: String!
    var selectedDateDiaryCount: Int!
    var cloneDiary: Diary!
    var dates: [Date]!
}

extension DiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        diaryGroup = DiaryGroup()
        
        dates = []
        for diary in diaryGroup.diaries {
            let addDate = dateFormatter.date(from: diary.date)!
            dates.append(addDate)
            print(diary.date)
        }
        
        diaryGroup.testData()
        // Do any additional setup after loading the view.
        // 달력의 년월 글자 바꾸기
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        // 달력의 요일 글자 바꾸는 방법
        calendarView.locale = Locale(identifier: "ko_KR")
        
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.backgroundColor = #colorLiteral(red: 0.7267724872, green: 0.8620788455, blue: 1, alpha: 0.23)
        calendarView.appearance.selectionColor = #colorLiteral(red: 0.2926062942, green: 0.4751771688, blue: 1, alpha: 0.56)
        calendarView.appearance.todayColor = #colorLiteral(red: 0.2499872148, green: 0.5111043453, blue: 0.7963648438, alpha: 0.2889218493)
        
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        
        selectedDate = dateFormatter.string(from: Date.init())
        print("selectedDate is")
        print(selectedDate as Any)
        
        self.navigationItem.title = "Calendar"
        
    }
}

extension DiaryViewController {
    override func viewWillAppear(_ animated: Bool) {
        print("call viewWillAppear in Diary View Controller")
        //        if let indexPath = diaryTableView.indexPathForSelectedRow{
        //            diaryTableView.reloadRows(at: [indexPath], with: .automatic)
        //        }
        
        dates = []
        for diary in diaryGroup.diaries {
            let addDate = dateFormatter.date(from: diary.date)!
            dates.append(addDate)
            print(diary.date)
        }
        
        diaryTableView.reloadData()
        calendarView.reloadData()
    }
}

extension DiaryViewController {
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = diaryTableView.indexPathForSelectedRow{
            guard let clonee = cloneDiary  else{ return }
            if clonee.isEqual(selectedDiaries[indexPath.row]) == false{
                diaryGroup.modifyDiary(diary: clonee, index: indexPath.row)
                diaryTableView.reloadData()
                calendarView.reloadData()
            }

        }else if let clonee = cloneDiary {
            if clonee.title == "" { return }
            diaryGroup.addDiary(diary: clonee)
            
            dates = []
            for diary in diaryGroup.diaries {
                let addDate = dateFormatter.date(from: diary.date)!
                dates.append(addDate)
                print(diary.date)
            }
            
            diaryTableView.reloadData()
            calendarView.reloadData()
        }
    }
    
}

extension DiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedDate == nil {
            selectedDiaries = diaryGroup.findByDate(date: dateFormatter.string(from: Date.init()))
        } else {
            selectedDiaries = diaryGroup.findByDate(date: selectedDate)
        }
        return selectedDiaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableCell")!
        
        let diary = selectedDiaries[indexPath.row]
        cell.textLabel!.text = diary.date
        cell.detailTextLabel!.text = diary.title
        cell.backgroundColor = .white
        
        return cell
    }
}

extension DiaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = #colorLiteral(red: 0.2499872148, green: 0.5111043453, blue: 0.7963648438, alpha: 0.2889218493)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)!.backgroundColor = .white
    }
}


extension DiaryViewController : FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(dateFormatter.string(from: date) + " 선택됨")
        selectedDate = dateFormatter.string(from: date)
        print(selectedDate as Any)
        diaryTableView.reloadData()
    }
    // 날짜 선택 해제 시 콜백 메소드
    public func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print(dateFormatter.string(from: date) + " 해제됨")
        selectedDate = nil
        //print(selectedDate as Any)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if self.dates.contains(date){
            return 1
        }
        return 0
    }
}


extension DiaryViewController {
    
    @IBAction func editingTable(_ sender: UIBarButtonItem) {
        if diaryTableView.isEditing == true{
            diaryTableView.isEditing = false
            sender.title = "Edit"
        }else{
            diaryTableView.isEditing = true
            sender.title = "Done"
        }
    }
}

extension DiaryViewController{
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let diary = diaryGroup.diaries[indexPath.row]
            let title = "Delete \(diary.title)"
            let message = "정말 지우시겠습니까?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            //.alert
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Sure", style: .destructive){
                (action) in
                self.diaryGroup.removeDiary(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                self.dates = []
                for diary in self.diaryGroup.diaries {
                    let addDate = self.dateFormatter.date(from: diary.date)!
                    self.dates.append(addDate)
                    print(diary.date)
                }
                self.calendarView.reloadData()
                
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true)
            
        }
    }
}

extension DiaryViewController {
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let diaryDetailViewController = segue.destination as! DiaryDetailViewController
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        if ((sender as? UITableViewCell) != nil) {
            if let row = diaryTableView.indexPathForSelectedRow?.row{
                //diaryDetailViewController.diary = diaryGroup.diaries[row]
                diaryDetailViewController.diary = selectedDiaries[row]
            }
        }
        else {
            //diaryDetailViewController.diary = Diary.init(title: "", date: dateFormatter.string(from: Date.init()), content: nil, image: nil)
            cloneDiary = Diary.init(date: dateFormatter.string(from: Date.init()))
            diaryDetailViewController.diary = cloneDiary
            if selectedDate != nil {
                diaryDetailViewController.selDate = selectedDate
                //print(selectedDate + "네비")
                //print(dateFormatter.string(from: diaryDetailViewController.selDate))
            }
            if let indexPath = diaryTableView.indexPathForSelectedRow{
                diaryTableView.deselectRow(at: indexPath, animated: true)
                diaryTableView.cellForRow(at: indexPath)?.backgroundColor = .white
            }
        }
    }
}
