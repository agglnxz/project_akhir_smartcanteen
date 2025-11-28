// Bagian yang wajib ada untuk mendefinisikan dependency Gradle itu sendiri (seperti plugin Firebase)
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Ganti dengan versi Gradle Plugin yang sesuai jika Anda menggunakan versi yang berbeda,
        // tetapi versi 8.1.4 ini umum untuk Flutter modern.
        classpath("com.android.tools.build:gradle:8.1.4")
        
        // WAJIB ADA: Plugin Google Services untuk Firebase
        // Gunakan versi terbaru yang stabil (4.4.1 atau lebih baru)
        classpath("com.google.gms:google-services:4.4.2") 
        
        // Anda mungkin perlu menambahkan plugin kotlin di sini juga, tergantung setup Flutter Anda:
        // classpath(kotlin("gradle-plugin", version = "1.8.20")) 
    }
}

// Konfigurasi repository yang sudah ada
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Konfigurasi build dir yang sudah ada (untuk menempatkan build di luar folder android)
val newBuildDir =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: org.gradle.api.file.Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}