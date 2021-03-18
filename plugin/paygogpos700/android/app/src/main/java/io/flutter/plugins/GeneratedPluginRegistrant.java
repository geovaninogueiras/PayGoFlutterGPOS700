package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import com.exemple.paygogpos700.paygogpos700.Paygogpos700Plugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    Paygogpos700Plugin.registerWith(registry.registrarFor("com.exemple.paygogpos700.paygogpos700.Paygogpos700Plugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
