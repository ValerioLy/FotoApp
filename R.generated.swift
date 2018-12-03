//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `Xcode.gitignore`.
    static let xcodeGitignore = Rswift.FileResource(bundle: R.hostingBundle, name: "Xcode", pathExtension: "gitignore")
    
    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "Xcode", withExtension: "gitignore")`
    static func xcodeGitignore(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.xcodeGitignore
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 6 images.
  struct image {
    /// Image `Checkbox`.
    static let checkbox = Rswift.ImageResource(bundle: R.hostingBundle, name: "Checkbox")
    /// Image `UnCheckbox`.
    static let unCheckbox = Rswift.ImageResource(bundle: R.hostingBundle, name: "UnCheckbox")
    /// Image `email-icon`.
    static let emailIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "email-icon")
    /// Image `illustration2`.
    static let illustration2 = Rswift.ImageResource(bundle: R.hostingBundle, name: "illustration2")
    /// Image `placeholder`.
    static let placeholder = Rswift.ImageResource(bundle: R.hostingBundle, name: "placeholder")
    /// Image `trees`.
    static let trees = Rswift.ImageResource(bundle: R.hostingBundle, name: "trees")
    
    /// `UIImage(named: "Checkbox", bundle: ..., traitCollection: ...)`
    static func checkbox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.checkbox, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "UnCheckbox", bundle: ..., traitCollection: ...)`
    static func unCheckbox(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.unCheckbox, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "email-icon", bundle: ..., traitCollection: ...)`
    static func emailIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.emailIcon, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "illustration2", bundle: ..., traitCollection: ...)`
    static func illustration2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.illustration2, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "placeholder", bundle: ..., traitCollection: ...)`
    static func placeholder(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.placeholder, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "trees", bundle: ..., traitCollection: ...)`
    static func trees(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.trees, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 3 view controllers.
  struct segue {
    /// This struct is generated for `LaunchScreenController`, and contains static references to 1 segues.
    struct launchScreenController {
      /// Segue identifier `segueToAuth`.
      static let segueToAuth: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, LaunchScreenController, AuthScreenController> = Rswift.StoryboardSegueIdentifier(identifier: "segueToAuth")
      
      /// Optionally returns a typed version of segue `segueToAuth`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func segueToAuth(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, LaunchScreenController, AuthScreenController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.launchScreenController.segueToAuth, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `SignupController`, and contains static references to 1 segues.
    struct signupController {
      /// Segue identifier `segueUserInfo`.
      static let segueUserInfo: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, SignupController, UserInfoController> = Rswift.StoryboardSegueIdentifier(identifier: "segueUserInfo")
      
      /// Optionally returns a typed version of segue `segueUserInfo`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func segueUserInfo(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, SignupController, UserInfoController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.signupController.segueUserInfo, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    /// This struct is generated for `UserInfoController`, and contains static references to 1 segues.
    struct userInfoController {
      /// Segue identifier `segueTerms`.
      static let segueTerms: Rswift.StoryboardSegueIdentifier<UIKit.UIStoryboardSegue, UserInfoController, ContractController> = Rswift.StoryboardSegueIdentifier(identifier: "segueTerms")
      
      /// Optionally returns a typed version of segue `segueTerms`.
      /// Returns nil if either the segue identifier, the source, destination, or segue types don't match.
      /// For use inside `prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)`.
      static func segueTerms(segue: UIKit.UIStoryboardSegue) -> Rswift.TypedStoryboardSegueInfo<UIKit.UIStoryboardSegue, UserInfoController, ContractController>? {
        return Rswift.TypedStoryboardSegueInfo(segueIdentifier: R.segue.userInfoController.segueTerms, segue: segue)
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 5 storyboards.
  struct storyboard {
    /// Storyboard `AuthScreen`.
    static let authScreen = _R.storyboard.authScreen()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Login`.
    static let login = _R.storyboard.login()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Signup`.
    static let signup = _R.storyboard.signup()
    
    /// `UIStoryboard(name: "AuthScreen", bundle: ...)`
    static func authScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.authScreen)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Login", bundle: ...)`
    static func login(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.login)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "Signup", bundle: ...)`
    static func signup(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.signup)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 1 localization tables.
  struct string {
    /// This `R.string.localizable` struct is generated, and contains static references to 21 localization keys.
    struct localizable {
      /// en translation: Administrator
      /// 
      /// Locales: en, it
      static let lblUserInfoAdmin = Rswift.StringResource(key: "lblUserInfoAdmin", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Continue
      /// 
      /// Locales: en, it
      static let lblUserInfoContinue = Rswift.StringResource(key: "lblUserInfoContinue", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Different passwords
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedDifferentPasswordsTitle = Rswift.StringResource(key: "kAlertLoginFailedDifferentPasswordsTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Email
      /// 
      /// Locales: en, it
      static let lblUserInfoEmail = Rswift.StringResource(key: "lblUserInfoEmail", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Email
      /// 
      /// Locales: en, it
      static let textFieldUserInfoEmail = Rswift.StringResource(key: "TextFieldUserInfoEmail", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Empty fields
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedEmptyLabelsTitle = Rswift.StringResource(key: "kAlertLoginFailedEmptyLabelsTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Invalid mail
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedInvalidEmailTitle = Rswift.StringResource(key: "kAlertLoginFailedInvalidEmailTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Invalid password
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedInvalidPasswordTitle = Rswift.StringResource(key: "kAlertLoginFailedInvalidPasswordTitle", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Name
      /// 
      /// Locales: en, it
      static let lblUserInfoName = Rswift.StringResource(key: "lblUserInfoName", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Name
      /// 
      /// Locales: en, it
      static let textFieldUserInfoName = Rswift.StringResource(key: "TextFieldUserInfoName", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: No such user found
      /// 
      /// Locales: en, it
      static let kNoSuchUser = Rswift.StringResource(key: "kNoSuchUser", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Ok
      /// 
      /// Locales: en, it
      static let kAlertOkButton = Rswift.StringResource(key: "kAlertOkButton", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Password must be six characters long
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedInvalidPasswordMessage = Rswift.StringResource(key: "kAlertLoginFailedInvalidPasswordMessage", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Sign Up
      /// 
      /// Locales: en, it
      static let kSignupButton = Rswift.StringResource(key: "kSignupButton", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Sign Up
      /// 
      /// Locales: en, it
      static let kSignuplbl = Rswift.StringResource(key: "kSignuplbl", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Surname
      /// 
      /// Locales: en, it
      static let lblUserInfoSurname = Rswift.StringResource(key: "lblUserInfoSurname", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Surname
      /// 
      /// Locales: en, it
      static let textFieldUserInfoSurname = Rswift.StringResource(key: "TextFieldUserInfoSurname", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: The confirmation password is different
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedDifferentPasswordsMessage = Rswift.StringResource(key: "kAlertLoginFailedDifferentPasswordsMessage", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: You left one or more fields empty
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedEmptyLabelsMessage = Rswift.StringResource(key: "kAlertLoginFailedEmptyLabelsMessage", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Your email is invalid
      /// 
      /// Locales: en, it
      static let kAlertLoginFailedInvalidEmailMessage = Rswift.StringResource(key: "kAlertLoginFailedInvalidEmailMessage", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      /// en translation: Your information
      /// 
      /// Locales: en, it
      static let lblUserInfoinfo = Rswift.StringResource(key: "lblUserInfoinfo", tableName: "Localizable", bundle: R.hostingBundle, locales: ["en", "it"], comment: nil)
      
      /// en translation: Administrator
      /// 
      /// Locales: en, it
      static func lblUserInfoAdmin(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoAdmin", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Continue
      /// 
      /// Locales: en, it
      static func lblUserInfoContinue(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoContinue", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Different passwords
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedDifferentPasswordsTitle(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedDifferentPasswordsTitle", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Email
      /// 
      /// Locales: en, it
      static func lblUserInfoEmail(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoEmail", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Email
      /// 
      /// Locales: en, it
      static func textFieldUserInfoEmail(_: Void = ()) -> String {
        return NSLocalizedString("TextFieldUserInfoEmail", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Empty fields
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedEmptyLabelsTitle(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedEmptyLabelsTitle", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Invalid mail
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedInvalidEmailTitle(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedInvalidEmailTitle", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Invalid password
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedInvalidPasswordTitle(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedInvalidPasswordTitle", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Name
      /// 
      /// Locales: en, it
      static func lblUserInfoName(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoName", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Name
      /// 
      /// Locales: en, it
      static func textFieldUserInfoName(_: Void = ()) -> String {
        return NSLocalizedString("TextFieldUserInfoName", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: No such user found
      /// 
      /// Locales: en, it
      static func kNoSuchUser(_: Void = ()) -> String {
        return NSLocalizedString("kNoSuchUser", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Ok
      /// 
      /// Locales: en, it
      static func kAlertOkButton(_: Void = ()) -> String {
        return NSLocalizedString("kAlertOkButton", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Password must be six characters long
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedInvalidPasswordMessage(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedInvalidPasswordMessage", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Sign Up
      /// 
      /// Locales: en, it
      static func kSignupButton(_: Void = ()) -> String {
        return NSLocalizedString("kSignupButton", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Sign Up
      /// 
      /// Locales: en, it
      static func kSignuplbl(_: Void = ()) -> String {
        return NSLocalizedString("kSignuplbl", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Surname
      /// 
      /// Locales: en, it
      static func lblUserInfoSurname(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoSurname", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Surname
      /// 
      /// Locales: en, it
      static func textFieldUserInfoSurname(_: Void = ()) -> String {
        return NSLocalizedString("TextFieldUserInfoSurname", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: The confirmation password is different
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedDifferentPasswordsMessage(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedDifferentPasswordsMessage", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: You left one or more fields empty
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedEmptyLabelsMessage(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedEmptyLabelsMessage", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Your email is invalid
      /// 
      /// Locales: en, it
      static func kAlertLoginFailedInvalidEmailMessage(_: Void = ()) -> String {
        return NSLocalizedString("kAlertLoginFailedInvalidEmailMessage", bundle: R.hostingBundle, comment: "")
      }
      
      /// en translation: Your information
      /// 
      /// Locales: en, it
      static func lblUserInfoinfo(_: Void = ()) -> String {
        return NSLocalizedString("lblUserInfoinfo", bundle: R.hostingBundle, comment: "")
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try launchScreen.validate()
      try signup.validate()
      try authScreen.validate()
      try main.validate()
      try login.validate()
    }
    
    struct authScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = AuthScreenController
      
      let bundle = R.hostingBundle
      let name = "AuthScreen"
      
      static func validate() throws {
        if UIKit.UIImage(named: "email-icon") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'email-icon' is used in storyboard 'AuthScreen', but couldn't be loaded.") }
        if UIKit.UIImage(named: "trees") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'trees' is used in storyboard 'AuthScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = LaunchScreenController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct login: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Login"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = ViewController
      
      let bundle = R.hostingBundle
      let name = "Main"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct signup: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController
      
      let bundle = R.hostingBundle
      let name = "Signup"
      
      static func validate() throws {
        if UIKit.UIImage(named: "placeholder") == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'placeholder' is used in storyboard 'Signup', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
