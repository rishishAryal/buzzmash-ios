//
//  EditBlogView.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/10/24.
//

import SwiftUI
import PhotosUI


struct EditBlogView: View {
    @State var title:String
    @State var desc:String
    @State var category:String
    @Binding var thumbnail:String 
    @State var author:String
    @State var blogID:String
    var appInitVM:AppInitVM = AppInitVM.appInitVM
    @ObservedObject var blogVM:BlogViewModel
    @State var selectedId:String = ""
    @Namespace var namesapce
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var imageToShow: Image?


    var body: some View {
        ScrollView{
            VStack {
                    
                
                if let image = imageToShow {
                    image .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 300)
                        .clipped()
                } else {
                    if(!thumbnail.isEmpty) {
                        AsyncImage(url: URL(string: thumbnail)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 300)
                                .clipped()
                            
                        } placeholder: {
                            Rectangle().foregroundStyle(.gray.opacity(0.2)) .frame(width: UIScreen.main.bounds.width, height: 300)
                        }
                }
                
              
                }
                VStack {
                    
                    Button(action: {
                        showingImagePicker.toggle()
                    }, label: {
                        Text("Select Thumbnail")
                    })
                    
                }.padding()
                    .sheet(isPresented: $showingImagePicker) {
                              ImagePicker(image: $inputImage, imageToShow: $imageToShow)
                          }
                
                
                
                if let image = inputImage {
                    Text("Update Thumbnail").padding(7).foregroundStyle(.white).background(.blue).clipShape(RoundedRectangle(cornerRadius: 10)).onTapGesture(perform: {
                        blogVM.uploadImage(image: image, id: blogID) { isSuccess, data, error in
                            
                            if isSuccess {
                                inputImage = nil
                                imageToShow = nil
                                thumbnail = data?.thumbnail ?? ""
                                showingImagePicker = false
                            }
                            
                        }
                    })
                }
                VStack(alignment: .leading,spacing: 5){
                    Text("Title").font(.caption)
                    TextField("title", text: $title)
                        
                        .textFieldStyle(.roundedBorder)
                }.padding()
                VStack(alignment: .leading,spacing: 5){
                    Text("Description").font(.caption)

                    TextField("Description", text: $desc, axis: .vertical)
                        
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                VStack(alignment: .leading){
                    Text("Some Famous Category").font(.footnote)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(appInitVM.requiredBlogCategory, id: \.id){cat in
                                
                                
                                
                                VStack(spacing: 5) {
                                    Text(cat.name).bold()
                                    if (selectedId == cat.name){
                                        Rectangle().frame(height: 3)
                                            .foregroundStyle(.green).matchedGeometryEffect(id: "category", in: namesapce)
                                    }
                                    else {
                                        Rectangle().frame(height: 3) .foregroundStyle(.clear)
                                    }
                                    
                                }
                                .onTapGesture(perform: {
                                    withAnimation {
                                        selectedId = cat.name
                                        category = cat.name

                                    }
                                })
                                
                                
                               
                               
                            }
                        }
                    }
                }.padding().background(.gray.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 10)).padding(.horizontal).onAppear {
                    selectedId = category
                }
                VStack(alignment: .leading,spacing: 5){
                    Text("Category").font(.caption)
                    TextField("category", text: $category)
                        
                        .textFieldStyle(.roundedBorder)
                }.padding()
                
                Button {
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10).frame(height: 50).overlay {
                        Text("Update").foregroundStyle(.white)

                        
                       
                    }.padding(.horizontal).padding(.vertical,15)
                }

                Spacer()
            }
        }
    }
}
//
//#Preview {
//    EditBlogView()
//}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var imageToShow: Image?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.imageToShow = Image(uiImage: uiImage) // Update the UI with selected image
            }
            
            picker.dismiss(animated: true)
        }
    }
}
