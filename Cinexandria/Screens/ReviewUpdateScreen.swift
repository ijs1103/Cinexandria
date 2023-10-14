//
//  ReviewUpdateScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/13.
//

import SwiftUI
import PopupView

struct ReviewUpdateScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var rating: Int?
    @State private var reviewTitle: String
    @State private var reviewText: String
    @State private var buttonDisabled: Bool = true
    @State private var floatActive: Bool = false
    
    let review: ReviewViewModel
    
    init(review: ReviewViewModel) {
        self.review = review
        _rating = State(initialValue: review.rating)
        _reviewTitle = State(initialValue: review.title)
        _reviewText = State(initialValue: review.text)
    }
    
    private func handleButtonClick() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - ReviewUpdateScreen")
            return
        }
        guard let rating = rating else { return }
        let data = ["uid": uid, "workId": review.workId, "rating": rating, "title": reviewTitle, "text": reviewText] as [String: Any]
        await ReviewService.updateReview(data: data)
        self.floatActive = true
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Spacer()
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
                Text(review.workTitle).customFont(color: .white, size: 16, weight: .bold).padding(.top, 12)
                Spacer()
            }
            
            RatingStar(rating: $rating).onChange(of: rating) { _ in
                self.buttonDisabled = false
            }
            
            CustomTextField(config: TextFieldConfig(label: "리뷰 제목", defaultText: $reviewTitle, defaultTextCount: reviewTitle.count, isDisabled: false, limit: 16, placeholder: "제목을 입력")).onChange(of: reviewTitle) { _ in
                if reviewTitle.isEmpty {
                    self.buttonDisabled = true
                    return
                } else {
                    self.buttonDisabled = false
                }
            }
            
            CustomTextEditor(config: TextEditorConfig(label: "리뷰 내용", bindingText: $reviewText, bindingTextCount: reviewText.count, placeholder: "작품에 대한 감상을 남겨주세요", limit: 100)).onChange(of: reviewText) { _ in
                if reviewText.isEmpty {
                    self.buttonDisabled = true
                    return
                } else {
                    self.buttonDisabled = false
                }
            }
                       
            Spacer()
            
            Button {
                Task {
                    await handleButtonClick()
                }
            } label: {
                Text("수정").frame(height: 45).frame(maxWidth: .infinity).customFont(color: .white, size: 18, weight: .bold).background(buttonDisabled ? .gray : .blue)
            }.disabled(buttonDisabled).cornerRadius(10)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black).padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavigationTitle.reviewUpdate)
            .onTapGesture {
                hideKeyboard()
            }
            .popup(isPresented: $floatActive) {
                SuccessFloat(message: Constants.message.reviewUpdate)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .autohideIn(3)
                    .dismissSourceCallback { _ in
                        presentationMode.wrappedValue.dismiss()
                    }
            }
    }
}
