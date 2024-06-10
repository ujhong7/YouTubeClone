//
//  Channel.swift
//  YouTubeClone
//
//  Created by yujaehong on 5/16/24.
//

import UIKit

public struct Channel {
    var id: String
    var name: String
    var thumbnail: String
    
    init(id: String, name: String, thumbnail: String) {
        self.id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}

extension Channel {
    public static var mock: [Channel] {
        .init([.init(id: "UCUj6rrhMTR9pipbAWBAMvUQ",
                     name: "침착맨",
                     thumbnail: "https://yt3.ggpht.com/C7bTHnoo1S_MRbJXn4VwncNpB87C2aioJC_sKvgM-CGw_xgdxwiz0EFEqzj0SRVz6An2h81T4Q=s88-c-k-c0x00ffffff-no-rj"),
               .init(id: "UCdUcjkyZtf-1WJyPPiETF1g",
                     name: "ITSub잇섭",
                     thumbnail: "https://yt3.ggpht.com/ytc/AIdro_kutxZhVtnH4nWcW7ebuDER5TfHwPZJaqGyBVGjVC52A0A=s88-c-k-c0x00ffffff-no-rj"),
               .init(id: "UCt15X5eHLwyP8PpNtQTkuDQ",
                     name: "Official dopa",
                     thumbnail: "https://yt3.ggpht.com/MzQiCtGknvdDlOqokMKtjuOcfiX_BN347AawsHOOsa9c6g9WJWNVlPTXdfn3R2jV9rW_mbCdrHQ=s88-c-k-c0x00ffffff-no-rj"),
               .init(id: "UClRNDVO8093rmRTtLe4GEPw",
                     name: "곽튜브",
                     thumbnail: "https://yt3.ggpht.com/FKSFztShFrbN0oshh4D5uxSWVLam_ByaV6W4TOnwIKyfJYXkNBDLGNXPBwa_HIfCl87G0hB9FQ=s88-c-k-c0x00ffffff-no-rj"),
               .init(id: "UCNhofiqfw5nl-NeDJkXtPvw",
                     name: "빠니보틀 Pani Bottle",
                     thumbnail: "https://yt3.ggpht.com/lh7GiITaDKNdh6hi2GasqJrfi6AqDaj0qqR1UvVWGZPjltJmYzuftmA65KDy_Tltu6S8k82WkQ=s88-c-k-c0x00ffffff-no-rj")])
    }
}

