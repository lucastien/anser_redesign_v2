#ifndef TUBELOADER_H
#define TUBELOADER_H

#include "data.h"

class QString;
class TubeLoader
{
public:
    explicit TubeLoader(TubeData *tube, const QString& tubeFile);
    bool loadTube(const QString& suff = "");

private:
    int sizeHeader( TubeHeader *hdr, QDataStream& in);
    int initTube(const int npt);
    int formatBuff(char *buff,int nbyte);
    void fixHdr( TubeHeader *h);
private:
    TubeData *m_tube;
    QString m_tubeFile;
};

#endif // TUBELOADER_H
