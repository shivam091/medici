# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Additional translations at https://github.com/heartcombo/devise/wiki/I18n

{
  en: {
    devise: {
      confirmations: {
        confirmed: "Your email address has been successfully confirmed.",
        send_instructions: "You will receive an email with instructions for how to confirm your email address in a few minutes.",
        send_paranoid_instructions: "If your email address exists in our database, you will receive an email with instructions for how to confirm your email address in a few minutes.",
      },
      failure: {
        already_authenticated: "You are already signed in.",
        inactive: "Your account is not activated yet.",
        invalid: "It looks like your mobile number/email and password combination isn't quite right, please try again.",
        locked: "Your account is locked either due to excessive failed attempts. Please communicate with administrator for further assistance.",
        last_attempt: "You have left one more attempt and your account access will be locked if this attempt is failed.",
        timeout: "Unfortunately your session is expired due to inactivity for a long time. Please sign in again to pickup from where you left off.",
        unauthenticated: "You need to sign in or sign up before continuing.",
        unconfirmed: "You need to verify your email address before sign in. Please check your inbox and spam folder for mail regarding email verification instructions and if you did not receive the instructions, please click on 'Didn't receive verification instructions' link on below side.",
        suspended: "Your account is suspended. If you believe your account was suspended by mistake, please communicate with administrator for further assistance.",
        not_found_with_mobile_number: "We could not find an account with that mobile number.",
        not_found_with_email_address: "We could not find an account with that email address.",
        not_found_with_mobile_number_and_password: "We could not find an account with that mobile number and password.",
        not_found_with_email_address_and_password: "We could not find an account with that email address and password.",
      },
      mailer: {
        confirmation_instructions: {
          subject: "Confirmation instructions"
        },
        reset_password_instructions: {
          subject: "Reset password instructions"
        },
        unlock_instructions: {
          subject: "Unlock instructions"
        },
        email_changed: {
          subject: "Email Changed"
        },
        password_change: {
          subject: "Password Changed"
        },
      },
      omniauth_callbacks: {
        failure: "Could not authenticate you from %{kind} because \"%{reason}\".",
        success: "Successfully authenticated from %{kind} account."
      },
      passwords: {
        no_token: "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.",
        send_instructions: "You will receive an email with instructions on how to reset your password in a few minutes.",
        send_paranoid_instructions: "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.",
        updated: "Your password has been changed successfully. You are now signed in.",
        updated_not_active: "Your password has been changed successfully.",
        not_send_password_reset_instructions: "Failed to send password reset instructions",
        throttle_reset: {
          one: "Password reset instructions can be sent only once in a minute. Please wait a few minutes before you try again.",
          other: "Password reset instructions can be sent only once in %{count} minutes. Please wait a few minutes before you try again.",
        },
        token_invalid: "Your password reset link appears to be invalid. Please request a new link below.",
        token_expired: "Your password reset link has expired. Please generate a new reset password link.",
      },
      registrations: {
        destroyed: "Bye! Your account has been successfully cancelled. We hope to see you again soon.",
        signed_up: "Welcome to Medici! You have signed up successfully.",
        signed_up_but_inactive: "You have signed up successfully. However, we could not sign you in because your account is not yet activated.",
        signed_up_but_locked: "You have signed up successfully. However, we could not sign you in because your account is locked.",
        signed_up_but_unconfirmed: "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.",
        update_needs_confirmation: "You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirmation link to confirm your new email address.",
        updated: "Your account has been updated successfully.",
        updated_but_not_signed_in: "Your account has been updated successfully, but since your password was changed, you need to sign in again.",
      },
      sessions: {
        signed_in: "Hi %{user_name}, welcome to Medici!",
        signed_out: "You are successfully signed out.",
        already_signed_out: "You are already signed out of your account. Please sign in again.",
        missing_email_mobile_or_password: "Please enter your mobile number/email and password",
      },
      unlocks: {
        send_instructions: "You will receive an email with instructions for how to unlock your account in a few minutes.",
        send_paranoid_instructions: "If your account exists, you will receive an email with instructions for how to unlock it in a few minutes.",
        unlocked: "Your account has been unlocked successfully. Please sign in to continue.",
      },
    },
    errors: {
      messages: {
        already_confirmed: "was already confirmed, please try signing in",
        confirmation_period_expired: "needs to be confirmed within %{period}, please request a new one",
        expired: "has expired, please request a new one",
        not_found: "not found",
        not_locked: "was not locked",
        not_saved: {
          one: "1 error prohibited this %{resource} from being saved:",
          other: "%{count} errors prohibited this %{resource} from being saved:",
        },
      },
    },
  }
}
