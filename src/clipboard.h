#ifndef CLIPBOARD_H
#define CLIPBOARD_H

#include <QObject>
#include <QClipboard>
#include <QDebug>

class Clipboard : public QObject
{
    Q_OBJECT
public:
    explicit Clipboard(QObject *parent = 0);
    Q_INVOKABLE
    void copyToClipboard();

private:

signals:

public slots:
};

#endif // CLIPBOARD_H
