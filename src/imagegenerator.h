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
#include "filedownloader.h"

class ImageGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ImageGenerator(QObject *parent = 0);
    FileDownloader *fileDownloader;
    QString fileName;
    QRect screen;

signals:

public slots:
    void saveImage(QUrl imageUrl, QString fileName, int screenWidth, int screenHeight);
    void loadImage();
};

#endif // IMAGEGENERATOR_H
