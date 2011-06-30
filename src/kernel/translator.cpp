/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "translator.h"

#include <QLocale>
#include <QTranslator>
#include <QLibraryInfo>
#include <QCoreApplication>
#include <meegolocale.h>

Translator::Translator(QObject *parent) :
    QObject(parent),
    mTranslator(new QTranslator(this))
{
    meego::Locale l;
    mLangCode = l.locale();
}

QString Translator::getCatalog() const
{
    return mCatalog;
}

void Translator::setCatalog(const QString &catName)
{
    mCatalog = catName;
    loadCatalog();
}

QString Translator::getSearchDir() const
{
    return mSearchDir;
}

void Translator::setSearchDir(const QString &dirName)
{
    mSearchDir = dirName;
    loadCatalog();
}

QString Translator::getLangCode() const
{
    return mLangCode;
}

void Translator::setLangCode(const QString &langCode)
{
    if (langCode.isEmpty())
        resetLangCode();
    else
        mLangCode = langCode;

    loadCatalog();
}

//Private functions

void Translator::loadCatalog()
{
    bool foundIt = false;
    QString catName = QString("%1_%2").arg(mCatalog, mLangCode);
    QString catDir = QString("/usr/share/%1").arg(mCatalog);

    if (mCatalog.isEmpty())
        return;
    if (!(foundIt = mTranslator->load(catName, mSearchDir))) {
        if (!(foundIt = mTranslator->load(catName, catDir))) {
            //TODO: Find out if there will be a universal meego-tablet translations directory to try?
            foundIt = mTranslator->load(catName, QLibraryInfo::location(QLibraryInfo::TranslationsPath));
        }
    }

    if (foundIt)
        QCoreApplication::installTranslator(mTranslator);
}
