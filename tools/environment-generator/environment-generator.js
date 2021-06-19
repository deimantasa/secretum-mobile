"use strict";
exports.__esModule = true;
var fs = require("fs");
var path = require("path");
//DON'T MODIFY THOSE FILENAMES
var firebaseEnvAndroidFile = 'google-services';
var firebaseEnvIOSFile = 'GoogleService-Info';
var envAndroidFile = 'env.properties';
var envIOSFile = 'env.xcconfig';
//Modify values is they need to change
var envProd = { appName: "Secretum", appSuffix: "" };
var envDev = { appName: "DEV Secretum", appSuffix: ".dev" };
//DON'T MODIFY THIS INTERFACE
var envGeneral = { "prod": envProd, "dev": envDev };
//Helper function to get right fileName for iOS file
function getIOSEnvFile(env) {
    if (env === 'main') {
        return firebaseEnvIOSFile + ".plist";
    }
    else {
        return firebaseEnvIOSFile + "-" + env + ".plist";
    }
}
//Helper function to get right fileName for Android file
function getAndroidEnvFile(env) {
    if (env === 'main') {
        return firebaseEnvAndroidFile + ".json";
    }
    else {
        return firebaseEnvAndroidFile + "-" + env + ".json";
    }
}
function generateRightFirebaseEnvironmentFile(environment) {
    //Defining paths. Given `firebase-environment.ts` is stored in `../projectName/tools/firebase-environment`
    var androidPath = path.join(__dirname, '..', '..', 'android', 'app');
    var iosPath = path.join(__dirname, '..', '..', 'ios', 'Runner');
    var androidEnvFile = getAndroidEnvFile(environment);
    var androidMainFile = getAndroidEnvFile('main');
    fs.copyFile("" + androidEnvFile, androidPath + "/" + androidMainFile, function (e) {
        if (e === null) {
            console.log(androidEnvFile + " file copied successfully.");
        }
        else {
            console.log("Error while copying " + androidEnvFile + " file: " + e);
        }
    });
    var IOSEnvFile = getIOSEnvFile(environment);
    var IOSMainFile = getIOSEnvFile('main');
    fs.copyFile("" + IOSEnvFile, iosPath + "/" + IOSMainFile, function (e) {
        if (e === null) {
            console.log(IOSEnvFile + " file copied successfully.");
        }
        else {
            console.log("Error while copying " + IOSEnvFile + " file: " + e);
        }
    });
}
function generateRightEnvironmentFiles(environment) {
    //Defining paths. Given `environment-generator.ts` is stored in `../projectName/tools/environment-generator`
    var androidPath = path.join(__dirname, '..', '..', 'android');
    var iosPath = path.join(__dirname, '..', '..', 'ios', 'Flutter');
    var envFileContent = getEnvFileFromObject(envGeneral[environment]);
    console.log("Generating OS env files. Content:");
    console.log("" + envFileContent);
    console.log("*********************************************");
    fs.writeFile(androidPath + "/" + envAndroidFile, "" + envFileContent, function (e) {
        if (e === null) {
            console.log(envAndroidFile + " file generated for " + environment + " environment.");
        }
        else {
            console.log("Error while generating file " + envAndroidFile);
        }
    });
    fs.writeFile(iosPath + "/" + envIOSFile, "" + envFileContent, function (e) {
        if (e === null) {
            console.log(envIOSFile + " file generated for " + environment + " environment.");
        }
        else {
            console.log("Error while generating file " + envIOSFile);
        }
    });
}
//Once file is running, it will execute [copyRightEnvironmentFile] function with given arguments
function generateEnvironmentFiles(environment) {
    //If environment match, execute copying script
    if (environment === 'prod' || environment === 'dev') {
        console.log("*********************************************");
        console.log("Generating environment files and configs. Environment: " + environment);
        generateRightFirebaseEnvironmentFile(environment);
        generateRightEnvironmentFiles(environment);
    }
}
//Example `node firebase-environment.js prod`
process.argv.forEach(function (val) {
    generateEnvironmentFiles(val);
});
//Parse JSON to aligned file content for both Android and iOS
function getEnvFileFromObject(envFile) {
    return "appName=" + envFile.appName + "\nappSuffix=" + envFile.appSuffix;
}
