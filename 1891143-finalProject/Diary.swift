//
//  Content.swift
//  1891143-finalProject
//
//  Created by 김민경 on 2021/05/30.
//

import UIKit
import Foundation

class Diary: NSObject{
    
    var title: String
    var date: String
    var content: String?
    var image: UIImage?
    init(title: String, date: String, content: String?, image: UIImage?){
        self.title = title
        self.date = date
        self.content = content
        self.image = image
        
        super.init()
    }
    convenience init(date: String){
        self.init(title: "", date: date, content: "", image: nil)
        return
    }
}

extension Diary {
    func clone() -> Diary {
        let diary = Diary.init(date: date)
        diary.title = title
        diary.date = date
        diary.content = content
        diary.image = image
        
        return diary
    }
}

extension Diary {
    func isEqual(diary: Diary) -> Bool{
        if diary.title != title { return false }
        else if diary.date != date { return false }
        else if diary.content != content { return false }
        else if diary.image != image { return false }
        
        return true
    }
}

