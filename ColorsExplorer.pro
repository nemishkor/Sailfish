# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = ColorsExplorer

CONFIG += sailfishapp

SOURCES += src/ColorsExplorer.cpp \
    src/clipboard.cpp \
    src/filedownloader.cpp \
    src/imagegenerator.cpp \
    src/utils.cpp

OTHER_FILES += qml/ColorsExplorer.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/ColorsExplorer.changes.in \
    rpm/ColorsExplorer.spec \
    rpm/ColorsExplorer.yaml \
    translations/*.ts \
    ColorsExplorer.desktop \
    qml/content/Checkerboard.qml \
    qml/content/ColorSlider.qml \
    qml/content/ColorUtils.js \
    qml/content/NumberBox.qml \
    qml/content/PanelBorder.qml \
    qml/content/SBPicker.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ColorsSelectorPage.qml \
    qml/pages/ColoursPage.qml \
    qml/pages/HELPER.txt \
    qml/pages/ItemPage.qml \
    qml/pages/ListPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += translations/ColorsExplorer-de.ts
TRANSLATIONS += translations/ColorsExplorer-it.ts
TRANSLATIONS += translations/ColorsExplorer-ru.ts

RESOURCES += \
    icons.qrc

QT += network

HEADERS += \
    src/clipboard.h \
    src/filedownloader.h \
    src/imagegenerator.h \
    src/utils.h

DISTFILES += \
    qml/pages/HistoryPage.qml \
    qml/pages/FavoritesPage.qml \
    qml/dialogs/RangeDialog.qml \
    qml/pages/AmbiencesPage.qml

