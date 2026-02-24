import java.util.Properties
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keyPropertiesFile = rootProject.file("key.properties")
   val keyProperties = Properties()
   if (keyPropertiesFile.exists()) {
    keyProperties.load(keyPropertiesFile.inputStream())
}

android {
    namespace = "com.iwasthere.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.iwasthere.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 31  // Android 12+ per PRD
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    if (keyPropertiesFile.exists()) {
        signingConfigs {
            create("release") {
                storeFile = rootProject.file(keyProperties["storeFile"] as String?)
                storePassword = keyProperties["storePassword"] as String?
                keyAlias = keyProperties["keyAlias"] as String?
                keyPassword = keyProperties["keyPassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keyPropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
