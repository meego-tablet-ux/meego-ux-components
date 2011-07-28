/*
 * Copyright 2011 Wind River Systems
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */
#include <QtCore>
#include <QApplication>
#include <qdeclarative.h>
#include <QInputContext>
#include <mpreeditinjectionevent.h>
#include "preeditinjector.h"

void PreeditInjector::inject(QObject* editor, int start, int len)
{
    // Make simple code look simple
    typedef QInputMethodEvent QIME;
    typedef QIME::Attribute Attr;
    typedef QList<Attr> AList;

    QInputContext *ic = qApp->inputContext();
    if(!ic)
        return;

    // Duck typing: editors must support "text" property (true of QML
    // TextEdit/TextInput, but anything else can work if it will take
    // focus and honor Qt input method APIs).
    QString substr = editor->property("text").toString().mid(start, len);

    // Select text, replace with preedit version.  MTextEdit will
    // simply remove the text, but the QML editors aren't prepared to
    // do that sanely.  Also: MInputContext is responsible for putting
    // the text back as "default" preedit initially, but that gets
    // disabled if global correction is off (and thus the text gets
    // eaten on selection!) so do it here too.
    ic->sendEvent(QIME("", AList() += Attr(QIME::Selection, start, len, 0)));
    ic->sendEvent(QIME(substr, AList()));

    // Send to Maliit, otherwise reset
    MPreeditInjectionEvent pie(substr, start);
    if(!ic->filterEvent(&pie))
        ic->sendEvent(QIME(substr, AList()));
}
