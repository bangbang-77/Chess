#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "board.h"
#include "mynetwork.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/chess/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    Board chessBoard;
    engine.rootContext()->setContextProperty("chessBoard", &chessBoard);
    qmlRegisterType<MyNetWork>("MyNetWork", 1, 0, "Ipv4");
    engine.load(url);

    return app.exec();
}
