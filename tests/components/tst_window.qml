/*!
    \page Test-Window
    \title Test-Window
    \unittest Test Window

    Units tests for the component \l { Window }

    \testcase Properties Check
    \testcm to be done \endtestcm

    \testcase Orientation
    \testcm Check the orienation of window changes according to the given orientation. \endtestcm

    \testcase ActionMenu
    \testcm to be done \endtestcm

    \testcase BookMenu
    \testcm to be done \endtestcm

    \todo ActionMenu tests
    \todo Framerate would be helpfull
    \todo how to automate the stack
    \todo I nee a SignalSpy for QmlSignals
*/

import Qt 4.7
import QtQuickTest 1.0
import MeeGo.Components 0.1

Window {
    id: window

    bookMenuModel: [ qsTr("Page1") , qsTr("Page2") ]
    bookMenuPayload: [ book1Component,  book2Component ]

    Component { id: book1Component; AppPage { id: page1 } }
    Component { id: book2Component; AppPage { id: page2 } }

    TestCase {
        id: testOrientation
        name: "test_WindowOrientation"

        function test_orientation() {

            //ck todo signalspy
            //ck todo from all states to all states
            console.log( "test orientation" )

            help_toPortrait();

            compare( qtest_compareInternal( window.inPortrait, true )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, false ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.window_content_topitem.width, qApp.screenHeight ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.window_content_topitem.height, qApp.screenWidth ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.window_content_topitem.rotation, -90 ), true, "rotation" );

            help_toLandscape();

            compare( qtest_compareInternal( window.inPortrait, false )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, true ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 0 ), true, "rotation" );

            help_toInvertedPortrait();

            compare( qtest_compareInternal( window.inPortrait, true )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, false ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenHeight ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenWidth ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 90 ), true, "rotation" );

            help_toInvertedLandscape();

            compare( qtest_compareInternal( window.inPortrait, false )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, true ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 180 ), true, "rotation" );

            help_toLandscape();

            compare( qtest_compareInternal( window.inPortrait, false )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, true ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 0 ), true, "rotation" );

            help_toInvertedPortrait();

            compare( qtest_compareInternal( window.inPortrait, true ) , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, false ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 90 ), true, "rotation" );

            help_toLandscape();

            compare( qtest_compareInternal( window.inPortrait, false )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, true ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, 0 ), true, "rotation" );

            help_toPortrait();

            compare( qtest_compareInternal( window.inPortrait, true )   , true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, false ) , true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, -90 ), true, "rotation" );

            help_toPortrait();

            compare( qtest_compareInternal( window.inPortrait, true ), true, "inPortrait" );
            compare( qtest_compareInternal( window.inLandscape, false ), true, "inLandscape" );
            //compare( qtest_compareInternal( window.width, qApp.screenWidth ), true, "screenHeight" );
            //compare( qtest_compareInternal( window.height, qApp.screenHeight  ), true, "screenWidth" );
            //compare( qtest_compareInternal( window.rotation, -90 ), true, "rotation" );

        }

        function help_toPortrait() {
            qApp.setOrientation( 2 );
            help_wait( 2 );
        }
        function help_toInvertedPortrait() {
            qApp.setOrientation( 0 );
            help_wait( 2 );
        }
        function help_toLandscape() {
            qApp.setOrientation( 1 );
            help_wait( 2 );
        }
        function help_toInvertedLandscape() {
            qApp.setOrientation( 3 );
            help_wait( 2 );
        }
    }

    TestCase {
        id: testProperties
        name: "test_WindowProperties"
        property string test1: "test1"
        property string test2: "test2"

        function test_properties() {

            console.log( "test properties" );

            console.log( "toolBarTitle" );
            window.toolBarTitle = test1;
            compare(qtest_compareInternal(window.toolBarTitle, test1), true);
            window.toolBarTitle = test2;
            compare(qtest_compareInternal(window.toolBarTitle, test1), false);
            compare(qtest_compareInternal(window.toolBarTitle, test2), true);

            console.log( "showToolBarSearch" )
            window.showToolBarSearch = true;
            compare(qtest_compareInternal(window.showToolBarSearch, true), true);
            window.showToolBarSearch = false;
            compare(qtest_compareInternal(window.showToolBarSearch, false), true);
            window.showToolBarSearch = true;
            compare(qtest_compareInternal(window.showToolBarSearch, true), true);

            console.log( "disableToolBarSearch" )
            window.disableToolBarSearch = true;
            compare(qtest_compareInternal(window.disableToolBarSearch, true), true);
            window.disableToolBarSearch = false;
            compare(qtest_compareInternal(window.disableToolBarSearch, false), true);
            window.disableToolBarSearch = true;
            compare(qtest_compareInternal(window.disableToolBarSearch, true), true);

            console.log( "actionMenuActive" )
            window.actionMenuActive = true;
            compare(qtest_compareInternal(window.actionMenuActive, true), true);
            window.actionMenuActive = false;
            compare(qtest_compareInternal(window.actionMenuActive, false), true);
            window.actionMenuActive = true;
            compare(qtest_compareInternal(window.actionMenuActive, true), true);

            console.log( "fullScreen" )
            window.fullScreen = true;
            compare(qtest_compareInternal(window.fullScreen, true), true);
            window.fullScreen = false;
            compare(qtest_compareInternal(window.fullScreen, false), true);
            window.fullScreen = true;
            compare(qtest_compareInternal(window.fullScreen, true), true);

            console.log( "inPortrait" )
            window.inPortrait = true;
            compare(qtest_compareInternal(window.inPortrait, true), true);
            window.inPortrait = false;
            compare(qtest_compareInternal(window.inPortrait, false), true);
            window.inPortrait = true;
            compare(qtest_compareInternal(window.inPortrait, true), true);

            console.log( "inLandscape" )
            window.inLandscape = true;
            compare(qtest_compareInternal(window.inLandscape, true), true);
            window.inLandscape = false;
            compare(qtest_compareInternal(window.inLandscape, false), true);
            window.inLandscape = true;
            compare(qtest_compareInternal(window.inLandscape, true), true);

            console.log( "inPortrait" )
            window.inPortrait = true;
            compare(qtest_compareInternal(window.inPortrait, true), true);
            window.inPortrait = false;
            compare(qtest_compareInternal(window.inPortrait, false), true);
            window.inPortrait = true;
            compare(qtest_compareInternal(window.inPortrait, true), true);

        }
    }


    TestEvent {
        id: testEvent
    }

    // Mockup
    Item {
        id: qApp

        signal orientationChanged;
        property int orientation: 1
        property int screenHeight: 768
        property int screenWidth: 1300

        function setOrientation( newOrientation) {
            console.log( "orientation: " + newOrientation)
            orientation = newOrientation
            qApp.orientationChanged();
        }

    }

    function help_wait( seconds ) {

        var time = new Date()
        var overtheminute = false
        var ms = ( time.getSeconds() + seconds ) % 60;
        var msnow = time.getSeconds();
        if( ms < msnow )
            overtheminute = true;

        while( overtheminute || msnow < ms )
        {
            time = new Date();
            msnow = time.getSeconds();

            if(overtheminute && msnow > 0 && msnow < 10)
                overtheminute = false;

        }
    }
}
