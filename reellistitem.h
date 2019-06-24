#ifndef REELLISTITEM_H
#define REELLISTITEM_H

#include <QString>

struct ReelInfoItem{
    explicit ReelInfoItem(bool indexed_ = false,
            int entry_ = -1,
            const QString& sg_ = QString(),
            const QString& row_ = QString(),
            const QString& col_ = QString(),
            const QString& time_ = QString(),
            int length_ = -1,
            const QString& qa_ = QString(),
            const QString& rpt_ = QString("*"),
            const QString& fileName_ = QString())
        : indexed(indexed_), entry(entry_), sg(sg_),
          row(row_), col(col_), time(time_), length(length_),
          qa(qa_), rpt(rpt_), fileName(fileName_){}
    bool indexed;
    int entry;
    QString sg;
    QString row, col;
    QString time;
    int length;
    QString qa, rpt;
    QString fileName;
};

#endif // REELLISTITEM_H
