#include "commander.h"
#include <sstream>
#include <algorithm>

Commander::Commander(QObject *parent)
    : QObject(parent)
{
    this->dm = new DataMap(this);
}

const QList<QObject *> &Commander::getData() const
{
    return this->data;
}

DataMap *Commander::getDataMap()
{
    return this->dm;
}

Line Commander::getLine(int ui, int vi, int col, int row, const QVector<Position> &p)
{
    Position u;
    Position v;
    for (int i = 0; i < p.size(); i++) {
        if (ui == p[i].index) {
            u = p[i];
        }
        if (vi == p[i].index) {
            v = p[i];
        }
    }
    Line line;
    double fcol = 1.0 / col;
    double frow = 1.0 / row;
    line.start.x = (u.col + 0.5) * fcol;
    line.start.y = (u.row + 0.5) * frow;
    line.end.x = (v.col + 0.5) * fcol;
    line.end.y = (v.row + 0.5) * frow;
    return line;
}

QVector<Line> Commander::getDirectedLine(int ui, int vi, int col, int row, const QVector<Position> &p)
{
    Position u;
    Position v;
    for (int i = 0; i < p.size(); i++) {
        if (ui == p[i].index) {
            u = p[i];
        }
        if (vi == p[i].index) {
            v = p[i];
        }
    }
    QVector<Line> lines;
    Line line;

    //basic line
    double fcol = 1.0 / col;
    double frow = 1.0 / row;
    line.start.x = (u.col + 0.5) * fcol;
    line.start.y = (u.row + 0.5) * frow;
    line.end.x = (v.col + 0.5) * fcol;
    line.end.y = (v.row + 0.5) * frow;
    lines.append(line);

    //arrow
    double mx = (line.start.x + line.end.x) / 2;
    double my = (line.start.y + line.end.y) / 2;
    double d = (line.start.x - line.end.x) / 10;
    double m = (line.end.y - line.end.x) / 10;
    line.start.x = mx;
    line.start.y = my;
    line.end.x = mx + m;
    line.end.y = my + d;
    lines.append(line);
    line.end.x = mx - m;
    line.end.y = my - d;
    lines.append(line);

    return lines;
}

/**
 * grid col row //create grid
 * setdirected true|false //directed graph or not (false by default)
 * vertax col row index//put a vertax[index] at (col, row)
 * edge i1 i2 w //create a edge i1 --w--> i2, w is a string, so you can type anything
 * showgrid true|false //true by default
 */

QString Commander::command(const QString &cmd)
{
    std::stringstream ss(cmd.toStdString());
    std::string str;
    QVector<Position> p;
    QVector<Edge> e;
    bool directed = false;
    bool showgrid = true;
    bool hasGrid = false;
    int col;
    int row;
    while (ss >> str) {
        if (str == "grid") {
            hasGrid = true;
            ss >> col >> row;
        } else if (str == "setdirected") {
            std::string b;
            ss >> b;
            if (b == "true")
                directed = true;
            else if (b == "false")
                directed = false;
            else
                return "Unexcepted arguments (true/false)";
        } else if (str == "vertax") {
            Position pos;
            ss >> pos.col >> pos.row >> pos.index;
            p.append(pos);
        } else if (str == "edge") {
            Edge ed;
            std::string s;
            ss >> ed.u >> ed.v >> s;
            ed.w = QString::fromStdString(s);
            e.append(ed);
        } else if (str == "showgrid") {
            std::string b;
            ss >> b;
            if (b == "true")
                showgrid = true;
            else if (b == "false")
                showgrid = false;
            else
                return "Unexcepted arguments (true/false)";
        } else {
            return "Undefined function";
        }
        if (!ss) {
            return "Too few arguments";
        }
    }
    if (!hasGrid) {
        return "Grid not defined!";
    }

    //update dm
    DataMap::Lines lines;
    if (!directed) {
        for (int i = 0; i < e.size(); i++) {
            Line line = getLine(e[i].u, e[i].v, col, row, p);
            lines.append(line);
        }
    } else {
        for (int i = 0; i < e.size(); i++) {
            QVector<Line> line = this->getDirectedLine(e[i].u, e[i].v, col, row, p);
            lines += line;
        }
    }
    dm->reset(lines, col, row, directed, showgrid);

    //update data
    data.clear();
    for (int i = 0; i < col * row; i++) {
        Vertax *v = new Vertax(0, false, this);
        data.append(v);
    }
    for (int i = 0; i < p.size(); i++) {
        int x = p[i].row * col + p[i].col;
        dynamic_cast<Vertax*>(data[x])->setI(p[i].index);
        dynamic_cast<Vertax*>(data[x])->setVis(true);
    }
    emit dataChanged();
    return "Succeed!";
}
