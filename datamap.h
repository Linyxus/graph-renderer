#ifndef DATAMAP_H__
#define DATAMAP_H__

#include <QObject>
#include <QVector>

struct Point
{
    double x, y;
};

struct Line
{
    Point start, end;
};

struct Label
{
    Point pos;
    QString text;
};

class DataMap : public QObject
{
    Q_OBJECT
public:
    typedef QVector<Line> Lines;
    typedef QVector<Label> Labels;
    DataMap(QObject *parent = 0);
    Q_INVOKABLE int getLineCnt() const;
    Q_INVOKABLE double getStartX(int i) const;
    Q_INVOKABLE double getStartY(int i) const;
    Q_INVOKABLE double getEndX(int i) const;
    Q_INVOKABLE double getEndY(int i) const;
    Q_INVOKABLE int getCol() const;
    Q_INVOKABLE int getRow() const;
    Q_INVOKABLE bool getDirected() const;
    Q_INVOKABLE bool getShowGrid() const;
    Q_INVOKABLE int getLabelCnt() const;
    Q_INVOKABLE double getLabelX(int i) const;
    Q_INVOKABLE double getLabelY(int i) const;
    Q_INVOKABLE QString getLabelText(int i) const;
    void reset(const Lines& newLines, const Labels& newLabels, int newCol, int newRow, bool d, bool sg);
signals:
    void mapChanged();
private:
    Lines lines;
    Labels labels;
    int col;
    int row;
    bool d;
    bool sg;
};

#endif // DATAMAP_H__
