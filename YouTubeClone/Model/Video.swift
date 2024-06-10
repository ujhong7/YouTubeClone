//
//  Video.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/16/24.
//

import UIKit

struct Video {
    var thumbnailName: String
    var profileImageName: String
    var title: String
    var sub: String
    
    func makeImage() -> UIImage? {
        return UIImage(named: thumbnailName)
    }
    
    func makeprofileImage() -> UIImageView? {
        guard let image = UIImage(named: profileImageName) else { return nil }
        return UIImageView(image: image)
    }
}

class VideoData {
    var list: [Video]
    
    init() {
        self.list = [
            Video(thumbnailName: "TN1", profileImageName: "CI1", title: "우즈의 사랑노래", sub: "sehooninseoul ・조회수 17만회 ・ 3주 전  "),
            Video(thumbnailName: "TN2", profileImageName: "CI2", title: "태버(Tabber) - 007 & Chi-Ka (Feat.DEAN) | 딘, 태버 [DF LIVE]", sub: "dingo freestyle ・조회수 100만회 ・ 4주 전  "),
            Video(thumbnailName: "TN3", profileImageName: "CI3", title: "새벽이 되면 생각나는 목소리, 딘 💘 유희열의 스케치북 무대 모음 💙", sub: "KBS부산 ・조회수 96만회 ・ 1년 전  "),
            Video(thumbnailName: "TN4", profileImageName: "CI4", title: "[1시간40분] 올타임 레전드, 크러쉬의 스케치북 무대 모음!", sub: "KBS부산 ・조회수 8.8만회 ・ 1년 전  "),
            Video(thumbnailName: "TN5", profileImageName: "CI5", title: "Playlist 우리가 사랑하는 웨이브투어스의 노래모음 wave to earth ⋆｡⋆˚⋆｡˚", sub: "때껄룩TAKE A LOOK ・조회수 100만회 ・ 3주 전  "),
            Video(thumbnailName: "TN6", profileImageName: "CI6", title: "Sugarcoat", sub: "sehooninseoul ・조회수 23만회 ・ 3주 전  "),
            Video(thumbnailName: "TN7", profileImageName: "CI7", title: "에스파(aespa) - Next Level 교차편집(stage mix)", sub: "SM Entertainment ・조회수 974만회 ・ 1일 전"),
            Video(thumbnailName: "TN8", profileImageName: "CI8", title: "극강의 E들 사이에서 살아남는 I (NextLevel, 오리날다, ASAP)", sub: "비디터 Viditor ・조회수 174만회 ・ 4주 전")
        ]
    }
}
