//
//  NetworkingManager.swift
//  buzzmash-ios
//
//  Created by Rishish Aryal on 5/9/24.
//








import Foundation
import Combine
import UIKit


enum NetworkManagerEnum {
    case post,get,put,delete,patch
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

class NetworkingManager{
    
    
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        case badUrl
        case badRequest(message : String)
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "Bad response from URL: \(url)"
            case .unknown: return " Unknown error occured"
            case .badUrl : return "Bad url response occured"
            case.badRequest(message: let message) : return message
                
            }
        }
    }
    
    
    static func HandleAllUrlRequest(networkCallType : NetworkManagerEnum, url: URL , credentials : [String:Any]? = nil ,token: String? = nil ,images : [UIImage]? = nil ) throws -> AnyPublisher<Data, Error>  {
        if(networkCallType == NetworkManagerEnum.get){
            var request = URLRequest(url: url)
            request.timeoutInterval =  10
            request.httpMethod = "GET"
            if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                print(token)
            }
            
            
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ try handleURLResponse(output: $0, url: url) })
                .retry(3)
                .eraseToAnyPublisher()
        }
        
        
        else if (networkCallType == NetworkManagerEnum.put){
            let request = try putData(url: url, credentials: credentials,token: token,images: images)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ try NetworkingManager.handleURLResponsePost(output: $0, url: url) })
                .retry(3)
                .eraseToAnyPublisher()
            
        }
        
        else if (networkCallType == NetworkManagerEnum.delete){
            let request = try deletePost(url: url,credentials: credentials)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ try NetworkingManager.handleURLResponsePost(output: $0, url: url) })
                .retry(3)
                .eraseToAnyPublisher()
            
        }
        
        else if(networkCallType == NetworkManagerEnum.patch){
            let request = try patchData(url: url, credentials: credentials,token: token,images: images)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ try NetworkingManager.handleURLResponsePost(output: $0, url: url) })
                .retry(1)
                .eraseToAnyPublisher()
            
            
        }
       
            let request = try postData(url: url, credentials: credentials,token: token,images: images)
            return URLSession.shared.dataTaskPublisher(for: request)
                .tryMap({ try NetworkingManager.handleURLResponsePost(output: $0, url: url) })
                .retry(3)
                .eraseToAnyPublisher()
        
    }
    
    
    static func postData(url:URL ,credentials : [String:Any]? = nil , token: String? = nil , images : [UIImage]? = nil) throws -> URLRequest  {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval =  10
        
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let credentials = credentials{
            guard let postData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
                print("Failed to encode credentials")
                throw NetworkingError.unknown
            }
            request.httpBody = postData
            
        }
        
        
        //  request.setValue("Bearer token", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
      
        
        return request
    }
    
    static func deletePost(url:URL ,credentials : [String:Any]? = nil , token: String? = nil , images : [UIImage]? = nil) throws -> URLRequest  {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let credentials = credentials{
            guard let postData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
                print("Failed to encode credentials")
                throw NetworkingError.unknown
            }
            request.httpBody = postData
            
        }
        
        
        //  request.setValue("Bearer token", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
      
        
        return request
    }
    
    
    static func putData(url: URL, credentials: [String: Any]? = nil, token: String? = nil, images: [UIImage]? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval =  10
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let credentials = credentials {
            guard let postData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
                print("Failed to encode credentials")
                throw NetworkingError.unknown
            }
            request.httpBody = postData
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    static func patchData(url: URL, credentials: [String: Any]? = nil, token: String? = nil, images: [UIImage]? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.timeoutInterval =  10
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print(token)
        }
        
        if let credentials = credentials {
            guard let postData = try? JSONSerialization.data(withJSONObject: credentials, options: []) else {
                print("Failed to encode credentials")
                throw NetworkingError.unknown
            }
            request.httpBody = postData
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        
     
        if let response = output.response as? HTTPURLResponse, response.statusCode == 401{
            
          
            
        }
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
       
        
        return output.data
    }
    
    
    
    static func handleURLResponsePost(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
    
        
        let json = try JSONSerialization.jsonObject(with: output.data, options: [])
        print(json)
        if let response = output.response as? HTTPURLResponse, response.statusCode == 401{
           
          
            
        }
        guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
            if let dictionary = json as? [String: Any] {
                if let  status = dictionary["Status"] as? Int {
                    if(status == 0){
                        if let message = dictionary["Message"] as? String {
                            throw NetworkingError.badRequest(message: message )
                        }
                    }
                    
                }
            }
           
            throw NetworkingError.badURLResponse(url: url)
        }
        
        
        
        if let dictionary = json as? [String: Any] {
            if let  status = dictionary["Status"] as? Int {
                if(status == 0){
                    if let message = dictionary["Message"] as? String {
                        throw NetworkingError.badRequest(message: message )
                    }
                }
                
            }
        }
        return output.data
    }
    
        
    
    
    
    
    static func postDataWithImages(url:URL, images: [UIImage]) throws -> URLRequest  {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let token = UserDefaults.standard.string(forKey: ApplicationText.token) {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
       
       // Set the content type to multipart/form-data
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
        let httpBody = NSMutableData()
            
            // Add image data to request body
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    httpBody.appendString("--\(boundary)\r\n")
                    httpBody.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"image.jpg\"\r\n")
                    httpBody.appendString("Content-Type: image/jpeg\r\n")
                    httpBody.appendString("\r\n")
                    httpBody.append(imageData)
                    httpBody.appendString("\r\n")
                }
            }
            
            httpBody.appendString("--\(boundary)--\r\n")
            
            request.httpBody = httpBody as Data
        return request
    }
    

    
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
  
        }
    }
    
    
    
    
}
class ApplicationText{
    
