//
//  Channel.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/16/24.
//

import UIKit

struct Channel {
    var imageName: String
    var name: String
    
    func makeIamge() -> UIImage? {
        return UIImage(named: imageName)
    }
}

class ChannelData {
    var list: [Channel]
    
    init() {
        self.list = [
            Channel(imageName: "CI1", name: "CI1"),
            Channel(imageName: "CI2", name: "CI2"),
            Channel(imageName: "CI3", name: "CI3"),
            Channel(imageName: "CI4", name: "CI4"),
            Channel(imageName: "CI5", name: "CI5"),
            Channel(imageName: "CI6", name: "CI6"),
            Channel(imageName: "CI7", name: "CI7"),
            Channel(imageName: "CI4", name: "CI8"),
            Channel(imageName: "CI5", name: "CI9"),
            Channel(imageName: "CI6", name: "CI10"),
        ]
    }
}
