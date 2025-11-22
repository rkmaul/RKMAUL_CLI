import 'dart:io';

void createNativeEngine() {
  final path = 'native_engine';

  print('🚀 Creating Native Engine Module');

  // Folder structure
  Directory('$path').createSync(recursive: true);

  // Common
  Directory('$path/src/commonMain/kotlin/native/engine')
      .createSync(recursive: true);
  Directory('$path/src/commonMain/resources')
      .createSync(recursive: true);

  // Android
  Directory('$path/src/androidMain/kotlin/native/engine')
      .createSync(recursive: true);

  // iOS
  Directory('$path/src/iosMain/kotlin/native/engine')
      .createSync(recursive: true);

  // Generate files
  File('$path/build.gradle.kts')
      .writeAsStringSync(_gradleTemplate());

  File('$path/src/commonMain/kotlin/native/engine/ApiService.kt')
      .writeAsStringSync(_apiServiceTemplate());

  File('$path/src/commonMain/kotlin/native/engine/NativeRepository.kt')
      .writeAsStringSync(_repositoryTemplate());

  File('$path/src/commonMain/kotlin/native/engine/NativeModel.kt')
      .writeAsStringSync(_modelTemplate());

  print('✅ Native Engine created successfully!');
}

// Templates

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
