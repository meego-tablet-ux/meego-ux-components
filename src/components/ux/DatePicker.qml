/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass DatePicker
  \section1 DatePicker
  \qmlcm Displays control elements to choose a date by day, month and year. The values
         can either be chosen using the three PopupLists at the top or by the calender
         grid in the center.

  \section1  API properties

  \qmlproperty variant selectedDate
  \qmlcm contains the currently selected date.

  \qmlproperty int firstYear
  \qmlcm sets the first year available in the year spinner. This can be set only once at object creation.

  \qmlproperty int lastYear
  \qmlcm sets the last year available in the year spinner. This can be set only once at object creation.

  \section1  Private properties (for internal use only)

  \qmlproperty list<string> daysOfWeek
  \qmlcm contains the names of the days in a week.

  \qmlproperty list<string> shortMonths
  \qmlcm contains the names of the months shortened to the first three characters.

  \qmlproperty list<string> fullMonths
  \qmlcm contains the full names of the months.

  \qmlproperty variant dayModel
  \qmlcm contains a listModel for the days.

  \qmlproperty variant monthModel
  \qmlcm contains a listModel for the months.

  \qmlproperty variant yearModel
  \qmlcm contains a listModel for the years.

  \section1 Private properties

  \qmlproperty variant oldDate
  \qmlcm stores the date which was selected when the dialog is shown to restore it on cancel.

  \qmlproperty int day
  \qmlcm used to initialize the day spinner.

  \qmlproperty int month
  \qmlcm used to initialize the month spinner.

  \qmlproperty int year
  \qmlcm used to initialize the year spinner.

  \qmlproperty bool isFuture
  \qmlcm true if the currently selected date is in the future.

  \qmlproperty bool isPast
  \qmlcm true if the currently selected date is in the past.

  \section1  Signals
  \qmlsignal dateSelected
  \qmlcm emitted when ok button is clicked, propagates the selected date.
        \param variant date
        \qmlcm holds a Date object.

  \section1  Functions

  \qmlfn show
  \qmlcm fades the picker in, inherited from ModalFog.

  \qmlfn hide
  \qmlcm fades the picker out, inherited from ModalFog.

  \qmlfn today
  \qmlcm returns the current date, internal use only.
        \retval variant date
        \qmlcm the current date

  \qmlfn isCurrentDate
  \qmlcm returns true if parameter date matches the current date, internal use only.
        \param   date    \qmlcm date object.
        \retval  bool	 \qmlcm true if the parameter date matches the current date

  \qmlfn startDay
  \qmlcm returns the first day of month mm in year yyyy, internal use only.
  \param int  mm
  \param int  yyyy
  \retval int \qmlcm the first day of the given month and year

  \qmlfn daysInMonth
  \qmlcm returns the number of days of month mm in year yyyy, internal use only.
  \param   mm  integer
  \param   yyyy    integer
  \retval  integer the number of days in the given month and year

  \qmlfn isSelectedDate
  \qmlcm returns true if the currently selected date is dd-mm-yyyy, internal use only.
  \param   dd  integer
  \param   mm  integer
  \param   yyyy   integer
  \retval  bool    true if the currently selected date matches the given date

  \qmlfn nexthMonth
  \qmlcm returns the index of the following month, internal use only.
  \param   refDate date object
  \retval  int    the index of the following month

  \qmlfn prevMonth
  \qmlcm returns the index of the former month, internal use only.
  \param   refDate date object
  \retval  int    the index of the former month

  \qmlfn setFuturePast
  \qmlcm checks if the currently selected date is in the future or the past and
         sets the properties isFuture and isPast accordingly.

  \qmlfn updateSelectedDate
  \qmlcm updates the day model if necessary, updates the spinners and sets the selected date.
  \param   d    int, the new day
  \param   m    int, the new month
  \param   y    int, the new year

  \qmlfn setDays
  \qmlcm updates the selected day.
  \param   d    int, the new day
  \param   m    int, the new month
  \param   y    int, the new year

  \qmlfn changeDayModel
  \qmlcm updates the day model if necessary.
  \param   d    int, the new day
  \param   m    int, the new month
  \param   y    int, the new year

  \section1  Example
  \code
      //a button labeled with the selected date
      Button {
          id: dateButton

          DatePicker {
              id: datePicker

              onDateSelected: {
                  dateButton.text = //TODO: where does Date come from?
              }
          }

          onClicked: {
              datePicker.show()
          }
      }
  \endcode
    property int firstYear: 1980
    property int lastYear: 2020
