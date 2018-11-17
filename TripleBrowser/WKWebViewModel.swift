//
//  WKWebViewModel.swift
//  TripleBrowser
//
//  Created by Masakaz Ozaki on 2018/11/17.
//  Copyright © 2018 Masakaz Ozaki. All rights reserved.
//

import Foundation

class WKWebViewModel {
    
    
    func urlEncording(str: String) -> String {
        let characterSetTobeAllowed = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        if let encodedURLString = str.addingPercentEncoding(withAllowedCharacters: characterSetTobeAllowed) {
            return encodedURLString
        }
        return str
    }
    
    func checkSearchText(searchText: String) -> URL {
        let url: URL!
        
        if searchText.hasPrefix("http") {
            url = URL(string: searchText)
        } else if searchText.hasPrefix("www") {
            url = URL(string: "https://" + searchText)
        } else  if searchText.hasSuffix("com") {
            url = URL(string: searchText)
        } else  if searchText.hasSuffix("jp") {
            url = URL(string: searchText)
        } else {
            let urlPercent: String = "https://www.google.co.jp/search?q=" + urlEncording(str: searchText)
            url = URL(string: urlPercent)
        }
        return url
    }
    
}
