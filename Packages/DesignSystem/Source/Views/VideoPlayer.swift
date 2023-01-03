//
//  VideoPlayer.swift
//  
//
//  Created by Jack Perry on 3/1/2023.
//

import AVKit
import SwiftUI

public struct VideoPlayer: View {

    @State private var player: AVPlayer
    @State private var isPlaying: Bool = false

    // MARK: - Init

    init(url: URL) {
        self.player = AVPlayer(url: url)
    }

    // MARK: - View

    public var body: some View {
        VStack {
            AVKit.VideoPlayer(player: player)
                .frame(width: 320, height: 180, alignment: .center)

            Button {
                isPlaying ? player.pause() : player.play()
                isPlaying.toggle()
                player.seek(to: .zero)
            } label: {
                Image(systemName: isPlaying ? "stop" : "play")
                    .padding()
            }
        }
    }

}

#if DEBUG
struct VideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://bit.ly/swswift")!

        VideoPlayer(url: url)
            .previewDisplayName("Default")
    }
}
#endif

