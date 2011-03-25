#ifndef WINDOWWINDOWPROVIDER_H
#define WINDOWWINDOWPROVIDER_H

#include <QDeclarativeImageProvider>
#include "windowlistener.h"

class WindowIconProvider : public QDeclarativeImageProvider
{
public:
    WindowIconProvider();
    ~WindowIconProvider();

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:
    WindowListener *listener;
};

#endif // WINDOWWINDOWPROVIDER_H
