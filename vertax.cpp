#include "vertax.h"

Vertax::Vertax(QObject *parent)
    : QObject(parent)
{

}

Vertax::Vertax(int i, bool vis, QObject *parent)
    : m_i(i), m_vis(vis), QObject(parent)
{

}

int Vertax::i() const
{
    return m_i;
}

void Vertax::setI(int i)
{
    if (m_i != i) {
        m_i = i;
        emit iChanged();
    }
}

bool Vertax::vis() const
{
    return m_vis;
}

void Vertax::setVis(bool vis)
{
    if (m_vis != vis) {
        m_vis = vis;
        emit visChanged();
    }
}
