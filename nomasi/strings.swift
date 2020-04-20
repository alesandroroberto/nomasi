// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Authorization {
    internal enum AppleSignIn {
      internal enum Success {
        /// Auth success
        internal static let message = L10n.tr("Localizable", "Authorization.AppleSignIn.Success.message")
      }
    }
    internal enum Auth {
      /// Authorization
      internal static let title = L10n.tr("Localizable", "Authorization.Auth.Title")
      internal enum Button {
        /// Auth
        internal static let title = L10n.tr("Localizable", "Authorization.Auth.Button.Title")
      }
    }
    internal enum Error {
      /// Empty email
      internal static let emptyEmail = L10n.tr("Localizable", "Authorization.Error.emptyEmail")
      /// Empty email or password
      internal static let emptyFields = L10n.tr("Localizable", "Authorization.Error.emptyFields")
      /// Confirm password not equal to password
      internal static let passwordConfirmation = L10n.tr("Localizable", "Authorization.Error.passwordConfirmation")
      /// Empty email, password or password confirmation
      internal static let registerCredentials = L10n.tr("Localizable", "Authorization.Error.registerCredentials")
      /// Undefined error
      internal static let undefined = L10n.tr("Localizable", "Authorization.Error.undefined")
    }
    internal enum ForgotPassword {
      /// Forgot password
      internal static let title = L10n.tr("Localizable", "Authorization.ForgotPassword.Title")
      internal enum Reset {
        internal enum Alert {
          internal enum Confirm {
            /// Are you sure, reset password?
            internal static let message = L10n.tr("Localizable", "Authorization.ForgotPassword.Reset.Alert.Confirm.message")
          }
          internal enum Success {
            /// We send email, check email
            internal static let message = L10n.tr("Localizable", "Authorization.ForgotPassword.Reset.Alert.Success.message")
          }
        }
        internal enum Button {
          /// Reset password
          internal static let title = L10n.tr("Localizable", "Authorization.ForgotPassword.Reset.Button.title")
        }
      }
    }
    internal enum Placeholder {
      /// Confirm Password
      internal static let confirmPassword = L10n.tr("Localizable", "Authorization.Placeholder.confirmPassword")
      /// Email
      internal static let email = L10n.tr("Localizable", "Authorization.Placeholder.email")
      /// Password
      internal static let password = L10n.tr("Localizable", "Authorization.Placeholder.password")
    }
    internal enum Registration {
      /// Registration
      internal static let title = L10n.tr("Localizable", "Authorization.Registration.Title")
      internal enum AuthButton {
        /// Go to authorization
        internal static let title = L10n.tr("Localizable", "Authorization.Registration.AuthButton.Title")
      }
      internal enum Button {
        /// Register
        internal static let title = L10n.tr("Localizable", "Authorization.Registration.Button.Title")
      }
    }
    internal enum RestorePassword {
      internal enum Button {
        /// Restore Password
        internal static let title = L10n.tr("Localizable", "Authorization.RestorePassword.Button.Title")
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
