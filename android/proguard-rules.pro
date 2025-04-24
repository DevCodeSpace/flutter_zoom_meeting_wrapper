-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**
-keep class io.grpc.** { *; }
-dontwarn io.grpc.**
# Keep Google Tink classes
-keep class com.google.crypto.tink.** { *; }
-keepclassmembers class com.google.crypto.tink.** { *; }

# Zoom SDK ProGuard rules
-keep class com.blueparrott.** { *; }
-keep class com.davemorrissey.** { *; }
-keep class com.microsoft.intune.** { *; }
-keep class com.symbol.emdk.** { *; }
-keep class io.reactivex.rxjava3.** { *; }
-keep class javax.lang.model.** { *; }
-keep class us.zoom.intunelib.** { *; }
-keep class us.zoom.thirdparty.** { *; }

# Dontwarn for missing classes
-dontwarn com.blueparrott.**
-dontwarn com.davemorrissey.**
-dontwarn com.microsoft.intune.**
-dontwarn com.symbol.emdk.**
-dontwarn io.reactivex.rxjava3.**
-dontwarn javax.lang.model.**
-dontwarn us.zoom.intunelib.**
-dontwarn us.zoom.thirdparty.**