//
//  Diary.swift
//  1891143-finalProject
//
//  Created by 김민경 on 2021/05/30.
//

import Foundation

class DiaryGroup: NSObject {
    
    var diaries = [Diary]()
    
    override init(){
        super.init()
    }
    
    func testData(){
        for _ in 0...1{
            diaries.append(Diary(title: "test", date: "2021-05-20", content: "내용입니다.", image: nil))
        }
        diaries.append(Diary(title: "test", date: "2021-06-01", content: "내용입니다.", image: nil))
    }
    
    func count() -> Int{
        return diaries.count
    }
    
    func addDiary(diary:Diary){
        diaries.append(diary)
    }
    
    func modifyDiary(diary:Diary, index:Int){
       diaries[index] = diary
        
    }
    
    func removeDiary(index: Int){
        diaries.remove(at: index)
    }
    
    func findByDate(date: String) -> [Diary] {
        var selectediary = [Diary]()

        for d in diaries{
            if d.date == date {
                selectediary.append(d)
            }
        }
        return selectediary
    }
}
