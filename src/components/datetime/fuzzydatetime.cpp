/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

#include "fuzzydatetime.h"

#include <QDate>

FuzzyDateTime::FuzzyDateTime(QObject *parent) :
    QObject(parent)
{
}

const QString FuzzyDateTime::getFuzzy(const QDateTime &dt) const
{
    QDateTime now = QDateTime::currentDateTime();
    QDate nowDate = now.date();
    QDate dtDate = dt.date();
    int nowMonth = nowDate.month();

    if (dt == QDateTime())
        return "";

    if (nowDate == dtDate) {
        if (dt.addSecs(60) > now) {
            return tr("Just now");
        } else if (dt.addSecs(2 * 60) > now) {
            return tr("1 min ago");
        } else if (dt.addSecs(29 * 60) > now) {
            return tr("%1 mins ago", "1 is number of minutes").arg(
                    QString::number(int(dt.secsTo(now)/60)));
        } else if (dt.addSecs(59 * 60) > now) {
            return tr("Half an hour ago");
        } else if (dt.addSecs(119 * 60) > now) {
            return tr("An hour ago");
        } else if (dt.addSecs(239 * 60) > now) {
            return tr("A couple of hours ago");
        } else {
            return tr("%1 hours ago", "1 is number of hours").arg(
                    QString::number(int(dt.secsTo(now)/(60 * 60))));
        }
    } else {
        QString dateFormat = tr("M/d/yy", "QDateTime format string: M is numeric month, d is num. day, yy is year; e.g. 1/31/11");
        QString formattedDate = dtDate.toString(dateFormat);

        QString fuzzyDateFormat = tr("%1 - %2", "%1 is formatted date, %2 is fuzzy date description, e.g. 1/31/11 - Last week");

        if (dtDate.addDays(1) == nowDate) {
            return tr("Yesterday", "Fuzzy date description");
        } else if (dtDate.addDays(7) >= nowDate) {
            return fuzzyDateFormat.arg(formattedDate, dtDate.toString("dddd"));
        } else if (dtDate.addDays(14) >= nowDate) {
            return fuzzyDateFormat.arg(formattedDate, tr("Last week", "Fuzzy date description"));
        } else if (dtDate.addDays(21) >= nowDate) {
            return fuzzyDateFormat.arg(formattedDate, tr("A couple of weeks ago", "Fuzzy date description"));
        } else if ( ( dtDate.month() == nowMonth ) && ( dtDate.year() == nowDate.year() ) ) {
            int weeks = dtDate.daysTo(nowDate) / 7;
            return fuzzyDateFormat.arg(formattedDate, tr("%1 weeks ago", "Fuzzy date description - %1 is a number").arg(weeks));
        } else if ( dtDate.addMonths(1) >= nowDate ) {
            return fuzzyDateFormat.arg(formattedDate, tr("Last month", "Fuzzy date description"));
        } else if (dtDate.addMonths(3) >= nowDate) {
            return fuzzyDateFormat.arg(formattedDate, tr("A couple of months ago", "Fuzzy date description"));
        } else if (dtDate.addMonths(12) > nowDate) {
            int months = nowMonth - dtDate.month();
            //If this is true, we're wrapping around a year, add 12
            if (months < 0)
                months += 12;
            return fuzzyDateFormat.arg(formattedDate, tr("%1 months ago", "Fuzzy date description - %1 is a number").arg(months));
        } else if (dtDate.addMonths(11 + nowDate.month()) >= nowDate) { //23
            return fuzzyDateFormat.arg(formattedDate, tr("Last year", "Fuzzy date description"));
        } else {
            int years = nowDate.year() - dtDate.year();
            return fuzzyDateFormat.arg(formattedDate, tr("%1 years ago", "Fuzzy date description - %1 is a number").arg(years));
        }
    }
}
