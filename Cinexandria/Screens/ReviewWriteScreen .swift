//
//  ReviewWriteScreen .swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

struct ReviewWriteScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int?
    @State private var reviewTitle: String = ""
    @State private var reviewText: String = ""
    @State private var buttonDisabled: Bool = true

    let work: WorkDetailViewModel?
    
    private func handleButtonClick() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - ReviewWriteScreen")
            return
        }
        guard let rating = rating, let workId = work?.id, let mediaType = work?.media, let workTitle = work?.title else {
            return
        }
        do {
            let user = try await UserService.getUser(uid: uid)
            let data = Review(id: UUID().uuidString, uid: uid, workId: workId, mediaType: mediaType, nickname: user.nickname, photoURL: user.photoURL, rating: rating, workTitle: workTitle, title: reviewTitle, text: reviewText, createdAt: Date()).toDictionary()
            await ReviewService.setReview(data: data)
        } catch {
            print("firebase error - ReviewWriteScreen")
            return
        }
        await MainActor.run {
            hideKeyboard()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Spacer()
                AsyncImage(url: work?.poster
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
                    Text(work?.title ?? "무제").customFont(color: .white, size: 16, weight: .bold)
                    Text(work?.releaseYear ?? "xxxx").customFont(color: .gray, size: 14, weight: .semibold)
                }.padding(.top, 12)
            }
            
            RatingStar(rating: $rating)
            
            CustomTextField(config: TextFieldConfig(label: "리뷰 제목", defaultText: $reviewTitle, defaultTextCount: reviewTitle.count, isDisabled: false, limit: 16, placeholder: "제목을 입력")).onChange(of: reviewTitle) { value in
                self.buttonDisabled = (value.count > 0) ? false : true
            }
            
            CustomTextEditor(config: TextEditorConfig(label: "리뷰 내용", bindingText: $reviewText, bindingTextCount: reviewText.count, placeholder: "작품에 대한 감상을 남겨주세요", limit: 100))
                       
            Spacer()
            
            Button {
                Task {
                    await handleButtonClick()
                }
            } label: {
                Text("저장").frame(height: 45).frame(maxWidth: .infinity).customFont(color: .white, size: 18, weight: .bold).background(buttonDisabled ? .gray : .blue)
            }.disabled(buttonDisabled).cornerRadius(10)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black).padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavigationTitle.reviewWrite)
            .onTapGesture {
                hideKeyboard()
            }
    }
}

