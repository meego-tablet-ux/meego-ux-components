#ifndef THEMEIMAGEPROVIDER_H
#define THEMEIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>

class MGConfItem;

class ThemeImageProvider : public QDeclarativeImageProvider
{
public:
    ThemeImageProvider();
    ~ThemeImageProvider();

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);

private:
    MGConfItem *themeItem;
};

#endif // THEMEIMAGEPROVIDER_H
