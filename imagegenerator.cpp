#include "imagegenerator.h"

ImageGenerator::ImageGenerator(QObject *parent) : QObject(parent)
{

}

void ImageGenerator::saveImage(QUrl imageUrl){
    fileDownloader = new FileDownloader(imageUrl);
    connect(fileDownloader, SIGNAL (downloaded()), this, SLOT (loadImage()));
}

void ImageGenerator::loadImage(){
    QFile file("/home/nemo/1.png");
    file.open(QIODevice::WriteOnly);
    file.write(fileDownloader->downloadedData());
    file.close();
}

