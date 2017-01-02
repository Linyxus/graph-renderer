#include "datamap.h"

DataMap::DataMap(QObject *parent)
    : QObject(parent)
{

}

int DataMap::getLineCnt() const
{
    return lines.size();
}

double DataMap::getStartX(int i) const
{
    return lines[i].start.x;
}

double DataMap::getStartY(int i) const
{
    return lines[i].start.y;
}

double DataMap::getEndX(int i) const
{
    return lines[i].end.x;
}

double DataMap::getEndY(int i) const
{
    return lines[i].end.y;
}

int DataMap::getCol() const
{
    return this->col;
}

int DataMap::getRow() const
{
    return this->row;
}

bool DataMap::getDirected() const
{
    return this->d;
}

bool DataMap::getShowGrid() const
{
    return this->sg;
}

void DataMap::reset(const Lines &newLines, int newCol, int newRow, bool d, bool sg)
{
    this->lines = newLines;
    this->col = newCol;
    this->row = newRow;
    this->d = d;
    this->sg = sg;
    emit mapChanged();
}
