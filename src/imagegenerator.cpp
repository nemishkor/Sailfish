#include "imagegenerator.h"

ImageGenerator::ImageGenerator(QObject *parent) : QObject(parent)
{

}

void ImageGenerator::saveImage(QUrl imageUrl, QString fileName, int screenWidth, int screenHeight, bool blacken, QString overlayColor, int overlayOpacity){
    fileDownloader = new FileDownloader(imageUrl);
    this->fileName = fileName;
    this->blacken = blacken;
    this->overlayColor = overlayColor;
    this->overlayOpacity = overlayOpacity;
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
    while(y < picture->height()){
        while(x < picture->width()){
            painter.drawPixmap(x, y, part.width(), part.height(), part);
            x += part.width();
        }
        x = 0;
        y += part.height();
    }
    if(overlayColor != "NULL"){
        QColor color(overlayColor);
        color.setAlpha(overlayOpacity);
        painter.fillRect(0,0,picture->width(),picture->height(), color);

    }
    if(blacken == true){
        QRadialGradient gradient(picture->width() / 2, picture->height() / 2, sqrt(pow(picture->width(), 2) + pow(picture->height(), 2)) / 2);
        gradient.setColorAt(0, QColor(0,0,0,0));
        gradient.setColorAt(1, QColor(0,0,0,200));
        painter.fillRect(0,0,picture->width(),picture->height(), gradient);
    }
    painter.end();
    QString path = QString("%1/Pictures/%2.png").arg(QDir::homePath()).arg(fileName);
    qDebug() << path;
    picture->save(path);
}

