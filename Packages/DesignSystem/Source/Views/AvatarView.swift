//
//  AvatarView.swift
//  
//
//  Created by Jack Perry on 2/1/2023.
//

import NukeUI
import SwiftUI
import Shimmer

public struct AvatarView: View {

    public enum Size {
        case collection, profile, browse

        public var size: CGSize {
            switch self {
            case .collection:
                return .init(width: 80, height: 80)
            case .profile:
                return .init(width: 240, height: 240)
            case .browse:
                return .init(width: 180, height: 180)
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .browse:
                return DesignSystem.Constants.cornerRadius * 2
            default:
                return size.width / 2
            }
        }

    }

    // MARK: - Properties

    public let url: URL
    public let size: Size
    @Environment(\.redactionReasons) private var reasons

    // MARK: - Init

    public init(url: URL, size: Size = .collection) {
        self.url = url
        self.size = size
    }

    // MARK: - View

    public var body: some View {
        if reasons == .placeholder {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(.gray)
                .frame(maxWidth: size.size.width, maxHeight: size.size.height)
        } else {
            LazyImage(url: url) { state in
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
            .processors([.resize(size: size.size), .roundedCorners(radius: size.cornerRadius)])
            .frame(width: size.size.width, height: size.size.height)
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        if size == .collection {
            Circle()
                .fill(.gray)
                .frame(width: size.size.width, height: size.size.height)
        } else {
            RoundedRectangle(cornerRadius: size.cornerRadius)
                .fill(.gray)
                .frame(width: size.size.width, height: size.size.height)
        }
    }

}


#if DEBUG
struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        let url = URL(string: "https://soffes.com/assets/sam-soffes.jpg")! // <3 Sam

        AvatarView(url: url, size: .collection)
            .previewDisplayName("Collection")

        AvatarView(url: url, size: .profile)
            .previewDisplayName("Profile")

        AvatarView(url: url, size: .browse)
            .previewDisplayName("Browse")
    }
}
#endif
