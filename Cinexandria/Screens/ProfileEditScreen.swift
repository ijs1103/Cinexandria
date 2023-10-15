//
//  ProfileEditScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/03.
//

import SwiftUI
import PopupView

struct ProfileEditScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var loginVM: LoginViewModel
    @ObservedObject private var profileEditVM: ProfileEditViewModel
    @State private var showImagePicker: Bool = false 
    @State private var previewImage: UIImage? = nil
    @State private var uid: String
    @State private var nickname: String
    @State private var buttonDisabled: Bool = true
    @State private var floatActive: Bool = false
    
    init(loginVM: LoginViewModel = LoginViewModel.shared, profileEditVM: ProfileEditViewModel = ProfileEditViewModel()) {
        self.loginVM = loginVM
        self.profileEditVM = profileEditVM
        _uid = State(initialValue: loginVM.profile?.uid ?? "")
        _nickname = State(initialValue: loginVM.profile?.nickname ?? "")
    }
    
    private func handleButtonClick() {
        if let previewImage = previewImage, let resized = previewImage.resize(to: CGSize(width: 120, height: 120)), let imageData = resized.pngData() {
            Task {
                if let urlString = await profileEditVM.uploadImageAndGetURL(data: imageData)?.absoluteString {
                    profileEditVM.updateProfile(data: ["photoURL": urlString, "nickname": nickname])
                }
            }
        } else {
            profileEditVM.updateProfile(data: ["nickname": nickname])
        }
        hideKeyboard()
        self.floatActive = true 
    }
    
    var body: some View {
        VStack {
            AvatarView(profile: loginVM.profile, isEditing: true, previewImage: previewImage).onTapGesture {
                showImagePicker = true
            }.padding(.bottom, 12).sheet(isPresented: $showImagePicker) {
                ImagePickerView(showImagePicker: $showImagePicker, image: $previewImage)
            }.onChange(of: previewImage) { value in
                if value != nil {
                    self.buttonDisabled = false
                }
            }
            CustomTextField(config: TextFieldConfig(label: "ID (이메일)", defaultText: $uid, defaultTextCount: uid.count, isDisabled: true, limit: nil, placeholder: "")).padding(.bottom, 12)
            CustomTextField(config: TextFieldConfig(label: "닉네임", defaultText: $nickname, defaultTextCount: nickname.count, isDisabled: false, limit: 20, placeholder: "변경할 닉네임을 입력")).onChange(of: nickname) { value in
                self.buttonDisabled = (value.count > 0) ? false : true
            }
            Spacer()
            Button {
                handleButtonClick()
            } label: {
                Text("저장").frame(height: 45).frame(maxWidth: .infinity).customFont(color: .white, size: 18, weight: .bold).background(buttonDisabled ? .gray : .blue)
            }.disabled(buttonDisabled).cornerRadius(10)
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.black).padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavigationTitle.profileEdit)
            .onTapGesture {
                hideKeyboard()
            }
            .popup(isPresented: $floatActive) {
                SuccessFloat(message: Constants.message.profileEdit)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .autohideIn(2)
                    .dismissSourceCallback { _ in
                        presentationMode.wrappedValue.dismiss()
                    }
            }
    }
}
