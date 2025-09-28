#
# Generated file, do not edit.
#

list(APPEND FLUTTER_PLUGIN_LIST
  desktop_webview_window
  dynamic_color
  emoji_picker_flutter
  file_selector_linux
  flutter_secure_storage_linux
  gtk
  handy_window
  irondash_engine_context
  local_notifier
  media_kit_libs_linux
  media_kit_video
  screen_retriever_linux
  sqlcipher_flutter_libs
  super_native_extensions
  system_theme
  url_launcher_linux
  volume_controller
  window_manager
  window_to_front
  xdg_icons
  yaru_window_linux
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST
  flutter_vodozemac
)

set(PLUGIN_BUNDLED_LIBRARIES)

foreach(plugin ${FLUTTER_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${plugin}/linux plugins/${plugin})
  target_link_libraries(${BINARY_NAME} PRIVATE ${plugin}_plugin)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${plugin}_plugin>)
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${plugin}_bundled_libraries})
endforeach(plugin)

foreach(ffi_plugin ${FLUTTER_FFI_PLUGIN_LIST})
  add_subdirectory(flutter/ephemeral/.plugin_symlinks/${ffi_plugin}/linux plugins/${ffi_plugin})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES ${${ffi_plugin}_bundled_libraries})
endforeach(ffi_plugin)
