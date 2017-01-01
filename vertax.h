#ifndef DATAMAP_H
#define DATAMAP_H

#include <QObject>

class Vertax : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int i READ i WRITE setI NOTIFY iChanged)
    Q_PROPERTY(bool vis READ vis WRITE setVis NOTIFY visChanged)
public:
    Vertax(QObject *parent = 0);
    Vertax(int i, bool vis, QObject *parent = 0);

    int i() const;
    void setI(int i);

    bool vis() const;
    void setVis(bool vis);
signals:
    void iChanged();
    void visChanged();
private:
    int m_i;
    bool m_vis;
};

#endif // DATAMAP_H
