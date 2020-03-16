TEMPLATE = app
QT += qml quick
CONFIG += link_pkgconfig
PKGCONFIG += qdeclarative5-boostable

SOURCES +=     main.cpp
HEADERS +=     process.h
RESOURCES +=   resources.qrc
OTHER_FILES += main.qml clockalarm.qml countdownalarm.qml

TARGET = asteroid-alarmpresenter
target.path = /usr/bin/

systemd.path = /usr/lib/systemd/user/
systemd.files = alarmpresenter.service

dbus.path = /usr/share/dbus-1/services
dbus.files = com.nokia.voland.service

translations.path = /usr/share/translations/
translations.files = i18n/*.qm

INSTALLS += target dbus systemd translations

DISTFILES += \
    clockalarm.qml
    countdownalarm.qml
TRANSLATIONS = $$files(i18n/$$TARGET.*.ts)
