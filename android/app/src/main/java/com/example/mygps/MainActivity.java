package com.example.mygps;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import dev.thinkng.flt_worker.FltWorkerPlugin;
import com.baseflow.geolocator.GeolocatorPlugin;
import android.util.Log;
import android.os.Process;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
Log.d("kf6gpe", "configureFlutterEngine");
        // set a callback to register all plugins to a headless engine instance
        FltWorkerPlugin.registerPluginsForWorkers = registry -> {
            com.baseflow.geolocator.GeolocatorPlugin.registerWith(
                registry.registrarFor("com.baseflow.geolocator.GeolocatorPlugin"));
            return null;
        };
    }
}
