#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QList>
#include "vertax.h"
#include "commander.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QList<QObject*> l;
    l.append(new Vertax(0, true));
    l.append(new Vertax(2, true));
    l.append(new Vertax(1, true));
    l.append(new Vertax(3, true));
    l.append(new Vertax(1, true));
    l.append(new Vertax(0, true));
    dynamic_cast<Vertax*>(l[1])->setVis(false);

    QQmlApplicationEngine engine;
    Commander *cmd = new Commander();
    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("cmd", cmd);
    ctxt->setContextProperty("dataMap", cmd->getDataMap());
    l.append(new Vertax(0, true));
    l.append(new Vertax(0, true));
    ctxt->setContextProperty("datas", QVariant::fromValue(cmd->getData()));
    QObject::connect(cmd, &Commander::dataChanged, [ctxt, cmd]() {
        ctxt->setContextProperty("datas", QVariant::fromValue(cmd->getData()));
        qDebug("Hello");
    });
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
