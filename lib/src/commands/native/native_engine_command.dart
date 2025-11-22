import 'dart:io';

void createNativeEngine() {
  final path = 'native_engine';

  print('🚀 Creating Native Engine Module...');

  // ROOT
  Directory(path).createSync(recursive: true);

  // COMMON
  Directory('$path/src/commonMain/kotlin/native/engine')
      .createSync(recursive: true);
  Directory('$path/src/commonMain/resources')
      .createSync(recursive: true);

  // ANDROID
  Directory('$path/src/androidMain/kotlin/native/engine')
      .createSync(recursive: true);

  // IOS
  Directory('$path/src/iosMain/kotlin/native/engine')
      .createSync(recursive: true);

  // ───────────────────────────────────────────────
  // WRITE FILES
  // ───────────────────────────────────────────────

  // Gradle
  File('$path/build.gradle.kts')
      .writeAsStringSync(_gradleTemplate());

  // Common Sources
  File('$path/src/commonMain/kotlin/native/engine/ApiService.kt')
      .writeAsStringSync(_apiServiceTemplate());

  File('$path/src/commonMain/kotlin/native/engine/NativeRepository.kt')
      .writeAsStringSync(_repositoryTemplate());

  File('$path/src/commonMain/kotlin/native/engine/NativeModel.kt')
      .writeAsStringSync(_modelTemplate());

  // Android Placeholder
  File('$path/src/androidMain/kotlin/native/engine/AndroidPlaceholder.kt')
      .writeAsStringSync(_androidPlaceholder());

  // iOS Placeholder
  File('$path/src/iosMain/kotlin/native/engine/IOSPlaceholder.kt')
      .writeAsStringSync(_iosPlaceholder());

  print('✅ Native Engine created successfully! 🚀');
}

// ───────────────────────────────────────────────
// GRADLE TEMPLATE
// ───────────────────────────────────────────────

String _gradleTemplate() => '''
plugins {
    kotlin("multiplatform")
    id("com.android.library")
}

kotlin {
    androidTarget()
    iosX64()
    iosArm64()
    iosSimulatorArm64()

    sourceSets {
        commonMain.dependencies {
            implementation("io.ktor:ktor-client-core:2.3.3")
        }
        androidMain.dependencies {
            implementation("io.ktor:ktor-client-okhttp:2.3.3")
        }
        iosMain.dependencies {
            implementation("io.ktor:ktor-client-darwin:2.3.3")
        }
    }
}

android {
    namespace = "native.engine"
    compileSdk = 34
}
''';

// ───────────────────────────────────────────────
// COMMON FILES
// ───────────────────────────────────────────────

String _apiServiceTemplate() => '''
package native.engine

import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.client.statement.*

class ApiService {
    private val client = HttpClient()

    suspend fun getFreeApi(): String {
        val response: HttpResponse = client.get("https://jsonplaceholder.typicode.com/todos/1")
        return response.bodyAsText()
    }
}
''';

String _repositoryTemplate() => '''
package native.engine

class NativeRepository(
    private val api: ApiService = ApiService()
) {
    suspend fun getExample() = api.getFreeApi()
}
''';

String _modelTemplate() => '''
package native.engine

data class NativeModel(
    val id: Int,
    val title: String
)
''';

// ───────────────────────────────────────────────
// PLATFORM PLACEHOLDERS
// ───────────────────────────────────────────────

String _androidPlaceholder() => '''
package native.engine

class AndroidPlaceholder {
    fun info(): String = "Android Native Engine Loaded (Placeholder)"
}
''';

String _iosPlaceholder() => '''
package native.engine

class IOSPlaceholder {
    fun info(): String = "iOS Native Engine Loaded (Placeholder)"
}
''';
