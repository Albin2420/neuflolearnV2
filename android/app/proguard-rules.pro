#####################################
# Flutter Specific Rules
#####################################
-keep class io.flutter.** { *; }
-keep class androidx.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.view.FlutterNativeView { *; }
-keep class io.flutter.app.FlutterApplication { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.Log { *; }

#####################################
# VLC Player (flutter_vlc_player)
#####################################
-keep class org.videolan.libvlc.** { *; }
-keep class org.videolan.libvlc.util.** { *; }
-keep class android.content.** { *; }
-keep class android.net.Uri { *; }
-keep class android.media.** { *; }
-keep class android.os.** { *; }
-keep class android.view.** { *; }
-keep class android.widget.** { *; }
-keep class android.graphics.** { *; }
-keep class android.util.** { *; }
-keep class android.app.Activity { *; }
-keepclassmembers class * {
    native <methods>;
}
-keep class io.flutter.plugins.vlcplayer.** { *; }

#####################################
# YouTube Explode (youtube_explode_dart)
#####################################
-keep class com.github.suplaudible.youtubeexploded.** { *; }
-keep class youtube_explode_dart.** { *; }
-keep class io.jsonwebtoken.** { *; }

# Keep Gson (if using JSON serialization)
-keep class com.google.gson.** { *; }
-keep class * extends com.google.gson.TypeAdapter { *; }
-keep class * {
    @com.google.gson.annotations.SerializedName *;
}

# Retrofit (if used)
-keep class retrofit2.** { *; }
-keep class okhttp3.** { *; }

#####################################
# Logging and Debugging
#####################################
-keep class java.util.logging.** { *; }
-keep class android.util.Log { *; }

# Prevent obfuscation of models or data classes
-keep class com.neuflo.neuflolearnv1.models.** { *; }

#####################################
# Additional Optimizations
#####################################
# Protect custom exceptions
-keep class * extends java.lang.Exception

# Prevent stripping of classes using reflection
-keepattributes Signature
-keepattributes *Annotation*

# Preserve enum values
-keepclassmembers enum * { 
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
