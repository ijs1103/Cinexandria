//
//  DetailScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/09.
//

import SwiftUI
import YouTubePlayerKit

struct DetailScreen: View {
    
    @ObservedObject private var detailVM = DetailViewModel()
    
    let work: WorkViewModel

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: detailVM.workDetail?.backdrop
                           , content: { phase in
                    
                    if let image = phase.image {
                        image.resizable()
                            .scaledToFill().BackDropFilter()
                    } else if phase.error != nil {
                        Image("NoPoster").resizable()
                            .scaledToFill()
                    } else {
                        ProgressView()
                    }
                })
                HStack {
                    VStack(alignment: .leading) {
                        Text(detailVM.workDetail?.title ?? "").customFont(color: .white, size: 20, weight: .bold).padding(.bottom, 6)
                        HStack(alignment: .top, spacing: 0) {
                            Text(detailVM.workDetail?.originalTitle ?? "")
                            Text(" · ")
                            Text(detailVM.workDetail?.releaseYear ?? "")
                        }.customFont(color: .gray, size: 14, weight: .semibold).padding(.bottom, 10)
                        
                        Label {
                            Text(detailVM.workDetail?.rating ?? "").customFont(color: .green, size: 20, weight: .heavy)
                        } icon: {
                            Image(systemName: "star.fill").resizable().frame(width: 22, height: 22)
                        }.foregroundColor(.green)
                        
                        Label {
                            Text(detailVM.imdbRating ?? "·").customFont(size: 18, weight: .heavy)
                        } icon: {
                            Image("Imdb").resizable().frame(width: 24, height: 16).foregroundColor(.yellow)
                        }
                    }
                    Spacer()
                    AsyncImage(url: detailVM.workDetail?.poster
                               , content: { phase in
                        if let image = phase.image {
                            image.ImageModifier().cornerRadius(10, corners: .allCorners)
                        } else if phase.error != nil {
                            Image("NoPoster").ImageModifier().cornerRadius(10, corners: .allCorners)
                        } else {
                            ProgressView()
                        }
                    }).frame(height: 160)
                }
                Group {
                    if let hashTagItems = detailVM.workDetail?.hashTagItems {
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],alignment: .leading,  spacing: 10) {
                                ForEach(hashTagItems, id: \.self) { item in
                                    Text(item).customFont(color: .teal, size: 14, weight: .bold).fixedSize()
                                }
                            }
                        }.padding(.vertical, 10)
                    }
                    Divider().background(Color.gray)
                }
                
                Group {
                    Text("작품 정보").SubTitleView()
                    if let overview = detailVM.workDetail?.overview, overview != "" {
                        Text(overview).lineSpacing(10).customFont(color: .gray, size: 14, weight: .semibold)
                    } else {
                        CustomEmptyView()
                    }
                    Divider().background(Color.gray)
                }
                
                Group {
                    Text("예고편").SubTitleView()
                    if let player = self.detailVM.youTubePlayer {
                        YouTubePlayerView(player) { state in
                            // Overlay ViewBuilder closure to place an overlay View
                            // for the current `YouTubePlayer.State`
                            switch state {
                            case .idle:
                                ProgressView()
                            case .ready:
                                EmptyView()
                            case .error(_):
                                Text(verbatim: "YouTube player couldn't be loaded")
                            }
                        }.frame(height: 220)
                            .background(Color(.black))
                            .shadow(
                                color: .black.opacity(0.1),
                                radius: 46,
                                x: 0,
                                y: 15
                            )
                    } else {
                        CustomEmptyView()
                    }
                    Divider().background(Color.gray)
                }
                
                Group {
                    Text("출연진").SubTitleView()
                    CreditList(credits: (detailVM.workDetail?.media == .movie) ? detailVM.workDetail?.movieActors : detailVM.workDetail?.tvActors)
                    Divider().background(Color.gray)
                    
                    Text("제작진").SubTitleView()
                    CreditList(credits: (detailVM.workDetail?.media == .movie) ? detailVM.workDetail?.movieStaffs : detailVM.workDetail?.tvStaffs)
                    Divider().background(Color.gray)
                }
                
                Group {
                    Text("모든 리뷰").SubTitleView()
                    AllReviewList(reviews: detailVM.reviews)
                    Divider().background(Color.gray)
                }.padding(.bottom, 20)
            }
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            detailVM.load(media: work.mediaType, id: work.id)
        }
        
    }
}

