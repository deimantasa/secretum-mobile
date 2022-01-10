import * as fs from 'fs';
import * as path from 'path';
import {EnvFile} from './env-file';

// DON'T MODIFY THOSE FILENAMES
const firebaseEnvAndroidFile = 'google-services';
const firebaseEnvIOSFile = 'GoogleService-Info';
const envAndroidFile = 'env.properties';
const envIOSFile = 'env.xcconfig';

// Only handling two environments
type Environment = 'prod' | 'dev';

// Modify values is they need to change
const envProd: EnvFile = {appName: "Secretum", appSuffix: ""};
const envDev: EnvFile = {appName: "DEV Secretum", appSuffix: ".dev"};

// DON'T MODIFY THIS INTERFACE
const envGeneral = {"prod": envProd, "dev": envDev};

// Helper function to get right fileName for iOS file
function getIOSEnvFile(env: Environment | 'main') {
    if (env === 'main') {
        return `${firebaseEnvIOSFile}.plist`;
    } else {
        return `${firebaseEnvIOSFile}-${env}.plist`;
    }
}

// Helper function to get right fileName for Android file
function getAndroidEnvFile(env: Environment | 'main') {
    if (env === 'main') {
        return `${firebaseEnvAndroidFile}.json`;
    } else {
        return `${firebaseEnvAndroidFile}-${env}.json`;
    }
}

function generateRightFirebaseEnvironmentFile(environment: Environment) {
    // Defining paths. Given `firebase-environment.ts` is stored in `../projectName/tools/firebase-environment`
    const androidPath = path.join(__dirname, '..', '..', 'android', 'app');
    const iosPath = path.join(__dirname, '..', '..', 'ios', 'Runner');

    const androidEnvFile = getAndroidEnvFile(environment);
    const androidMainFile = getAndroidEnvFile('main');

    fs.copyFile(`${androidEnvFile}`, `${androidPath}/${androidMainFile}`, (e) => {
        if (e === null) {
            console.log(`${androidEnvFile} file copied successfully.`);
        } else {
            console.log(`Error while copying ${androidEnvFile} file: ${e}`);
        }

    });

    const IOSEnvFile = getIOSEnvFile(environment);
    const IOSMainFile = getIOSEnvFile('main');

    fs.copyFile(`${IOSEnvFile}`, `${iosPath}/${IOSMainFile}`, (e) => {
        if (e === null) {
            console.log(`${IOSEnvFile} file copied successfully.`);
        } else {
            console.log(`Error while copying ${IOSEnvFile} file: ${e}`);
        }
    });
}

function generateRightEnvironmentFiles(environment: Environment) {
    // Defining paths. Given `environment-generator.ts` is stored in `../projectName/tools/environment-generator`
    const androidPath = path.join(__dirname, '..', '..', 'android');
    const iosPath = path.join(__dirname, '..', '..', 'ios', 'Flutter');

    const envFileContent = getEnvFileFromObject(envGeneral[environment]);
    console.log(`Generating OS env files. Content:`);
    console.log(`${envFileContent}`);
    console.log(`*********************************************`);

    fs.writeFile(`${androidPath}/${envAndroidFile}`, `${envFileContent}`, (e) => {
        if (e === null) {
            console.log(`${envAndroidFile} file generated for ${environment} environment.`);
        } else {
            console.log(`Error while generating file ${envAndroidFile}`);
        }
    });

    fs.writeFile(`${iosPath}/${envIOSFile}`, `${envFileContent}`, (e) => {
        if (e === null) {
            console.log(`${envIOSFile} file generated for ${environment} environment.`);
        } else {
            console.log(`Error while generating file ${envIOSFile}`);
        }
    });
}

// Once file is running, it will execute [copyRightEnvironmentFile] function with given arguments
function generateEnvironmentFiles(environment: string) {
    // If environment match, execute copying script
    if (environment === 'prod' || environment === 'dev') {
        console.log(`*********************************************`);
        console.log(`Generating environment files and configs. Environment: ${environment}`);
        generateRightFirebaseEnvironmentFile(environment);
        generateRightEnvironmentFiles(environment);
    }
}

// Example `node environment-generator prod`
process.argv.forEach(function (val) {
    generateEnvironmentFiles(val);
});

// Parse JSON to aligned file content for both Android and iOS
function getEnvFileFromObject(envFile: EnvFile) {
    return `appName=${envFile.appName}\nappSuffix=${envFile.appSuffix}`;
}