    // DataBase storageKeys
    
    static let token = "Token"
    static let themeId = "ThemeID"
    static let deviceToken = "DeviceToken"
    static let userId = "UserID"
    static let username = "userName"
    static let profileUrl = "profileUrl"
    static let phoneNumber = "phoneNumber"
    // userRegistration
    static let registrationHeading = "Get Started With\nA New Account"
    static let userName = "Username"
    static let Name = "Name"
    static let selectYourGender = "Select your Gender"
    static let selectGender = "Select Gender"
    static let birthDate = "Birth Date"
    static let signUp = "SIGN UP"
    static let continueToLogIn = "Continue To Login"
    static let signUpTermsMessage = "By clicking “Sign Up” button, you accept to our terms and conditions."
    
    
    //otp verification
    static let otpVerification = "Mobile \nVERIFICATION"
    static let phonenumber = "Phone Number"
    static let getOtp = "GET OTP"
    static let countryCode = "Country Code"
    static let otpVerificationTermMessage = "We will send you an One Time Password on this mobile number"
    static let enterOtp = "Enter the OTP that was sent to"
    static let resentOtp = "RESEND OTP"
    static let verifyAndProceed = "Verify and Proceed"
    static let backToNumber = "Back To Phone Number"
    static let didNotReceivedCode = "Didn't receive the OTP?"
    static let didNotReceivedVerificationCode = "Didn't receive a verification code?"
    static let pleseCheckSms = "Please check your SMS message before requestion another code"
    

    //validation message
    static let userNameEmptyValidation = "UserName must not be empty"
    static let nameEmptyValidation = "Name must not be empty"
    static let phoneNumberEmptyValidation = "Phone Number must not be empty"
    static let phoneNumberShouldBeTen = "Phone Number should equal to 10"
    static let InValidNumber = "In valid number"
    
    
    //Colors
    static let accentColor = "AccentColor"
    static let backgroundColor = "BackgroundColor"
    static let themeColorPrimary = "themeColor"
    static let inactiveColor = "InactiveColor"
    static let blackWhite = "blackWhite"
    
    
    // New Theme Colors
    static let primaryBackgroundColor = "primaryBackgroundColor"
    static let secondaryBackgroundColor = "secondaryBackgroundColor"
    static let secondaryTextColor = "SecondaryTextColor"
    static let textColor = "textColor"
    static let primaryColor = "primaryColor"
    static let primaryButtonBackgroundColor = "primaryButtonBackgroundColor"
    
    // UI Text
    static let editPreference = "EDIT PREFRRENCES"
    static let selectTheme = "Select Theme"
    static let shared = "SHARED"
    static let new = "NEW"
    static let memmoryLane = "MEMORYLANE"
    static let welcome = "WELCOME"
    static let to = "TO"
    static let chooseAcountry = "Choose a country"
    static let selectDate = "Select Date"
    static let enterAtime = "Please enter a time"
    static let addFriendMessage = "To add a friend, simply enter your friends username. If your friend has already send you a request or send request after you both will be connected."
    static let addFriend = "Add Friend"
    static let cancel = "Cancel"
    
    // Icons
    static let twoPerson =  "person.2"
    static let plusCircle  = "plus.circle"
    static let person = "person"
    
    
    // gallery
    
    static let allPhotos = "All Photos"
    static let dummyImageUrl = "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png"
    
    
    
    // PhotoDump
    
    static let noDump = "NO DUMP PREVIOUS MONTH"
    static let footerMessage1 = "Place where you can add all the dump of the month"
    static let footerMessage2 = "Dump will be public on month end."
    
    
    //
    static let currentYear = 2023
    
    
    
}
