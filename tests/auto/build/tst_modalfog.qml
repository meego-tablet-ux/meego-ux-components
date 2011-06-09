/*!
    \page Test-ModalFog
    \title Test-ModalFog
    \unittest Test ModalFog

    Units tests for the component \l { ModalFog }

    \testcase Properties Check
    \testcm to be done \endtestcm

    \testcase show ModalFog
    \testcm to be done \endtestcm

    \testcase close ModalFog
    \testcm to be done \endtestcm

    \testcase accept ModalFog
    \testcm to be done \endtestcm

    \testcase reject ModalFog
    \testcm to be done \endtestcm

    \testcase move ModalFog
    \testcm to be done \endtestcm

    \testcase resize ModalFog
    \testcm to be done \endtestcm

*/


import Qt 4.7
import QtQuickTest 1.0
import MeeGo.Components 0.1

Rectangle {

    id: rect

    height: 750
    width: 850
    anchors.centerIn: parent
    color: "white"

    ModalFog {

        anchors.centerIn: parent

        id: modalFog
        autoCenter: true
        fogClickable: true

        modalSurface: Rectangle {
            id: content
            width: 500
            height: 500
            color: "red"
        }
    }

    TestCase {
        id: test_ModalFog_Properties
        name: "test_ModalFog_Properties"

        function test_ModalFog_Properties() {

            help_wait( 1 );
            console.log( "autoCenter" );
            modalFog.autoCenter = false;
            compare( qtest_compareInternal( modalFog.autoCenter, false ) , true );
            modalFog.autoCenter = true;
            compare( qtest_compareInternal( modalFog.autoCenter, true ) , true );

            console.log( "fogClickable" )
            modalFog.fogClickable = false;
            compare( qtest_compareInternal( modalFog.fogClickable, false ) , true );
            modalFog.fogClickable = true;
            compare( qtest_compareInternal( modalFog.fogClickable, true ) , true );

            console.log( "fogMaskVisible" )
            modalFog.fogMaskVisible = false;
            compare( qtest_compareInternal( modalFog.fogMaskVisible, false ) , true );
            modalFog.fogMaskVisible = true;
            compare( qtest_compareInternal( modalFog.fogMaskVisible, true ) , true );
        }
    }

    TestCase {
        id: test_ModalFog_ShowHide
        name: "test_ModalFog_ShowHide"

        function test_ModalFog_ShowHide() {

            //ck is not working as desired
            modalFog.show();
            help_wait( 2 );
            compare( qtest_compareInternal( modalFog.visible, true ) , true, "visibility ModalFog" );

            modalFog.hide();
            help_wait( 2 );
            compare( qtest_compareInternal( modalFog.visible, false ) , true, "visibility ModalFog" );

            modalFog.show();
            help_wait( 2 );
            compare( qtest_compareInternal( modalFog.visible, true ) , true, "visibility ModalFog" );
        }
    }

    TestCase {
        id: test_ModalFog_Content
        name: "test_ModalFog_Content"

        function test_ModalFog_ChangeContent() {

            modalFog.show();
            help_wait( 2 );

            content.width = 450
            content.height = 451

            compare( qtest_compareInternal( content.width, 450 ) , true );
            compare( qtest_compareInternal( content.height, 451 ) , true );

            modalFog.hide();
            help_wait( 2 );

        }

        function test_ModalFog_SetContent() {
            console.log( "todo" )
        }

    }


    TestCase {
        id: test_ModalFog_Clicks
        name: "test_ModalFog_Clicks"

        function test_ModalFog_ClickOnFog() {

            modalFog.fogClickable = true;

            modalFog.show();
            help_wait( 2 );
//            compare( qtest_compareInternal( modalFog.visible, true ) , true );

            testEvent.mouseClick( modalFog, 10, 10, 0, 0, 0)

            help_wait( 2 );            
  //          compare( qtest_compareInternal( modalFog.visible, false ) , true );

            modalFog.fogClickable = false;
            modalFog.show();
            help_wait( 2 );

            testEvent.mouseClick( modalFog, 10, 10, 0, 0, 0)

            help_wait( 2 );            
    //        compare( qtest_compareInternal( modalFog.visible, false ) , false );

        }

        function test_ModalFog_ClickOnContent() {

            modalFog.show();
            help_wait( 2 );
            compare( qtest_compareInternal( modalFog.visible, true ) , true );

            testEvent.mouseClick( content, 10, 10, 0, 0, 0)

            help_wait( 2 );
            compare( qtest_compareInternal( modalFog.visible, true ) , true );
        }
    }

    TestCase {
        id: test_ModalFog_Move
        name: "test_ModalFog_Move"

        function test_ModalFog_Move() {
            console.log( "todo" );
        }
    }

    TestEvent {
        id: testEvent
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
