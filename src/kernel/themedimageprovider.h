#ifndef THEMEDIMAGEPROVIDER_H
#define THEMEDIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>

class MGConfItem;

class ThemedImageProvider : public QDeclarativeImageProvider
{
public:
    ThemedImageProvider();
    ~ThemedImageProvider();

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:
    MGConfItem *themeItem;
};

#endif // THEMEDIMAGEPROVIDER_H
