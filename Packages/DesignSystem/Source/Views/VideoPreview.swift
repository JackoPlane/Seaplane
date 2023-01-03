//
//  VideoPreview.swift
//  
//
//  Created by Jack Perry on 2/1/2023.
//

import NukeUI
import SwiftUI
import Shimmer

public struct VideoPreview: View {

    private let imageUrl: URL
    private let duration: Duration

    // MARK: - Init

    public init(imageUrl: URL, duration: Duration) {
        self.imageUrl = imageUrl
        self.duration = duration
    }

    // MARK: - View

    public var body: some View {
        LazyImage(url: imageUrl) { state in
            if let image = state.image {
                image
                    .resizingMode(.aspectFit)
            } else if state.isLoading {
                placeholderView
                    .shimmering()
            } else {
                placeholderView
            }
        }
        //.scaledToFit()
        .overlay {
            VideoDurationOverlay(duration: duration)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(DesignSystem.Constants.layoutPadding)
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(.gray)
    }

}

internal struct VideoDurationOverlay: View {

    private let duration: Duration
    private let durationString: String

    // MARK: - Init

    init(duration: Duration) {
        self.duration = duration

        if duration.components.seconds > 3600 {
            durationString = duration.formatted(.time(pattern: .hourMinuteSecond))
        } else {
            durationString = duration.formatted(.time(pattern: .minuteSecond))
        }
    }

    // MARK: - View

    public var body: some View {
        Text("\(Image(systemName: "clock"))  \(durationString)")
            .font(.caption2)
            .bold()
            .padding(DesignSystem.Constants.layoutPadding*0.6)
            .foregroundColor(.white)
            .background(Color.black)
            .opacity(0.7)
            .cornerRadius(DesignSystem.Constants.cornerRadius)
            .dynamicTypeSize(...DynamicTypeSize.accessibility1)
    }
}


#if DEBUG
struct VideoPreview_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://pbs.floatplane.com/blogPost_thumbnails/M3KlZ7FJL3/184472974451220_1671842704115_400x225.jpeg")!

        VideoPreview(imageUrl: url, duration: .seconds(783))
            .previewDisplayName("Default")
    }
}
#endif

