# Secretum - Lightweight, Open Source, Encrypted passwords store.

### DEMO
[View on YouTube](https://youtu.be/HfjjZviBcg4).

### Download
Download from PlayStore (TBD).
Download from AppStore (TBD).

# Table of Contents
1. [Motivation](#motivation)
2. [Limitations](#limitations)
3. [Security](#security)
4. [Guidance](#guidance)
    1. [Topics](#topics)
5. [Connect to your own Firestore](#connect-to-your-own-firestore)
6. [Outro](#outro)
7. [Donations](#donations)

## Motivation

I've combined [years of experience in Tech. land and Flutter](https://deimantas.dev) and decided to give back to the community.

At first `Secretum` started as a personal project, but with time, I've decided I want to do more. This application, `Secretum`, is created with the purpose to share with the community how scalable apps (in Flutter) can be written. It also tackled one of the most talked topic in Flutter - [State Management](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options). Code itself covers many more topics (read below - [Topics](#topics)).

## Limitations
Unfortunately I don't have iOS/Android device with Face Recognition therefore I was not able to test authentication flow with it. It might give some unexpected behaviour. Fingers crossed it does't!

## Security
Passwords are hashed using `SHA512`. All your other data is encrypted using `AES`.
Decryption `key` is stored locally using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage).

It might not be the perfect approach since last time I've dealt encryption related topics was years ago but I'm more than happy to have a chat with security domain experts on how this layer could be improved. As security in this time of the year getting more and more important. 

## Guidance
Currently I don't have much time on my plate, but I'll try to submit new videos, covering each topic within the app, so it can be much clearer of how everything works together.

### Topics:
- Overall package structure
-- TODO
- Model Serialization and Encryption
-- TODO
- Flutter and Firestore
-- TODO
- Logging
-- TODO
- State Management (Provider)
-- TODO
- Difference between Singletons (services) and Providers (stores)
-- TODO
- UI and Logic decoupling pattern (MVP)
-- TODO
- Encryption
-- TODO
- TODO
-- TODO

If you would like to have any topic covered of your choice, feel free to create an `issue` for that.

## Connect to your own Firestore
`Secretum` has Firestore configuration files ignored. If you would like to clone the project and run it on your own Firestore, you can make it easily by: 
1. Clone the project
2. Create a new Firebase Project
3. Create Android and iOS apps. Within package/bundle id specify `com.secretum`
4. Download `google-services.json` (Android) and put it to `../secretum/android/app` directory
5. Follow the guide of how to correctly reference `GoogleServices-Info.plist` for iOS (very important, drag-n-drop instead of copy-paste)
6. Go to your Firebase project and enable Firestore
7. Set up Firestore rules up your preference
8. Delete existing `Secretum` app and build app from source
9. Check logs after registration - make sure to create right index (URLs are provided in console from Firestore)

After you've set-up Firebase and linked its configuration - now you should be able to run the build locally. After you will create your user, all data will be linked to your Firestore.

## Outro
Hopefully `Secretum` can be an inspiration for anyone, who would like to start using [Flutter](https://flutter.dev) and they are not sure how apps can be written in scalable manner.
For more experienced Flutter'ists - hopefully you can find something new as well.

`Secretum`'s show-case is my own Point of View and my own years of experience combined into one project. Patterns were constantly polished and I it constantly improving. This way is my preffered way of building Flutter apllication and it is not the only way of how scalable Flutter app can be written. 

## Personal Recommendations
If you're new to Flutter, I'm happy to share some of my favourite resources to start with:
1. Getting started - [Courses with Andrea](https://codewithandrea.com/)
2. State Management - [Provider](https://pub.dev/packages/provider) or [BloC](https://pub.dev/packages/flutter_bloc)
3. Helpful Flutter Videos from - [Tadas Petra](https://www.youtube.com/c/TadasPetra/videos), [Robert Brunhage](https://www.youtube.com/c/RobertBrunhage/videos), [Fireship](https://www.youtube.com/c/AngularFirebase/videos)
4. More Advance Flutter Design Patterns with [Mangirdas Kazlauskas](https://mkobuolys.medium.com/)
5. Be sure to follow [Tim Sneath](https://twitter.com/timsneath) and [Chris Sells](https://medium.com/@csells_18027)

## Donations
If you find this show-case helpful, donations are welcome!
- Bitcoin
-- `bc1q6ze04kw5s6dvptk22m9l0yjk43uewykfeks0tj`
- Nano
-- `nano_3pozzop44i7kyz4afg7teno41w4sm8q1genyu9rwdxmidfszpzjxitxq4js7`
- Monero
-- `44yBuwJXmTmc1fEDaxSKTwVz9As3FkzyHZDqmwCXSnNSWi9tUyieeyt2mgnpzusHFRRKcp7p31jAh9CN1G6dZb3F2MT2j3J`

