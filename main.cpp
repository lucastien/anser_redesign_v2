#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include <QFontDatabase>
#include <QQmlFileSelector>
#include <QtWidgets/QApplication>

#include "disktablemodel.h"
#include "reelinfomodel.h"
#include "tlistcontroller.h"
#include "sortfilterproxymodel.h"
#include "tubehandler.h"
#include "lissajousitem.h"
#include "stripchartitem.h"
#include "expstripchartitem.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QFontDatabase::addApplicationFont(":/materialdesignicons-webfont.ttf");

    app.setOrganizationName("Westinghouse");
    app.setApplicationName("Tlist");
    app.setOrganizationDomain("westinghouse");
    app.setApplicationDisplayName("G7810 - RES");
    app.setApplicationVersion("1.1");

    qmlRegisterType<SortFilterProxyModel>("SortFilterProxyModel", 1, 0, "SortFilterProxyModel");
//    qmlRegisterType<TubeHandler>("TubeHandler", 1, 0, "TubeHandler");
    qmlRegisterUncreatableType<TubeHandler>("TubeHandler", 1, 0, "TubeHandler", QLatin1String("Can't create instances of TubeHandler"));
    qmlRegisterType<TubeHandler>();
    qmlRegisterType<TubeHandler>("TubeHandler", 1, 0, "TubeHandler");
    qmlRegisterType<LissajousItem>("App", 1, 0, "LissajousItem");
    qmlRegisterType<StripChartItem>("App", 1, 0, "StripChartItem");
    qmlRegisterType<ExpStripChartItem>("App", 1, 0, "ExpStripChartItem");

    qmlRegisterUncreatableType<Channel>("App", 1, 0, "Channel", QLatin1String("Cannot create objects of type Channel"));

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/AnserMain.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    DiskTableModel diskModel;
    TlistController tlistController;
    tlistController.setDiskModel(&diskModel);
    engine.rootContext()->setContextProperty("diskModel", &diskModel);
    engine.rootContext()->setContextProperty("tlistController", &tlistController);
    ReelInfoModel reelModel;
    tlistController.setReelModel(&reelModel);
    engine.rootContext()->setContextProperty("reelModel", &reelModel);

#if defined(Q_OS_WIN) || defined(Q_OS_MACOS)
    QQmlFileSelector fileSelector(&engine);
    fileSelector.setExtraSelectors(QStringList() << QLatin1String("nativemenubar"));
#endif

    engine.load(url);

    return app.exec();
}
