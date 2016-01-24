#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QClipboard>


class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = 0);
    void paste(QString text);

private:
    QClipboard* clipboard;

signals:

public slots:
};

#endif // UTILS_H
