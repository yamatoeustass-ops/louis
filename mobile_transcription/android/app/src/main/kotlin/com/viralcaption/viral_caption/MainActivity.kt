package com.viralcaption.viral_caption

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.huawei.hms.api.HuaweiMobileServicesUtil

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize HMS Core
        try {
            HuaweiMobileServicesUtil.setApplication(this)
        } catch (e: Exception) {
            // HMS not available (non-Huawei device)
            println("HMS Core not available: ${e.message}")
        }
    }
}
