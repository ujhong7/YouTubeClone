////
////  ChannelViewModel.swift
////  YouTubeClone
////
////  Created by yujaehong on 7/3/24.
////
//
//import UIKit
//
//class ChannelViewModel {
//    
//    // MARK: - Properties
//    
//    private let channels: [Channel] = Channel.mock
//    
//    var selectedChannel: Channel?
//    
//    var onDataReceived: (([Item]) -> Void)?
//    
//    var numberOfChannels: Int {
//        return channels.count
//    }
//    
//    func channel(at indexPath: IndexPath) -> Channel {
//        return channels[indexPath.row]
//    }
//    
//    func selectChannel(at indexPath: IndexPath, completion: @escaping () -> Void) {
//        let channel = channels[indexPath.row]
//        selectedChannel = channel
//        fetchSubscribeVideoData(for: channel.id, completion: completion)
//    }
//    
//    func deselectChannel() {
//        selectedChannel = nil
//    }
//    
//    private func fetchSubscribeVideoData(for channelId: String, completion: @escaping () -> Void) {
//        APIManager.shared.requestSubscribeVideoData(channelId: channelId) { result in
//            switch result {
//            case .success(let data):
//                self.onDataReceived?(data)
//            case .failure(_):
//                print(#fileID, #function, #line, "🐧 결과값이 존재하지 않습니다.")
//            }
//            completion()
//        }
//    }
//
//}
