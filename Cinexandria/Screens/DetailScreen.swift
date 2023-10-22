//
//  DetailScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/09.
//

import SwiftUI
import YouTubePlayerKit

struct LabelConfig {
    let text: String
    let iconColor: Color
}

struct DetailScreen: View {
    
    @EnvironmentObject private var appState: AppState
    
    @ObservedObject private var detailVM = DetailViewModel.shared
    
    let media: MediaType
    
    let id: Int
    
    @State private var likeLabel: LabelConfig = LabelConfig(text: "찜하기", iconColor: .gray)
    @State private var reviewLabel: LabelConfig = LabelConfig(text: "리뷰작성", iconColor: .gray)
    @State private var loginPopupActive: Bool = false
    @State private var creditPopupActive: Bool = false
    @State private var selectedCredit: CreditViewModel?
    @State private var floatActive: Bool = false
    @State private var floatMessage: String = ""
    
    private func likeLabelTapped() async {
        if !detailVM.isLoggined {
            self.loginPopupActive = true
            return
        }
        if detailVM.isLiked {
            await detailVM.likeCancel()
            self.floatMessage = Constants.message.likeCancel
        } else {
            await detailVM.likeWork()
            self.floatMessage = Constants.message.likeWork
        }
        // 찜버튼을 눌렀을때 즉각적으로 ui를 변경하기 위함
        configLikeLabel(isLiked: detailVM.isLiked)
        self.floatActive = true
    }
    
    private func configLikeLabel(isLiked: Bool) {
        self.likeLabel = isLiked ? LabelConfig(text: "찜해제", iconColor: .yellow) : LabelConfig(text: "찜하기", iconColor: .gray)
    }
    
    private func configReviewLabel(isReviewWritten: Bool) {
        self.reviewLabel = isReviewWritten ? LabelConfig(text: "리뷰수정", iconColor: .yellow) : LabelConfig(text: "리뷰작성", iconColor: .gray)
    }
    
    private func getReviewDestination() -> AnyView {
        if let myReview = detailVM.myReview {
            return AnyView(ReviewUpdateScreen(review: myReview))
        } else {
            return AnyView(ReviewWriteScreen(work: detailVM.workDetail))
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                AsyncImage(url: detailVM.workDetail?.backdrop
                           , content: { phase in
                    
                    if let image = phase.image {
                        image.imageFill().BackDropFilter()
                    } else if phase.error != nil {
                        Image("NoPoster").imageFill().BackDropFilter()
                    } else {
                        ProgressView()
                    }
                }).frame(height: 240)
                VStack(alignment: .leading, spacing: 10) {
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
                                image.imageFit().cornerRadius(10, corners: .allCorners)
                            } else if phase.error != nil {
                                Image("NoPoster").imageFit().cornerRadius(10, corners: .allCorners)
                            } else {
                                ProgressView()
                            }
                        }).frame(height: 160)
                    }
                    HStack(spacing: 24) {
                        Label {
                            Text(likeLabel.text).customFont(color: likeLabel.iconColor, size: 14, weight: .bold)
                        } icon: {
                            Image(systemName: "bookmark.fill").imageFill().frame(width: 18, height: 18)
                        }.labelStyle(VerticalLabelStyle()).foregroundColor(likeLabel.iconColor).onTapGesture {
                            Task {
                                await likeLabelTapped()
                            }
                        }
                        
                        if detailVM.isLoggined {
                            NavigationLink(destination: getReviewDestination()) {
                                Label {
                                    Text(reviewLabel.text).customFont(color: reviewLabel.iconColor, size: 14, weight: .bold)
                                } icon: {
                                    Image(systemName: "pencil").imageFill().frame(width: 18, height: 18)
                                }.labelStyle(VerticalLabelStyle()).foregroundColor(reviewLabel.iconColor)
                            }
                        } else {
                            Label {
                                Text(reviewLabel.text).customFont(color: reviewLabel.iconColor, size: 14, weight: .bold)
                            } icon: {
                                Image(systemName: "pencil").imageFill().frame(width: 18, height: 18)
                            }.labelStyle(VerticalLabelStyle()).foregroundColor(reviewLabel.iconColor).onTapGesture {
                                self.loginPopupActive = true
                            }
                        }
                        
                        Spacer()
                    }
                    Group {
                        if let hashTagItems = detailVM.workDetail?.hashTagItems {
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], alignment: .leading, spacing: 10) {
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
                        if let videoSource = self.detailVM.videoSource {
                            YouTubePlayerView(YouTubePlayer(
                                source: videoSource,
                                configuration: .init()
                            )) { state in
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
                        CreditList(popupActive: $creditPopupActive, selectedCredit: $selectedCredit, credits: (detailVM.workDetail?.media == .movie) ? detailVM.workDetail?.movieActors : detailVM.workDetail?.tvActors)
                        Divider().background(Color.gray)
                        Text("제작진").SubTitleView()
                        CreditList(popupActive: $creditPopupActive, selectedCredit: $selectedCredit, credits: (detailVM.workDetail?.media == .movie) ? detailVM.workDetail?.movieStaffs : detailVM.workDetail?.tvStaffs)
                        Divider().background(Color.gray)
                    }
                    
                    Group {
                        Text("모든 리뷰").SubTitleView()
                        AllReviewList(reviews: detailVM.reviews, reviewCount: detailVM.reviewCount, workId: id).padding(.horizontal, 10)
                        Divider().background(Color.gray)
                    }.padding(.bottom, 20)
                }.padding(.horizontal, 12)
                
            }
        }
        .background(.black)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            appState.loadingState = .loading
            await detailVM.load(media: self.media, id: self.id)
            configLikeLabel(isLiked: LocalData.shared.userId != nil && detailVM.isLiked)
            configReviewLabel(isReviewWritten: LocalData.shared.userId != nil && detailVM.myReview != nil)
            appState.loadingState = .idle
        }.loadingWrapper(appState.loadingState)
            .popup(isPresented: $loginPopupActive) {
                LoginPopup(isPresented: $loginPopupActive)
            } customize: {
                $0
                    .closeOnTap(false)
                    .backgroundColor(.black.opacity(0.4))
            }
            .popup(isPresented: $floatActive) {
                SuccessFloat(message: floatMessage)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .autohideIn(2)
            }
            .popup(isPresented: $creditPopupActive) {
                if let selectedCredit = selectedCredit {
                    CreditPopup(isPresented: $creditPopupActive, credit: selectedCredit)
                }
            } customize: {
                $0.closeOnTap(false).closeOnTapOutside(true).backgroundColor(.black.opacity(0.4))
            }
    }
}

