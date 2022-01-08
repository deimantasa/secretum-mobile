# Secretum - Lightweight, Open Source, Encrypted passwords store.

### DEMO
[Full walkthrough with comments - view on YouTube](https://youtu.be/HfjjZviBcg4) (slightly outdated but core principles are there).

**Features**:

- Register. Sign up with only `primary password`. It will be used for very sensitive operations, as secret deletion, backups, etc.
<img src="https://user-images.githubusercontent.com/12739071/148643788-ee0f6957-fbdc-44a6-909f-c2d72ead73ec.gif" width="250"/>

- Add new secret. Black screen is biometrics authentication - it's not shown in the recording on purpose.
<img src="https://user-images.githubusercontent.com/12739071/148643655-50b42f43-a10f-4188-88ba-acdba868503c.gif" width="250"/>

- Preview Secret's data.
<img src="https://user-images.githubusercontent.com/12739071/148643773-071f24b5-c736-45b1-9089-aac2d68a9e67.gif" width="250"/>

- Update Secret's Name, Note or Code.
<img src="https://user-images.githubusercontent.com/12739071/148643924-eeca7e58-1fff-40f0-9f48-877b052b659b.gif" width="250"/>

- Delete secret.
<img src="https://user-images.githubusercontent.com/12739071/148643713-c7747f90-fc1a-4c11-9422-0bd9551d2288.gif" width="250"/>

- Backup all your secrets from DB to locally encrypted file
<img src="https://user-images.githubusercontent.com/12739071/148643647-9b860f86-fd75-46dc-b3b1-aa135d4f9f39.gif" width="250"/>

- Auto backup all your secrets from DB to locally encrypted file on app start. It's extra safety layer to protect user in case someone obtained data in the Firestore and they've somehow messed it up. User will always be able to access their `backups` locally. Black screen is biometrics authentication - it's not shown in the recording on purpose.
<img src="https://user-images.githubusercontent.com/12739071/148643705-c6b470d2-22a1-4447-8c91-b6cfd2dd142b.gif" width="250"/>

- Delete backups. Everything will be deleted from the local storage.
<img src="https://user-images.githubusercontent.com/12739071/148643709-7ddbc630-4f57-46bb-aadc-940a4ce52871.gif" width="250"/>

- Login via key (recover account). Recover your account by using generated key during registration process.
<img src="https://user-images.githubusercontent.com/12739071/148643754-509d4529-8689-4920-a513-a3708a3a5c08.gif" width="250"/>

- Data in Firestore. Everything is encrypted or hashed.
<img src="https://user-images.githubusercontent.com/12739071/148643734-deb4f8f0-e617-45dd-89c5-fc480bc8672f.gif" width="800"/>

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
Unfortunately I don't have iOS/Android device with Face Recognition therefore I was not able to test authentication flow with it. It might give some unexpected behaviour. Fingers crossed it does not!

## Security
`Secret Key` and a `Password` are hashed using `SHA512`. All other data is encrypted using `AES`.  
Decryption key (`Secret Key`) is stored locally using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) and it used for encrypting/descrypting data.

Backups are created on demand and they are also automatically created on app start and stored locally. All content of the file are encrypted/hashed (same as data in Firestore).  

Once user logs out - local storage is fully wiped out, not leaving any backed up files.  

Account recovery only possible by knowing `secret key` which was generated and given within account creation process.


## Guidance
Currently I don't have much time on my plate, but I'll try to submit new videos, covering each topic within the app, so it can be much clearer of how everything works together.

### Topics:
- Overall package structure
-- https://www.loom.com/share/fa563fafb09147f9b231597b46866d89
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
- Unit Tests
-- TODO
- Integration Tests
-- TODO
- TODO
-- TODO

If you would like to have any topic covered of your choice, feel free to create an `issue` for that.

## Connect to your own Firestore
`Secretum` has Firestore configuration files ignored. If you would like to clone the project and run it on your own Firestore, you can make it easily by: 
1. Clone the project
2. Create a new Firebase Project. You can specify very random name (for instance using [some generator](https://passwordsgenerator.net/). It will greately reduce chance by someone guessing your project and trying to exploit it
3. Create Android and iOS apps. Within package/bundle id specify `com.secretum`
4. Download `google-services.json` (Android) rename it to `google-services-prod.json` and put it to `../secretum/tools/environment-generator/` directory
5. Follow the guide of how to correctly reference `GoogleServices-Info.plist` for iOS (very important, drag-n-drop instead of copy-paste)
6. Download second copy of `GoogleServices-Info.plist`, rename it to `GoogleServices-Info-prod.plist` and put it to `../secretum/tools/environment-generator/` directory
7. Go to `../secretum/tools/environment-generator/` and run `node environment-generator prod`. Firebase configs (prod) will be copied into right places with additional parameters  
if you'd like to have `dev` build too
8. Go to your Firebase project and enable `anonymous authentication` within `Authentication`
9. Go to your Firebase project and enable `Firestore Database`
10. Set up Firestore rules up your preference
11. Delete existing `Secretum` app and build app from source
12. Check logs after registration - make sure to create right indexes (URLs are provided in console from Firestore)

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

