cmake_minimum_required(VERSION 3.29)

project(
  chess
  VERSION 0.1
  LANGUAGES CXX)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Qml Multimedia)

qt_standard_project_setup()

qt_add_executable(appchess)

qt_add_qml_module(
  appchess
  URI
  chess
  VERSION
  1.0
  QML_FILES
  Board.qml
  SOURCES
  SOURCES
  board.h
  board.cpp
  SOURCES
  pieces.h
  pieces.cpp
  SOURCES
  musicplayer.h
  musicplayer.cpp
  RESOURCES
  resource.qrc
  QML_FILES
  QML_FILES
  SOURCES
  main.cpp
  QML_FILES
  SOURCES
  QML_FILES
  Start.qml
  QML_FILES
  Help.qml
  QML_FILES
  Main.qml
  QML_FILES
  Manage.qml
  QML_FILES
  Modes.qml
  QML_FILES
  Mode.qml
  SOURCES
  mynetwork.h
  mynetwork.cpp
  QML_FILES
  NetWorkBlack.qml
  NetWorkWhite.qml
  QML_FILES
  Setting.qml
  QML_FILES
  Developer.qml)

target_compile_features(appchess PRIVATE cxx_std_20)

set_target_properties(
  appchess
  PROPERTIES AUTORCC TRUE
             MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
             MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
             MACOSX_BUNDLE_SHORT_VERSION_STRING
             ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
             MACOSX_BUNDLE TRUE
             WIN32_EXECUTABLE TRUE)

target_link_libraries(appchess PRIVATE Qt6::Quick Qt6::Qml Qt6::Multimedia)

include(GNUInstallDirs)
install(
  TARGETS appchess
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

# qt_add_executable(chess)  //Creates and finalizes an application target of a
# platform-specific type. This command performs the following tasks: 1. Create a
# CMake target of the appropriate type for the target platform. 2. Link the
# target to the Qt::Core library. 3. Handle finalization of the CMake target.

# qt_standard_project_setup()     #set(CMAKE_AUTOUIC ON)  set(CMAKE_AUTOMOC ON)

# @if %{HasTranslation} find_package(Qt6 REQUIRED COMPONENTS Core Quick
# LinguistTools) @else find_package(Qt6 REQUIRED COMPONENTS Core Quick) @endif

# target_sources(appchess PRIVATE main.cpp qml.qrc @if %{HasTranslation}
# %{TsFileName} @endif
#
# PUBLIC
#
# )

# qt_import_qml_plugins(chess)

# cmake_minimum_required(VERSION 3.16)
#
# project(chess VERSION 0.1 LANGUAGES CXX)
#
# @if !true set(CMAKE_AUTOMOC ON) @endif set(CMAKE_CXX_STANDARD_REQUIRED ON)
#
# find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)
#
# @if true @if false qt_standard_project_setup(REQUIRES 6.5) @else
# qt_standard_project_setup() @endif @endif
#
# qt_add_executable(appchess main.cpp )
#
# qt_add_qml_module(appchess URI chess VERSION 1.0 QML_FILES Main.qml )
#
# # Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1. #
# If you are developing for iOS or macOS you should consider setting an #
# explicit, fixed bundle identifier manually though.
# set_target_properties(appchess PROPERTIES #    MACOSX_BUNDLE_GUI_IDENTIFIER
# com.example.appchess MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
# MACOSX_BUNDLE_SHORT_VERSION_STRING
# ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR} MACOSX_BUNDLE TRUE
# WIN32_EXECUTABLE TRUE )
#
# target_link_libraries(appchess PRIVATE Qt6::Quick )
#
# include(GNUInstallDirs) install(TARGETS appchess BUNDLE DESTINATION . LIBRARY
# DESTINATION ${CMAKE_INSTALL_LIBDIR} RUNTIME DESTINATION
# ${CMAKE_INSTALL_BINDIR} )
