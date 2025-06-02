// ↓ Bu buildscript bloğunu, dosyanın en başına koy:
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Bu satır zaten varsa Android Gradle Plugin sürümüne göre kullan
        classpath("com.android.tools.build:gradle:7.0.4")
        // ↓ Bu satırı ekle:
        classpath("com.google.gms:google-services:4.3.15")
    }
}

// ——————————————————————————————————————————————————————————

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
