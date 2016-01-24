#include "utils.h"
#include <QClipboard>
#include <sailfishapp.h>

Utils::Utils(QObject *parent) : QObject(parent)//,clipboard(QApplication::clipboard())
{
}

void paste(QString text){

    //clipboard.clear();
    //clipboard.insert("text/plain", text);
}
