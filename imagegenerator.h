#ifndef IMAGEGENERATOR_H
#define IMAGEGENERATOR_H

#include <QObject>
#include <QFile>
#include <QUrl>
#include <QPixmap>
#include "filedownloader.h"

class ImageGenerator : public QObject
{
    Q_OBJECT
public:
    explicit ImageGenerator(QObject *parent = 0);
    FileDownloader *fileDownloader;

signals:

public slots:
    void saveImage(QUrl imageUrl);
    void loadImage();
};

#endif // IMAGEGENERATOR_H
