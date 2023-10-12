//
//  ReviewDetailScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/12.
//

import SwiftUI

struct ReviewDetailScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var actionsheetActive: Bool = false
    @State private var alertActive: Bool = false
    
    let review: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label {
                    Text("\(review.nickname)").customFont(size: 16, weight: .bold)
                } icon: {
                    AsyncImage(url: review.avatarURL
                               , content: { phase in
                        if let image = phase.image {
                            image.imageFit().clipShape(Circle()).clipped()
                        } else {
                            Image("NoPoster").imageFit().clipShape(Circle()).clipped()
                        }
                    }).frame(width: 40, height: 40)
                }
                Spacer()
                Text(review.createdAt).customFont(color: .gray, size: 16, weight: .medium)
            }
            Divider().background(.gray)
            HStack(alignment: .top, spacing: 12) {
                AsyncImage(url: review.posterURL
                           , content: { phase in
                    if let image = phase.image {
                        image.imageFill().cornerRadius(8)
                    } else if phase.error != nil {
                        Image("NoPoster").imageFill().cornerRadius(8)
                    } else {
                        ProgressView()
                    }
                }).frame(width: 60, height: 90)
                VStack(alignment: .leading, spacing: 8) {
                    Text(review.workTitle).customFont(color: .white, size: 14, weight: .bold)
                    Label {
                        Text("\(review.rating)").customFont(color: .yellow, size: 16, weight: .bold)
                    } icon: {
                        Image(systemName: "star.fill").resizable().frame(width: 16, height: 16).foregroundColor(.yellow)
                    }.padding(6).overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(.gray, lineWidth: 1))
                }.padding(.top, 12)
            }
            Divider().background(.gray)
            Text(review.title).customFont(color: Color("BgThird"), size: 20, weight: .bold).padding(.top, 10)
            Text(review.text).customFont(size: 18, weight: .semibold).padding(.top, 12)
            Spacer()
        }.background(.black).padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavigationTitle.reviewDetail)
            .navigationBarItems(trailing: Image(systemName: "square.and.pencil").onTapGesture {
                self.actionsheetActive = true
            }.confirmationDialog("title", isPresented: $actionsheetActive, actions: {
                Button("수정", role: .destructive) {
                    // 수정화면으로 이동
                }
                Button("삭제", role: .destructive) {
                    guard let uid = LocalData.shared.userId else {
                        print("no authorization - ReviewDetailScreen")
                        return
                    }
                    Task {
                        await ReviewService.deleteReview(uid: uid, workId: review.workId)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }))
    }
}
