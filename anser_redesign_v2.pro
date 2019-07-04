QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
DEFINES += WINDOWS_IGNORE_PACKING_MISMATCH
# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        channel.cpp \
        channelhandler.cpp \
        channelqmlitem.cpp \
        disktablemodel.cpp \
        main.cpp \
        mountlisthandler.cpp \
        reelinfomodel.cpp \
        sortfilterproxymodel.cpp \
        tlistcontroller.cpp \
        tubehandler.cpp

RESOURCES += qml.qrc
win32 {

    ## Windows common build here

    !contains(QMAKE_TARGET.arch, x86_64) {
        LIBS += $$PWD/libs/x86/WS2_32.Lib

        ## Windows x86 (32bit) specific build here

    } else {
        LIBS += $$PWD/libs/x64/WS2_32.Lib

        ## Windows x64 (64bit) specific build here

    }
}
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    channel.h \
    channelhandler.h \
    channelparam.h \
    channelqmlitem.h \
    data.h \
    diskitem.h \
    disktablemodel.h \
    global.h \
    mountlisthandler.h \
    reelinfomodel.h \
    reellistitem.h \
    sortfilterproxymodel.h \
    tlistcontroller.h \
    tubehandler.h \
    winsock2.h

