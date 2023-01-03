//
//  VideoCell.swift
//  
//
//  Created by Jack Perry on 2/1/2023.
//

import NukeUI
import SwiftUI
import Shimmer

public struct VideoView: View {

    public enum Size {
        case collection, profile

        public var size: CGSize {
            .init(width: 200, height: 250)
        }

    }

    // MARK: - Properties

    public let size: Size
    @Environment(\.redactionReasons) private var reasons

    // MARK: - Init

    public init(size: Size = .collection) {
        self.size = size
    }

    // MARK: - View

    public var body: some View {
        let imageUrl = URL(string: "https://pbs.floatplane.com/blogPost_thumbnails/K4AQLAGCbi/344537798849979_1672451738362_400x225.jpeg")!
        VStack {
            VideoPreview(imageUrl: imageUrl, duration: .seconds(1005))
            HStack {
                Text("Brown Star for Effort – This AliExpress Gaming Laptop is HILARIOUS")
                    .font(.footnote)
                    .dynamicTypeSize(...DynamicTypeSize.accessibility1)
                Spacer()
            }
            Spacer()
            HStack {
                Text("LinusTechTips")
                Spacer()
                Text("14 Hours ago")
            }
                .font(.caption2)
                .dynamicTypeSize(...DynamicTypeSize.accessibility1)
        }
        .frame(width: 250, height: 210)
    }

    @ViewBuilder
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(.gray)
    }

}


#if DEBUG
struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
            .previewDisplayName("Default")
    }
}
#endif
