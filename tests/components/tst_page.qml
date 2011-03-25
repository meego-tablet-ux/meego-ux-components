/*!
    \page Test-AppPage
    \title Test-AppPage
    \unittest Test AppPage

    This is Unit tests of the \l { AppPage }

    \testcase Properties Check
    \testcm Checking of regular API Properties. \endtestcm

    \testcase show AppPage
    \testcm to be done \endtestcm

    \testcase close AppPage
    \testcm to be done \endtestcm

*/

import Qt 4.7
import QtQuickTest 1.0
import Otc.Components 0.1

Window {
    id: window

    bookMenuModel: [ qsTr("Page1") , qsTr("Page2") ]
    bookMenuPayload: [ book1Component,  book2Component ]

    Component { id: book1Component; AppPage { id: page1 } }
    Component { id: book2Component; AppPage { id: page2 } }

    TestCase {
        id: test_AppPage_Properties
        name: "test_AppPage_Properties"

        property string title1: "t1"
        property string title2: "t2"

        function test_AppPage_Properties()
        {
            var page1 = book1Component.createObject( window );

            page1.pageTitle = title1;
            compare( qtest_compareInternal( title1 , page1.pageTitle )   , true, "pageTitle" );
            page1.pageTitle = title2;
            compare( qtest_compareInternal( title2 ,  page1.pageTitle )   , true, "pageTitle" );

            page1.actionMenuModel = [ "1", "2", "3" ];
            page1.actionMenuPayload = [ "1", "2", "3" ];

            compare( qtest_compareInternal(  page1.actionMenuModel.length ,  3 )  , true, "actionMenuModel" );
            compare( qtest_compareInternal(  page1.actionMenuPayload.length , 3 ) , true, "actionMenuPayload" );

            page1.enableCustomActionMenu = false;
            compare( qtest_compareInternal( page1.enableCustomActionMenu ,  false )   , true, "enableCustomActionMenu" );
            page1.enableCustomActionMenu = true;
            compare( qtest_compareInternal( page1.enableCustomActionMenu ,  true )   , true, "enableCustomActionMenu" );
        }
    }

    TestCase {
        id: test_show_AppPage
        name: "test_show_AppPage"

        function test_show_AppPage()
        {
            window.switchBook( book1Component );
            window.switchBook( book2Component );
        }
    }

    TestCase {
        id: test_close_AppPage
        name: "test_close_AppPage"

        function test_close_AppPage()
        {
            window.switchBook( book1Component );
            window.switchBook( book2Component );
        }
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
