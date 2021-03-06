//
//  Forum.swift
//  Ruisi
//
//  Created by yang on 2017/4/17.
//  Copyright © 2017年 yang. All rights reserved.
//

public class Forum: Codable {
    var name: String
    var fid: Int
    var login: Bool
    var new: Int? //今日帖子数目
    
    
    init(fid: Int, name: String, login: Bool) {
        self.name = name
        self.fid = fid
        self.login = login
    }
}

public class Forums: Codable {

    var gid: Int
    var name: String
    var login: Bool
    var canPost: Bool
    var forums: [Forum]?

    init(gid: Int, name: String, login: Bool, canPost: Bool) {
        self.gid = gid
        self.name = name
        self.login = login
        self.canPost = canPost
    }

    func getSize() -> Int {
        if forums == nil {
            return 0
        } else {
            return forums!.count
        }
    }

    func setForums(forums: [Forum]) {
        self.forums = forums
    }
    
    func findForum(fid: Int) -> Forum? {
        for i in forums ?? [] {
            if i.fid == fid {
                return i
            }
        }
        
        return nil
    }
}
