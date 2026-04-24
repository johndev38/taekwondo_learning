package com.johndev38.taekwondo_knowledge

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Assure la compatibilité avec l'affichage bord à bord imposé par
        // Android 15 (SDK 35) et active ce mode sur les versions antérieures
        // pour un rendu homogène.
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }
}
