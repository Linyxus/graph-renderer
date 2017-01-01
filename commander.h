#ifndef MAP_H
#define MAP_H

#include "datamap.h"
#include <QObject>
#include "vertax.h"
#include <QList>
#include <QString>

struct Position
{
    int col, row, index;
};

struct Edge
{
    int u, v;
    QString w;
};

class Commander : public QObject
{
    Q_OBJECT
public:
    Commander(QObject *parent = 0);
    const QList<QObject *> &getData() const;
    DataMap *getDataMap();
    Q_INVOKABLE QString command(const QString &cmd);
signals:
    void dataChanged();
private:
    QList<QObject *> data;
    DataMap* dm;
    Line getLine(int ui, int vi, int col, int row, const QVector<Position> &p);
};

#endif // MAP_H
