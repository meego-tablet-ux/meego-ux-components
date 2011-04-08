/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#ifndef WINDOWINFO_H_
#define WINDOWINFO_H_

#include <QString>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

class WindowInfo
{
public:

    WindowInfo(QString &title, Window window,
               XWindowAttributes windowAttributes, Pixmap icon,
               QString &iconName,
               QString &notificationIconName,
               int pid) :
    m_title(title),
    m_window(window),
    m_windowAttributes(windowAttributes),
    m_icon(icon),
    m_iconName(iconName),
    m_notificationIconName(notificationIconName),
    m_pid(pid) {}

    ~WindowInfo() {}

    QString title() const {
        return m_title;
    }

    Window window() const {
        return m_window;
    }

    XWindowAttributes windowAttributes() const {
        return m_windowAttributes;
    }

    Pixmap icon() const {
        return m_icon;
    }

    QString iconName() const {
        return m_iconName;
    }

    QString notificationIconName() const {
        return m_notificationIconName;
    }

    int pid() {
        return m_pid;
    }

private:
    QString m_title;
    Window m_window;
    XWindowAttributes m_windowAttributes;
    Pixmap m_icon;
    QString m_iconName;
    QString m_notificationIconName;
    int m_pid;
};

#endif /* WINDOWINFO_H_ */
