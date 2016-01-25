#include "imagegenerator.h"

ImageGenerator::ImageGenerator(QObject *parent) : QObject(parent)
{

}

void ImageGenerator::saveImage(QUrl imageUrl, QString fileName, int screenWidth, int screenHeight){
    fileDownloader = new FileDownloader(imageUrl);
    this->fileName = fileName;
    screen.setWidth(screenWidth);
    screen.setHeight(screenHeight);
    connect(fileDownloader, SIGNAL (downloaded()), this, SLOT (loadImage()));
}

void ImageGenerator::loadImage(){
    QPixmap part;
    part.loadFromData(fileDownloader->downloadedData());
    QPixmap *picture = new QPixmap(screen.width(), screen.height());
    QPainter painter(picture);
    int x = 0, y = 0;
    while(x < picture->width() || y < picture->height()){
        painter.drawPixmap(x, y, part.width(), part.height(), part);
        x += part.width();
        y += part.height();
    }
    painter.end();
    qDebug() << QDir::homePath();
    picture->save(QString("%1/Pictures/%2.png").arg(QDir::homePath()).arg(fileName));
}

