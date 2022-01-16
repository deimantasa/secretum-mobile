# Secretum - Lightweight, Open Source, Encrypted passwords store.

### DEMO
[Full walkthrough with comments - view on YouTube](https://youtu.be/HfjjZviBcg4) (slightly outdated but core principles are there).

#### Hacking purposes only

**[Firestore database](https://firestore.googleapis.com/v1/projects/secretum-test/databases/(default)/documents/users)**. If you're able to crack it open and decode encrypted secrets - please share so that we can fix any vulnerability.

**Apps**  
Download from [PlayStore](https://play.google.com/store/apps/details?id=com.secretum) (Android).  
Download from [AppStore](https://apps.apple.com/us/app/apple-store/id1558404007) (iOS).


**Features**:

- Register. Sign up with only `primary password`. It will be used for very sensitive operations, as secret deletion, backups, etc.
<img src="https://user-images.githubusercontent.com/12739071/148643788-ee0f6957-fbdc-44a6-909f-c2d72ead73ec.gif" width="250"/>

- Add new secret. Black screen is biometrics pages.authentication - it's not shown in the recording on purpose.
<img src="https://user-images.githubusercontent.com/12739071/148643655-50b42f43-a10f-4188-88ba-acdba868503c.gif" width="250"/>

- Preview Secret's data.
<img src="https://user-images.githubusercontent.com/12739071/148643773-071f24b5-c736-45b1-9089-aac2d68a9e67.gif" width="250"/>

- Update Secret's Name, Note or Code.
<img src="https://user-images.githubusercontent.com/12739071/148643924-eeca7e58-1fff-40f0-9f48-877b052b659b.gif" width="250"/>

- Delete secret.
<img src="https://user-images.githubusercontent.com/12739071/148643713-c7747f90-fc1a-4c11-9422-0bd9551d2288.gif" width="250"/>

- Backup all your secrets from DB to locally encrypted file
<img src="https://user-images.githubusercontent.com/12739071/148643647-9b860f86-fd75-46dc-b3b1-aa135d4f9f39.gif" width="250"/>

- Auto backup all your secrets from DB to locally encrypted file on app start. It's extra safety layer to protect user in case someone obtained data in the Firestore and they've somehow messed it up. User will always be able to access their `backups` locally. Black screen is biometrics pages.authentication - it's not shown in the recording on purpose.
<img src="https://user-images.githubusercontent.com/12739071/148643705-c6b470d2-22a1-4447-8c91-b6cfd2dd142b.gif" width="250"/>

- Delete backups. Everything will be deleted from the local storage.
<img src="https://user-images.githubusercontent.com/12739071/148643709-7ddbc630-4f57-46bb-aadc-940a4ce52871.gif" width="250"/>

- Login via key (recover account). Recover your account by using generated key during registration process.
<img src="https://user-images.githubusercontent.com/12739071/148643754-509d4529-8689-4920-a513-a3708a3a5c08.gif" width="250"/>

- Data in Firestore. Everything is encrypted or hashed.
<img src="https://user-images.githubusercontent.com/12739071/148643734-deb4f8f0-e617-45dd-89c5-fc480bc8672f.gif" width="800"/>

# Table of Contents
1. [Motivation](#motivation)
2. [How it works](#how-it-works)
3. [Limitations](#limitations)
4. [Connect to your own Firebase project](#connect-to-your-own-firebase-project)
5. [Outro](#outro)

## Motivation

I've combined [years of experience in Tech. land and Flutter](https://deimantas.dev) and decided to give back to the community.

At first `Secretum` started as a personal project, but with time, I've decided I want to do more.  

Since increasing popularity of blockchain and cryptocurrencies, people tend to have very hard time securing their private keys. And these keys easily can get lost, if stored offline (although offline storage is the most secure). `Secretum` makes it easier to store private keys online with full leverage of `hashing` and `encryption` technologies.


## How it works
User creates their own [Firebase](https://firebase.google.com/) project thus allowing only them to access the project. Since it's their own project, their individual `firestore` database reduce chances for it to get compromised.

1. User creates an account with entering only `password`. This `password` is used for sensitive information, such as `secret.code` update, backup generation, etc.
2. [Random key is generated](https://github.com/deimantasa/secretum-mobile/blob/master/lib/services/encryption_service.dart#L10-L15) and provided to the user. This key is [stored locally](https://github.com/deimantasa/secretum-mobile/blob/master/lib/services/storage_service.dart#L37-L42) using [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) and it used for encrypting/decrypting data. Furthermore, this key is the only way to recover the account if one deletes the app or logs out.
3. User's `password` and `key` are [hashed](https://github.com/deimantasa/secretum-mobile/blob/master/lib/services/encryption_service.dart#L44-L49) with `SHA256` and data is stored in the `firestore`.
4. User enters the app and can create their `secrets`. Before sending `secret` to `firestore`, data is [encrypted](https://github.com/deimantasa/secretum-mobile/blob/master/lib/services/encryption_service.dart#L27-L34) using `key` and only then it's sent to `firestore`.
5. In order to read encrypted data from `firestore`, all data is being [decrypted](https://github.com/deimantasa/secretum-mobile/blob/master/lib/models/secret.dart#L55-L63), so that in the app it would be readable.

This way ensures that all the data is either `encrypted` or `hashed` and even with knowing raw data from `firestore`, there is no way, without knowing the key, decrypt anything.

Additional functionality includes backups:
1. On app start, `all user's secrets` are [stored in the local text file within phone device](https://github.com/deimantasa/secretum-mobile/blob/master/lib/services/storage_service.dart#L44-L52). That file data is encrypted (same as in `firestore`).
   - User can access each backup via app
   - User at any moment can wipe all locally stores backups  
   - This backup mechanism ensures that in case of data is being compromised, user can still always access their latest non-compromised data-set
2. User can backup their `secrets` on demand  


And the best part - if you want to recoved your account - all you need is to:
1. Enter your `key`
2. If `hashed key` is found in the firestore, you will be recovered with that account's data

## Limitations
Unfortunately I don't have iOS/Android device with Face Recognition therefore I was not able to test pages.authentication flow with it. It might give some unexpected behaviour.  
Furthermore, if device does not have any biometrics/pattern lock - it might misbehave.

## Connect to your own Firebase project
`Secretum` has Firestore configuration files ignored. If you would like to clone the project and run it on your own Firestore, you can make it easily by: 
1. Clone the project
2. Create a new Firebase Project. You can specify very random name (for instance using [some generator](https://passwordsgenerator.net/). It will greately reduce chance by someone guessing your project and trying to exploit it
3. Create Android and iOS apps. Within package/bundle id specify `com.secretum`
4. Download `google-services.json` (Android) rename it to `google-services-prod.json` and put it to `../secretum/tools/environment-generator/` directory
5. Follow the guide of how to correctly reference `GoogleServices-Info.plist` for iOS (very important, drag-n-drop instead of copy-paste)
6. Download second copy of `GoogleServices-Info.plist`, rename it to `GoogleServices-Info-prod.plist` and put it to `../secretum/tools/environment-generator/` directory
7. Go to `../secretum/tools/environment-generator/` and run `node environment-generator prod`. Firebase configs (`prod`) will be copied into right places with additional parameters. You can also build `dev` if you'd like to have second, independent Firebase project to work on (perfect for development)
8. Go to your Firebase project and enable `anonymous pages.authentication` within `Authentication`
9. Go to your Firebase project and enable `Firestore Database`
10. Set up Firestore rules up your preference
11. Delete existing `Secretum` app and build app from source
12. Check logs after registration - make sure to create right indexes (URLs are provided in console from Firestore)

After you've set-up Firebase and linked its configuration - now you should be able to run the build locally. After you will create your user, all data will be linked to your Firestore.

## Outro
My hope is that some of you might find this project useful. If you do - feel free to share your appreciation via donations:  

- Bitcoin  
`bc1q6ze04kw5s6dvptk22m9l0yjk43uewykfeks0tj`
- Nano  
`nano_3pozzop44i7kyz4afg7teno41w4sm8q1genyu9rwdxmidfszpzjxitxq4js7`
- Monero  
`44yBuwJXmTmc1fEDaxSKTwVz9As3FkzyHZDqmwCXSnNSWi9tUyieeyt2mgnpzusHFRRKcp7p31jAh9CN1G6dZb3F2MT2j3J`

