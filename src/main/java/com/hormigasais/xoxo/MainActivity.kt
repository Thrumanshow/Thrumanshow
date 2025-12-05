package com.hormigasais.xoxo

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            XoxoApp()
        }
    }
}

@Composable
fun XoxoApp() {
    MaterialTheme {
        Surface(modifier = Modifier.fillMaxSize()) {
            Column(modifier = Modifier.fillMaxSize().padding(16.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                Text("XOXO — HormigasAIS", style = MaterialTheme.typography.headlineLarge)
                Spacer(modifier = Modifier.height(12.dp))
                Text("El asistente creativo de tu colmena digital.")
                Spacer(modifier = Modifier.height(20.dp))
                Button(onClick = { /* Abrir chat */ }) {
                    Text("Conversar")
                }
                Spacer(modifier = Modifier.height(8.dp))
                Button(onClick = { /* Abrir crear */ }) {
                    Text("Crear")
                }
                Spacer(modifier = Modifier.height(8.dp))
                Button(onClick = { /* Abrir automatizar */ }) {
                    Text("Automatizar")
                }
            }
        }
    }
}