*/

import Qt 4.7
import MeeGo.Components 0.1

ModalDialog {
    id: datePicker

    property variant selectedDate

    property int minYear: 1980
    property int minMonth: 1
    property int minDay: 1
    property int maxYear: 2020
    property int maxMonth: 12
    property int maxDay: 31
    property bool currentYearLimited: false
    property bool currentMonthLimited: false

    property variant daysOfWeek: [ qsTr("S"),
                                   qsTr("M"),
                                   qsTr("T"),
                                   qsTr("W"),
                                   qsTr("T"),
                                   qsTr("F"),
                                   qsTr("S") ]

    property variant shortMonths: [ qsTr("Jan"),
                                    qsTr("Feb"),
                                    qsTr("Mar"),
                                    qsTr("Apr"),
                                    qsTr("May"),
                                    qsTr("Jun"),
                                    qsTr("Jul"),
                                    qsTr("Aug"),
                                    qsTr("Sep"),
                                    qsTr("Oct"),
                                    qsTr("Nov"),
                                    qsTr("Dec") ]

    property variant fullMonths: [  qsTr('January'),
                                    qsTr('February'),
                                    qsTr('March'),
                                    qsTr('April'),
                                    qsTr('May'),
                                    qsTr('June'),
                                    qsTr('July'),
                                    qsTr('August'),
                                    qsTr('September'),
                                    qsTr('October'),
                                    qsTr('November'),
                                    qsTr('December') ]

    property variant dayModel: dummyListModel
    property variant monthModel: dummyListModel
    property variant yearModel: dummyListModel

    property bool isFuture: false
    property bool isPast: false

    property int month: -1
    property int day: -1
    property int year: -1 

    property variant oldDate

    property bool allowUpdates: true

    signal dateSelected( variant date )

    function today() {
        var currentDate = new Date()
        month = currentDate.getMonth()
        day = currentDate.getDate()
        year = currentDate.getFullYear()

        return currentDate
    }

    function isCurrentDate( date ) {
        var currentDate = new Date()
        if (
                ( date.getDate() == currentDate.getDate() ) &&
                ( date.getMonth() == currentDate.getMonth() ) &&
                ( date.getFullYear() == currentDate.getFullYear() )
            )
            return true
        else
            return false;
    }

    function startDay ( mm, yyyy ) {
        var firstDay = new Date( yyyy, mm, 1, 0, 0, 0, 0 )
        return firstDay.getDay()
    }

    function daysInMonth(mm, yyyy) {
        return 32 - new Date(yyyy, mm, 32).getDate();
    }

    function isSelectedDate(dd, mm, yyyy) {
        return ( selectedDate.getFullYear() == yyyy &&
                selectedDate.getMonth() == mm &&
                selectedDate.getDate() == dd )
    }

    function nextMonth(refDate) {
        if ( refDate.getMonth() == 11 )
            return 0
        else
            return refDate.getMonth() + 1
    }

    function prevMonth( refDate ) {
        if ( refDate.getMonth() == 0 )
            return 11
        else
            return refDate.getMonth() - 1
    }

    function getShortMonth(index) {
        var monName = new String(outer.shortMonths[index]) ;
        return monName;
    }

    function createDate( y, m, d ) {
        var dateVal = new Date( y, m, d );
        return dateVal;
    }

    function getTagValue(type,index) {
        var val;
        if( type == 1 ) {
            val = dModel.get(index).tag;
        } else if( type == 2 ) {
            val = mModel.get(index).tag;
        } else if( type == 3 ) {
            val = yModel.get(index).tag;
        }
        return val;
    }

    function setFuturePast() {
        var todaysDate = today()
        var selectedDay = selectedDate.getDate()
        var selectedMonth = selectedDate.getMonth()
        var selectedYear = selectedDate.getFullYear()
        var todaysDay = todaysDate.getDate()
        var todaysMonth = todaysDate.getMonth()
        var todaysYear = todaysDate.getFullYear()

        if( selectedYear > todaysYear ) {
            isFuture = true
            isPast = false
            return
        }else if( selectedYear == todaysYear ) {
            if( selectedMonth > todaysMonth ) {
                isFuture = true
                isPast = false
                return
            }else if ( selectedMonth == todaysMonth ) {
                if( selectedDay > todaysDay ) {
                    isFuture = true
                    isPast = false
                    return
                }else if( selectedDay == todaysDay ) {
                    isFuture = false
                    isPast = false
                    return
                }else{
                    isFuture = false
                    isPast = true
                }
            }
        }else {
            isFuture = false
            isPast = true
        }
    }

    function updateSelectedDate( d, m, y ) {
        if( allowUpdates ) {
            allowUpdates = false
        }else {
            return
        }

        dayButton.value = "1"
        monthButton.value = shortMonths[m]
        yearButton.value = y.toString()

        dayButton.reInit()
        monthButton.reInit()
        yearButton.reInit()

        changeDayModel( d, m, y )

        var newDay = setDays( d, m, y )
        dayButton.value = newDay.toString()
        dayButton.reInit()

        var tempDate = selectedDate
        tempDate.setDate(newDay)
        tempDate.setMonth(m)
        tempDate.setFullYear(y)
        selectedDate = tempDate
        calendarView.calendarShown = tempDate

        setFuturePast()
        allowUpdates = true
    }

    function setDays( d, m, y ) {
        var daysCount = daysInMonth( m, y )
        var retDay = d
        if( d > daysCount ) {
            retDay = daysCount
        }
        return retDay
    }
    function changeDayModel( d, m, y ){
        var daysCount = daysInMonth( m, y )
        if( dModel.count > daysCount ){
            while( dModel.count > daysCount ) {
                dModel.remove( dModel.count - 1 )
            }
        }else if( dModel.count < daysCount ) {
            for( var i = dModel.count; i < daysCount; i++ ) {
                dModel.append( { "tag": i + 1 } );
            }
        }
    }

    Component.onCompleted: { selectedDate = today(); }

    //when the DatePicker shows up, store the current date
    onShowCalled: {
        oldDate = selectedDate;
        updateSelectedDate( selectedDate.getDate(), selectedDate.getMonth(), selectedDate.getFullYear() )
    }

    //when the DatePicker is closed via cancel, restore the formerly selected date
    onRejected: { selectedDate = oldDate }

    onAccepted: { dateSelected( selectedDate ) }

    width: height * 0.6
    height: (topItem.topItem.height - topItem.topDecorationHeight) * 0.95    // ###

    title: qsTr("Due Date")

    aligneTitleCenter: true

    buttonWidth: width / 2.5

    content: BorderImage {
        id: outer

        anchors.fill: parent
        clip:  false
        source: "image://themedimage/popupbox_2"

        Image {
            id:titleDivider

            anchors { top: parent.top; left: parent.left; right: parent.right }
            source: "image://themedimage/menu_item_separator"
        } //end of titleDivider

        Row {
            id: popupRow

            property int unitWidth: ( parent.width - 2 * spacing - 2 * anchors.margins ) / 3 //width minus spacings divided by the number of units

            function checkMinMaxDate( date )
            {
                if( date.getFullYear() == maxYear ) {
                    // cut month

                    if( date.getMonth() == maxMonth ) {
                    } else {
                    }

                } else if( date.getFullYear() == maxYear )  {

                    inMaxYear = false
                    inMaxMonth = false
                    inMinYear = true
                    if( date.getMonth() == minMonth ) {
                        inMinMonth == true
                    } else {
                        inMinMonth == false
                    }

                } else {
                    inMinYear = false
                    inMaxYear = false
                    inMinMonth = false
                    inMaxMonth = false
                }
            }

            z: 10
            anchors { margins: 10; left: parent.left; top: titleDivider.bottom; right: parent.right }
            spacing: 10
            height: datePicker.height / 6 //110

            // pops up a list to choose a day
            PopupList {
                id: dayButton

                width:  parent.unitWidth
                height: parent.height
                popupListModel: dModel
                value: day

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = index + 1
                        var m = selectedDate.getMonth()
                        var y = selectedDate.getFullYear()
                        updateSelectedDate( d, m, y )
                    }
                }

            }

            // pops up a list to choose a month
            PopupList {
                id: monthButton

                width: parent.unitWidth
                height: parent.height
                popupListModel: mModel
                value: shortMonths[month]

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = selectedDate.getDate()
                        var m = index
                        var y = selectedDate.getFullYear()
                        updateSelectedDate( d, m, y )
                    }
                }
            }

            // pops up a list to choose a year
            PopupList {
                id: yearButton

                width: parent.unitWidth
                height: parent.height
                popupListModel: yModel
                value: year

                onValueSelected: {
                    if( allowUpdates ) {
                        var d = selectedDate.getDate()
                        var m = selectedDate.getMonth()
                        var y = getTagValue(3,index)
                        updateSelectedDate( d, m, y )
                    }
                }
            }
        } // date popups

        Item {
            id: calendarView

            property variant calendarShown: today() // points to a date for the currently shown calendar

            anchors { margins: 10; left: parent.left; top: popupRow.bottom;
                right: parent.right; bottom: todayButton.top}

            BorderImage {
                id: calBg

                anchors.fill: parent
                source:"image://themedimage/notificationBox_bg"
            }

            // displays the currently selected month and offers buttons to switch back and forth between months
            Item {
                id: monthHeader

                property int fontPixelSize

                fontPixelSize: if( theme.fontPixelSizeLarge < parent.height - 4 ) {
                                   return  theme.fontPixelSizeLarge
                               }else {
                                   return parent.height - 4
                               }
                anchors { left:parent.left; top:parent.top; right:parent.right }
                height: datePicker.height / 13 //prevMonthText.font.pixelSize + 30

                Text {
                    id: prevMonthText;

                    text: "<";
                    font.pixelSize: monthHeader.fontPixelSize; font.bold:  true
                    verticalAlignment: "AlignVCenter"; horizontalAlignment: "AlignHCenter"
                    anchors { left: parent.left; right: monthAndYear.left; top: parent.top; bottom: parent.bottom }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: updateSelectedDate( selectedDate.getDate(), prevMonth( selectedDate ), selectedDate.getFullYear() )//selectedDate = prevMonth( calendarView.calendarShown )//calendarView.calendarShown = prevMonth( calendarView.calendarShown )
                    }
                }
                Text {
                    id: monthAndYear

                    text: fullMonths[ calendarView.calendarShown.getMonth() ] + " " + calendarView.calendarShown.getFullYear()
                    font.pixelSize: monthHeader.fontPixelSize;
                    verticalAlignment: "AlignVCenter"; horizontalAlignment: "AlignHCenter"
                    anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
                    width: parent.width / 2
                }

                Text {
                    id: nextMonthText;

                    text: ">";
                    font.pixelSize: monthHeader.fontPixelSize; font.bold: true
                    verticalAlignment: "AlignVCenter"; horizontalAlignment: "AlignHCenter"
                    anchors { left: monthAndYear.right; right: parent.right; top: parent.top; bottom: parent.bottom }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: updateSelectedDate( selectedDate.getDate(), nextMonth( selectedDate ), selectedDate.getFullYear() )//selectedDate = nextMonth( calendarView.calendarShown )//calendarView.calendarShown = nextMonth( calendarView.calendarShown )
                    }
                }
            } // month-year header

            Image {
                id:monthDivider

                anchors { left: parent.left; right: parent.right; top: monthHeader.bottom }
                width: parent.width
                source: "image://themedimage/menu_item_separator"
            } //end of monthDivider

            // display the day names as some kind of column titles for the calendarGrid
            Item {
                id: dayLabel

                height: monthHeader.height * 0.5
                anchors { left: parent.left; right: parent.right; top: monthDivider.bottom; }

                Grid {
                    id: daysGrid

                    property int cellFontSize;

                    height: dayLabel.height
                    //font size is critical here because of little space, so it's reduced if necessary
                    cellFontSize: if( theme.fontPixelSizeMedium > calendarView.width/daysGrid.columns * 0.4 ){
                                      calendarView.width/daysGrid.columns * 0.4
                                  }else{
                                      theme.fontPixelSizeMedium
                                  }

                    anchors { left: parent.left; top: parent.top; right: parent.right }
                    rows: 1; columns: 7; spacing: 0

                    Repeater {
                        model: daysOfWeek
                        Text {
                            id: daysText
                            text: daysOfWeek[index]
                            horizontalAlignment: "AlignHCenter";
                            verticalAlignment: "AlignVCenter"
                            font.pixelSize: daysGrid.cellFontSize
                            width: calendarView.width / daysGrid.columns
                            height:  daysGrid.height
                        }
                    }
                }
            } // column labels

            Image {
                id: dayDivider

                anchors.top: dayLabel.bottom
                width: parent.width
                source: "image://themedimage/menu_item_separator"
            } //end of dayDivider

            Grid {
                id: calendarGrid

                property real cellGridWidth: width / columns
                property real cellGridHeight: height / rows
                property int cellFontSize;

                //font size is critical here because of little space, so reduce it if necessary
                cellFontSize: if( theme.fontPixelSizeLarge < cellGridHeight - 4 ){
                    return theme.fontPixelSizeLarge
                }else{
                    return cellGridHeight - 4
                }

                anchors { top: dayDivider.bottom;}
                width: calendarView.width;
                height:  parent.height - ( dayLabel.height + monthHeader.height + monthDivider.height + dayDivider.height )
                x: ( width - childrenRect.width ) * 0.5
                rows: 6; columns: 7; spacing: 0

                Repeater {
                    model: 42

                    Rectangle {
                        property bool doTag: isSelectedDate( calendarGrid.indexToDay(index),
                                                             calendarView.calendarShown.getMonth(),
                                                             calendarView.calendarShown.getFullYear())
                        property bool isToday: isCurrentDate( createDate( calendarGrid.indexToDay(index),
                                                                         calendarView.calendarShown.getMonth(),
                                                                         calendarView.calendarShown.getFullYear() ) )

                        border.width: ( calendarGrid.indexToDay(index) == -1 ) ? 1 : ( doTag ? 3 : 1 )
                        border.color: isToday ? theme.fontColorHighlight: theme.fontColorInactive

                        width: calendarGrid.cellGridWidth - ( doTag ? 1 : 0 )
                        height: calendarGrid.cellGridHeight - ( doTag ? 1 : 0 )
                        color: (doTag) ? "steelblue" : ( ( calendarGrid.indexToDay(index) == -1 ) ? "lightgray" : "white" )
                        opacity: ( calendarGrid.indexToDay( index) == -1 ) ? 0.25 : 1

                        Text {
                            text: calendarGrid.indexToDay(index)
                            font.pixelSize: calendarGrid.cellFontSize
                            anchors.centerIn: parent
                            visible: ( calendarGrid.indexToDay(index) != -1 )
                            color: isToday ? theme.fontColorHighlight: theme.fontColorNormal
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                var d = calendarGrid.indexToDay(index)
                                if ( d > 0 ) {
                                    updateSelectedDate( d, calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )
                                }
                            }
                        }
                    }
                }

                function indexToDay(index) {
                    var firstDay = startDay( calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )
                    var dayCount = daysInMonth( calendarView.calendarShown.getMonth(), calendarView.calendarShown.getFullYear() )

                    if ( index < firstDay ) return -1
                    if ( index >= firstDay + dayCount ) return -1

                    return ( index + 1 ) - firstDay
                }
            }//end grid
        } // calendar

        Item {
            id: todayButton

            anchors { left:parent.left; right: parent.right; bottom: parent.bottom; topMargin: 2; bottomMargin: 2 }
            height: datePicker.height / 16 //40

            Image {
                id:buttonDivider1

                anchors.top: parent.top
                width: parent.width
                source: "image://themedimage/menu_item_separator"
            } //end of buttonDivider1

            Text {
                id: todayText

                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: qsTr( "Go to todays date" );
                font.pixelSize: if( theme.fontPixelSizeLarge < height - 4 ) {
                                    return theme.fontPixelSizeLarge
                                }else {
                                    return height - 4
                                }

                color: "#33BBFF" //theme.fontColorHighlight
            }

            MouseArea {
                id: todayArea

                anchors.fill: todayButton

                onClicked: {
                    updateSelectedDate( today().getDate(), today().getMonth(), today().getFullYear() )
                }
            }
        }
    }

    function initializeDays(){
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        if ( dModel.count != daysInMonth( selectedDate.getMonth(), selectedDate.getFullYear() ) ) {
            dModel.clear(); // need to clear first since model changes with each month
            for ( var i = 0 ; i < daysInMonth( selectedDate.getMonth(), selectedDate.getFullYear() ); i++ ) {
               dModel.append( { "tag": i + 1 } );
            }
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }

    function setMonths() {
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        for ( var i = 0 ; i < shortMonths.length; i++ ) {
            mModel.append( { "tag": shortMonths[i] } );
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }

    function setYears() {
        dayButton.allowSignal = false
        monthButton.allowSignal = false
        yearButton.allowSignal = false
        for ( var i = minYear ; i < maxYear; i++ ) {
            yModel.append( { "tag": i } );
        }
        dayButton.allowSignal = true
        monthButton.allowSignal = true
        yearButton.allowSignal = true
    }    

    ListModel {
        id: dModel
        Component.onCompleted: {
            initializeDays()//setDays();
        }
    }

    ListModel {
        id: mModel
        Component.onCompleted: {
            setMonths();
        }
    }

    ListModel {
        id: yModel
        Component.onCompleted: {
            setYears();
        }
    }

    // need a placeholder to allow the real models to be generated and assigned later.
    ListModel {
        id: dummyListModel
        ListElement { tag: "0" }
    }

    TopItem { id: topItem }
    Theme { id: theme }
}
