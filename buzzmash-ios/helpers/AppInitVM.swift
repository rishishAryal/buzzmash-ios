//
//  AppInitVM.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/10/24.
//

import Foundation


class AppInitVM:ObservableObject {
    
    @Published var getBlogCategoryIsLoading:Bool = false
    @Published var getBlogCategory:GetBlogCategory?
    @Published var getBlogCategoryResponse:String = ""
    @Published var requiredBlogCategory:[Category] = []
    
    
    
    
    private var appInitRepo:AppInitRepo
    
  private  init( appInitRepo: AppInitRepo) {
        
        self.appInitRepo = appInitRepo
    }
    
    static let appInitVM = AppInitVM(appInitRepo: AppInitRepo(appInitRepo: AppInitService()))
    
    func getCategory (){
        self.getBlogCategoryIsLoading = true
        self.appInitRepo.getBlogCategory { response in
            self.getBlogCategory = response.responseData
            if(response.errorMessage != "" || !response.isSucess) {
                self.getBlogCategoryResponse = response.errorMessage
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                    self.getBlogCategoryResponse = ""
                    self.getBlogCategoryIsLoading = false

                    
                }
            } else {
                self.requiredBlogCategory = self.getBlogCategory?.categories ?? []
                self.getBlogCategoryIsLoading = false
            }
        }
        
    }
    
    
}
