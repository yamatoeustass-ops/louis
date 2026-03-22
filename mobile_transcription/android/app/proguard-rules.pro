# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/Cellar/android-sdk/24.3.3/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Huawei HMS Core
-keep class com.huawei.hms.** { *; }
-keep class com.huawei.agconnect.** { *; }
-keep class com.huawei.android.hms.** { *; }

# Whisper.cpp native bindings
-keep class com.viralcaption.viral_caption.whisper.** { *; }
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# FFmpeg Kit
-keep class com.arthenica.ffmpegkit.** { *; }
-dontwarn com.arthenica.ffmpegkit.**

# Video Player
-keep class com.google.android.exoplayer2.** { *; }

# General
-keepattributes *Annotation*
-keepattributes SourceFile
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# Prevent obfuscation of model classes
-keep class com.viralcaption.viral_caption.models.** { *; }
-keepclassmembers class com.viralcaption.viral_caption.models.** { *; }
