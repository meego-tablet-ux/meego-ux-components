/*!
    \page Test-PageStack
    \title Test-PageStack
    \unittest Test PageStack

    Units tests for the component \l { PageStack }

    \testcase Push and Pop
    \testcm different push and pop scenaries \endtestcm

    \testcase Push and Clear
    \testcm different push and clear scenaries \endtestcm

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
        id: test_PageStack_PushAndPop
        name: "test_PageStack_PushAndPop"

        function test_PageStack_PushAndPop() {

            window.switchBook( book1Component );
            help_PushAndPop( 10 );

        }

        function test_PageStack_PushAndPop_Medium() {

            window.switchBook( book1Component );
            help_PushAndPop( 100 );

        }        
        function test_PageStack_PushAndPop_Large() {

            window.switchBook( book1Component );
            help_PushAndPop( 500 );
        }
    }


    TestCase {
        id: test_PageStack_PushAndClear
        name: "test_PageStack_PushAndClear"

        function test_PageStack_PushAndClear() {

            window.switchBook( book1Component );
            help_PushAndPop( 10 );
            window.switchBook( book2Component );
        }

        function test_PageStack_PushAndClear_Medium() {

            window.switchBook( book1Component );
            help_PushAndPop( 100 );
            window.switchBook( book2Component );

        }
        function test_PageStack_PushAndClear_Large() {

            window.switchBook( book1Component );
            help_PushAndPop( 500 );
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

    function help_PushAndPop( size )
    {
        var pageStack = [];
        var i;

        for (i = 0; i < size; i++) {

        }
        help_wait( 1 );
        for (i = size; i > 0; i--) {

        }
    }

    function help_Push( size )
    {
        var pageStack = [];
        var i;

        for (i = 0; i < size; i++) {

        }
        help_wait( 1 );
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
