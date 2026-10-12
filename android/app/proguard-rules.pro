-keep class tech.appxiom.android.core.* { *; }

-keepclassmembers class * {
    @tech.appxiom.android.core.annotation.AX *;
}

-keepclassmembers class androidx.lifecycle.** {
    *;
}
