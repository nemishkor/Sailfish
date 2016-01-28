#ifndef IMAGEGENERATOR_H
#define IMAGEGENERATOR_H

#include <QObject>
#include <QFile>
#include <QUrl>
#include <QPixmap>
#include <QDebug>
#include <QScreen>
#include <QPainter>
#include <QDir>
#include <QRadialGradient>
#include <math.h>
#include "filedownloader.h"

class ImageGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ImageGenerator(QObject *parent = 0);
    FileDownloader *fileDownloader;
    QString fileName;
    bool blacken;
    QString overlayColor;
    QRect screen;
    int overlayOpacity;

signals:

public slots:
    void saveImage(QUrl imageUrl, QString fileName, int screenWidth, int screenHeight, bool blacken, QString overlayColor, int overlayOpacity);
    void loadImage();
};

#endif // IMAGEGENERATOR_H
