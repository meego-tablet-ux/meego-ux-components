/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * Apache License, version 2.0.  The full text of the Apache License is at 
 * http://www.apache.org/licenses/LICENSE-2.0
 */

#include "fuzzydatetime.h"

#include <QDate>
#include <Qt>

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
            return tr("Just Now");
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
        if (dtDate.addDays(1) == nowDate) {
            return tr("Yesterday");
        } else if (dtDate.addDays(7) >= nowDate) {
            //: reorder according to the date format of a language: 1 is numeric month, 2 is numeric day, 3 is numeric year, 4 is day name; e.g. 5/31/11 - Tuesday
            return tr("%1/%2/%3 - %4").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"),
                    dtDate.toString("dddd"));
        } else if (dtDate.addDays(14) >= nowDate) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year; Last week is a fuzzy description
            return tr("%1/%2/%3 - Last week").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"));
        } else if (dtDate.addDays(21) >= nowDate) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year; A couple of weeks ago is a fuzzy description
            return tr("%1/%2/%3 - A couple of weeks ago").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"));
        } else if ( ( dtDate.month() == nowMonth ) && ( dtDate.year() == nowDate.year() ) ) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year, 4 is number of weeks; weeks ago is a fuzzy description
            return tr("%1/%2/%3 - %4 weeks ago").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"),
                    QString::number(int(dtDate.daysTo(nowDate)/7)));
        } else if (dtDate.addMonths(1).month() >= nowDate) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year; Last month is a fuzzy description
            return tr("%1/%2/%3 - Last month").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"));
        } else if (dtDate.addMonths(3) >= nowDate) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year; A couple of months ago is a fuzzy description
            return tr("%1/%2/%3 - A couple of months ago").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"));
        } else if (dtDate.addMonths(12) > nowDate) {
            int nowMonth2 = nowMonth;
            //If this is true, we're wrapping around a year, add 12 for the month math
            if (nowMonth2 < dtDate.month())
                nowMonth2 += 12;
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year, 4 is number of months; month ago is a fuzzy description
            return tr("%1/%2/%3 - %4 months ago").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"),
                    QString::number(nowMonth2-dtDate.month()));
        } else if (dtDate.addMonths( 11 + nowDate.month() ) >= nowDate) {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year; Last year is a fuzzy description
            return tr("%1/%2/%3 - Last year").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"));
        } else {
            //: reorder according to the date format of a language:  1 is numeric month, 2 is numeric day, 3 is numeric year, 4 is number of years; years ago is a fuzzy description
            return tr("%1/%2/%3 - %4 years ago", "1 is month, 2 is day, 3 is year").arg(
                    dtDate.toString("M"),
                    dtDate.toString("d"),
                    dtDate.toString("yy"),
                    QString::number(nowDate.year() - dtDate.year()));
        }
    }
}
