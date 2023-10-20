//
//  Trim.swift
//  ToDoList_MVP_FireBase
//
//  Created by EMILY on 20/10/2023.
//

import Foundation

// 문자열 앞뒤 공백 삭제 메소드 정의
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
