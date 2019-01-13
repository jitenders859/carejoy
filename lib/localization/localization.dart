import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:carejoy/l10n/messages_all.dart';

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get addNewChild {
    return Intl.message(
      'Add New Child',
      name: 'addNewChild',
      desc: 'Title for Creating Child',
    );
  }

  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: 'First Name',
    );
  }
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: 'Last Name',
    );
  }
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: 'Enter',
    );
  }
  String get dateOfBirth  {
    return Intl.message(
      'Date Of Birth',
      name: 'dateOfBirth',
      desc: 'Date Of Birth',
    );
  }
  String get presence {
    return Intl.message(
      'Presence',
      name: 'presence',
      desc: 'Presence',
    );
  }
  String get mon {
    return Intl.message(
      'Mon',
      name: 'mon',
      desc: 'Monday',
    );
  }
  String get tues {
    return Intl.message(
      'Tues',
      name: 'tues',
      desc: 'Tuesday',
    );
  }
  String get weds {
    return Intl.message(
      'Weds',
      name: 'weds',
      desc: 'Wednesday',
    );
  }
  String get thurs {
    return Intl.message(
      'Thurs',
      name: 'thurs',
      desc: 'Thursday',
    );
  }
  String get fri {
    return Intl.message(
      'Fri',
      name: 'fri',
      desc: 'Friday',
    );
  }
  String get sat {
    return Intl.message(
      'Sat',
      name: 'sat',
      desc: 'Saturday',
    );
  }
  String get complimentaryInformation {
    return Intl.message(
      'Complementary Information',
      name: 'complimentaryInformation',
      desc: 'Complementary Information',
    );
  }
  String get otherInformation {
    return Intl.message(
      'Other Information',
      name: 'otherInformation',
      desc: 'Other Information',
    );
  }
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: 'SAVE',
    );
  }
  
  String get selectAField {
    return Intl.message(
      'Select a Field',
      name: 'selectAField',
      desc: 'Select a field',
    );
  }
  String get education {
    return Intl.message(
      'Education',
      name: 'education',
      desc: 'First ',
    );
  }
  String get engineering {
    return Intl.message(
      'Engineering',
      name: 'engineering',
      desc: 'Engineering',
    );
  }
  String get biology {
    return Intl.message(
      'Biology',
      name: 'biology',
      desc: 'Biology',
    );
  }
  String get food {
    return Intl.message(
      'Food',
      name: 'food',
      desc: 'Food',
    );
  }
  String get dayCare {
    return Intl.message(
      'DayCare',
      name: 'dayCare',
      desc: 'DayCare',
    );
  }
  String get member {
    return Intl.message(
      'Member',
      name: 'member',
      desc: 'Member',
    );
  }
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: 'Email',
    );
  }
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: 'Create',
    );
  }
  String get pin {
    return Intl.message(
      'pin',
      name: 'pin',
      desc: 'Pin',
    );
  }
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: 'Home',
    );
  }
  String get arrive {
    return Intl.message(
      'Arrive',
      name: 'arrive',
      desc: 'Arrive',
    );
  }

  String get diaper {
    return Intl.message(
      'Diaper',
      name: 'diaper',
      desc: 'Diaper',
    );
  }
  String get play {
    return Intl.message(
      'Play',
      name: 'play',
      desc: 'Play',
    );
  }
  String get sleep {
    return Intl.message(
      'Sleep',
      name: 'sleep',
      desc: 'Sleep',
    );
  }
  String get care {
    return Intl.message(
      'Care',
      name: 'care',
      desc: 'Care',
    );
  }
  String get leave {
    return Intl.message(
      'Leave',
      name: 'leave',
      desc: 'Leave',
    );
  }
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: 'Add',
    );
  }
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: 'Photo',
    );
  }
  String get notify {
    return Intl.message(
      'Notify',
      name: 'notify',
      desc: 'notify',
    );
  }
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: 'Comment',
    );
  }
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: 'Share',
    );
  }
  String get milk {
    return Intl.message(
      'Milk',
      name: 'milk',
      desc: 'Milk',
    );
  }
  String get ml {
    return Intl.message(
      'ml',
      name: 'ml',
      desc: 'ml',
    );
  }
  String get beCareful {
    return Intl.message(
      'Be Careful',
      name: 'beCareful',
      desc: 'Be Careful',
    );
  }
  String get reading {
    return Intl.message(
      'Reading',
      name: 'reading',
      desc: 'Reading',
    );
  }
  String get painting {
    return Intl.message(
      'Painting',
      name: 'painting',
      desc: 'Painting',
    );
  }
  String get singing {
    return Intl.message(
      'Singing',
      name: 'singing',
      desc: 'Singing',
    );
  }
  String get jumping {
    return Intl.message(
      'Jumping',
      name: 'jumping',
      desc: 'Jumping',
    );
  }
  String get fever {
    return Intl.message(
      'Fever',
      name: 'fever',
      desc: 'Fever',
    );
  }
  String get earPain {
    return Intl.message(
      'Ear Pain',
      name: 'earPain',
      desc: 'Ear Pain',
    );
  }
  String get crying {
    return Intl.message(
      'Crying',
      name: 'crying',
      desc: 'Crying',
    );
  }
  String get runnyNose {
    return Intl.message(
      'Runny Nose',
      name: 'runnyNose',
      desc: 'Runny Nose',
    );
  }
  String get vomiting {
    return Intl.message(
      'Vomiting',
      name: 'vomiting',
      desc: 'Vomiting',
    );
  }  
  String get toothache {
    return Intl.message(
      'Toothache',
      name: 'toothache',
      desc: 'Toothache',
    );
  }
  String get eyeCleaning {
    return Intl.message(
      'Eye Cleaning',
      name: 'eyeCleaning',
      desc: 'Eye Cleaning',
    );
  }
  String get noseCleaning {
    return Intl.message(
      'Nose Cleaning',
      name: 'noseCleaning',
      desc: 'Nose Cleaning',
    );
  }
  String get moisturizer {
    return Intl.message(
      'Moisturizer',
      name: 'moisturizer',
      desc: 'Moisturizer',
    );
  }
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: 'Other',
    );
  }
  String get paracetamol {
    return Intl.message(
      'Paracetamol',
      name: 'paracetamol',
      desc: 'Paracetamol',
    );
  }
  String get earDrops {
    return Intl.message(
      'Ear Drops',
      name: 'earDrops',
      desc: 'Ear Drops',
    );
  }
  String get eyeDrops {
    return Intl.message(
      'Eye Drops',
      name: 'eyeDrops',
      desc: 'Eye Drops',
    );
  }
  String get children {
    return Intl.message(
      'Children',
      name: 'children',
      desc: 'Children',
    );
  }
  String get staff {
    return Intl.message(
      'Staff',
      name: 'staff',
      desc: 'Staff',
    );
  }
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: 'Login',
    );
  }
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: 'Account',
    );
  }
  String get event {
    return Intl.message(
      'Event',
      name: 'event',
      desc: 'Event',
    );
  }
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: 'Welcome',
    );
  }
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: 'Back',
    );
  }
  String get checkIn {
    return Intl.message(
      'Check-In',
      name: 'checkIn',
      desc: 'Check-In',
    );
  }
  String get please {
    return Intl.message(
      'Please',
      name: 'please',
      desc: 'Please',
    );
  }
  String get parent {
    return Intl.message(
      'Parent',
      name: 'parent',
      desc: 'Parent',
    );
  }
  String get nurse {
    return Intl.message(
      'Nurse',
      name: 'nurse',
      desc: 'Nurse',
    );
  }
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: 'Address',
    );
  }
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: 'Password',
    );
  }
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: 'Confirm',
    );
  }
  String get dOBError {
    return Intl.message(
      'Date of Birth must not be empty.',
      name: 'dOBError',
      desc: 'Date of Birth must not be empty.',
    );
  }
  String get lastNameError {
    return Intl.message(
      'Last name must not be empty.',
      name: 'lastNameError',
      desc: 'Last Name Error.',
    );
  }
  String get firstNameError {
    return Intl.message(
      'First name must not be empty.',
      name: 'firstNameError',
      desc: 'Confirm',
    );
  }
  String get imageFieldError {
    return Intl.message(
      'Image Field must not be empty',
      name: 'imageFieldError',
      desc: 'Image Field Must not be empty',
    );
  }
  String get childSuccessfullyAdded {
    return Intl.message(
      'Child Successfull added.',
      name: 'childSuccessfullyAdded',
      desc: 'Child Successfull added.',
    );
  }
  String get pinError {
    return Intl.message(
      'Pin Must Be of 6 Characters and Numeric.',
      name: 'pinError',
      desc: 'Pin Must Be of 6 Characters and Numeric.',
    );
  }
  String get emailError {
    return Intl.message(
      'Email must not be empty and should be proper.',
      name: 'emailError',
      desc: 'Email must not be empty and should be proper.',
    );
  }
  String get qualification {
    return Intl.message(
      'Qualification',
      name: 'qualification',
      desc: 'Qualification',
    );
  }
  String get someErrorOccured {
    return Intl.message(
      '"Some Error Occured Try Again.',
      name: 'someErrorOccured',
      desc: '"Some Error Occured Try Again.',
    );
  }
  String get memberEmailAlreadyExist {
    return Intl.message(
      'Member with this email Already Exist.',
      name: 'memberEmailAlreadyExist',
      desc: 'Member with this email Already Exist.',
    );
  }
  String get memberSuccessfullyCreated {
    return Intl.message(
      'Staff Member Successfully Created.',
      name: 'memberSuccessfullyCreated',
      desc: 'Staff Member Successfully Created.',
    );
  }
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: 'Change',
    );
  }
  String get vitamin {
    return Intl.message(
      'Vitamin',
      name: 'vitamin',
      desc: 'Vitamin',
    );
  }
  String get passwordNotMatch {
    return Intl.message(
      "Password Doesn't Match!",
      name: 'passwordNotMatch',
      desc: "Password Doesn\'t Match!",
    );
  }
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: 'Submit',
    );
  }
  String get am {
    return Intl.message(
      'AM',
      name: 'am',
      desc: 'Am',
    );
  }
  String get pm {
    return Intl.message(
      'PM',
      name: 'pm',
      desc: 'Pm',
    );
  }
  String get morning {
    return Intl.message(
      'Morning',
      name: 'morning',
      desc: 'Morning',
    );
  }
  String get evening {
    return Intl.message(
      'Evening',
      name: 'evening',
      desc: 'Evening',
    );
  }
  String get transmissions {
    return Intl.message(
      'Transmissions',
      name: 'transmissions',
      desc: 'Transmissions',
    );
  }
  String get child {
    return Intl.message(
      'Child',
      name: 'child',
      desc: 'Child',
    );
  }
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: 'Day',
    );
  }
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: 'week',
    );
  }
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: 'Profile',
    );
  }
  String get noData {
    return Intl.message(
      'No Data',
      name: 'noData',
      desc: 'No Data',
    );
  }
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: 'Log Out',
    );
  }
  String get pinAlreadyTaken {
    return Intl.message(
      "Pin Already Taken.",
      name: "pinAlreadyTaken",
      desc: "Pin Already Taken.",
    );
  }

  String get yourPasswordIsIncorrect {
    return Intl.message(
      "Your Password is Incorrect.",
      name: 'yourPasswordIsIncorrect',
      desc: 'Your Password is Incorrect.',
    );
  }

  String get pleaseSelectAChild {
    return Intl.message(
      "Please Select a Child.",
      name: 'pleaseSelectAChild',
      desc: 'Please Select a Child.',
    );
  }

  String get info {
    return Intl.message(
      "Info",
      name: 'info',
      desc: 'Info',
    );
  }

  String get dontHaveAnAccount {
    return Intl.message(
      "Don\'t have an Account?",
      name: "dontHaveAnAccount",
      desc: "Dont have an Account?"
    );
  }

  String get someErrorOccuredNow {
    return Intl.message(
      "Some Error Occured",
      name: 'someErrorOccuredNow',
      desc: 'Some Error Occured',
    );
  }

  String get a {
    return Intl.message(
      "a",
      name: 'a',
      desc: 'a',
    );
  }
  String get loginWithEmailAndPassword {
    return Intl.message(
      "Login with Email and Password.",
      name: 'loginWithEmailAndPassword',
      desc: 'Login with Email and Password.',
    );
  }
  String get yes {
    return Intl.message(
      "Yes",
      name: 'yes',
      desc: 'Yes',
    );
  }
  String get no {
    return Intl.message(
      "No",
      name: 'no',
      desc: 'no',
    );
  }
  String get charWith {
    return Intl.message(
      "with",
      name: 'charWith',
      desc: 'With',
    );
  }
  String get doYouReallyWantToExit {
    return Intl.message(
      "Do you really want to exit.",
      name: 'doYouReallyWantToExit',
      desc: 'Do you really want to exit.',
    );
  }
  String get or {
    return Intl.message(
      "or",
      name: 'or',
      desc: 'or',
    );
  }

  String get emailAlreadyExist {
    return Intl.message(
      "Email Already Exist",
      name: 'emailAlreadyExist',
      desc: 'Email Already Exist.',
    );
  }
  String get exist {
    return Intl.message(
      "Exist",
      name: 'exist',
      desc: 'Exist',
    );
  }
  String get already {
    return Intl.message(
      "Already",
      name: 'already',
      desc: 'Already',
    );
  }
  String get taken {
    return Intl.message(
      "Taken",
      name: 'taken',
      desc: 'Taken',
    );
  }
  String get required {
    return Intl.message(
      "Required",
      name: 'required',
      desc: 'Required',
    );
  }
  String get pinDoesntMatch {
    return Intl.message(
      "Pin Doesn\'t Match",
      name: 'pinDoesntMatch',
      desc: 'pin Does not match',
    );
  }
  

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en','fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) {
    return false;
  }
}