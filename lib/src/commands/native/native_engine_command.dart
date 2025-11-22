import 'dart:io';

void createNativeEngine(String name) {
final path = 'native_engine_$name';

  print('🚀 Creating Native Engine Module: native_engine_$name');

  // Create folder structure
  Directory('$path').createSync(recursive: true);
  Directory('$path/src/commonMain/kotlin').createSync(recursive: true);
  Directory('$path/src/commonMain/resources').createSync(recursive: true);

  Directory('$path/src/androidMain/kotlin').createSync(recursive: true);
  Directory('$path/src/iosMain/kotlin').createSync(recursive: true);

  // Write Gradle
  File('$path/build.gradle.kts').writeAsStringSync(_gradleTemplate(name));

  // Common API service
  File('$path/src/commonMain/kotlin/ApiService.kt')
      .writeAsStringSync(_apiServiceTemplate());

  // Common repository
  File('$path/src/commonMain/kotlin/${_capitalize(name)}Repository.kt')
      .writeAsStringSync(_repositoryTemplate(name));

  // Common model
  File('$path/src/commonMain/kotlin/${_capitalize(name)}Model.kt')
      .writeAsStringSync(_modelTemplate(name));

  print('✅ Native Engine "$name" created successfully!');
}

String _gradleTemplate(String name) => '''
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
    namespace = "native.engine.$name"
    compileSdk = 34
}
''';

String _apiServiceTemplate() => '''
package native.engine.api

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

String _repositoryTemplate(String name) => '''
package native.engine.$name

import native.engine.api.ApiService

class ${_capitalize(name)}Repository(
    private val api: ApiService = ApiService()
) {
    suspend fun getExample() = api.getFreeApi()
}
''';

String _modelTemplate(String name) => '''
package native.engine.$name

data class ${_capitalize(name)}Model(
    val id: Int,
    val title: String
)
''';

String _capitalize(String text) =>
    text[0].toUpperCase() + text.substring(1);
