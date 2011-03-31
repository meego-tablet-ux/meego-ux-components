/*!
    \page Test-ModalDialog
    \title Test-ModalDialog
    \unittest Test ModalDialog

    This is the unit test of \l { ModalDialog }. Some unit tests are
    done in \l { ModalFog }, which is the base component of ModalDialog

    \testcase Properties Check
    \testcm Consitency check of all regular API Properties \endtestcm

    \testcase Buttons Test
    \testcm Test of different Button combinations \endtestcm

    \testcase Button Row Test
    \testcm To be done \endtestcm

    \testcase Content Test
    \testcm To be done \endtestcm

    \testcase MouseClick Tests
    \testcm To be done \endtestcm

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

    ModalDialog {

        anchors.centerIn: parent

        id: modalDialog
        autoCenter: true

        width: 400
        height: 400

    }

    TestCase {
        id: test_ModalDialog_Properties
        name: "test_ModalDialog_Properties"

        property string cancelText1: "cancel1"
        property string cancelText2: "cancel2"
        property string acceptText1: "accept1"
        property string acceptText2: "accept2"
        property int int1: 20
        property int int2: 200

        function test_ModalDialog_Properties() {

            modalDialog.show();
            help_wait( 1 );

            modalDialog.showCancelButton = true;
            compare( qtest_compareInternal( modalDialog.showCancelButton, true ) , true, "showCancelButton" );
            modalDialog.showCancelButton = false;
            compare( qtest_compareInternal( modalDialog.showCancelButton, false ) , true, "showCancelButton" );
            modalDialog.showCancelButton = true;
            compare( qtest_compareInternal( modalDialog.showCancelButton, true ) , true, "showCancelButton" );

            modalDialog.showAcceptButton = true;
            compare( qtest_compareInternal( modalDialog.showAcceptButton, true ) , true, "showAcceptButton" );
            modalDialog.showAcceptButton = false;
            compare( qtest_compareInternal( modalDialog.showAcceptButton, false ) , true, "showAcceptButton"  );
            modalDialog.showAcceptButton = true;
            compare( qtest_compareInternal( modalDialog.showAcceptButton, true ) , true, "showAcceptButton"  );

            modalDialog.cancelButtonActive = true;
            compare( qtest_compareInternal( modalDialog.cancelButtonActive, true ) , true, "cancelButtonActive"  );
            modalDialog.cancelButtonActive = false;
            compare( qtest_compareInternal( modalDialog.cancelButtonActive, false ) , true, "cancelButtonActive" );
            modalDialog.cancelButtonActive = true;
            compare( qtest_compareInternal( modalDialog.cancelButtonActive, true ) , true, "cancelButtonActive" );

            modalDialog.acceptButtonActive = true;
            compare( qtest_compareInternal( modalDialog.acceptButtonActive, true ) , true, "acceptButtonActive" );
            modalDialog.acceptButtonActive = false;
            compare( qtest_compareInternal( modalDialog.acceptButtonActive, false ) , true, "acceptButtonActive" );
            modalDialog.acceptButtonActive = true;
            compare( qtest_compareInternal( modalDialog.acceptButtonActive, true ) , true, "acceptButtonActive" );

            modalDialog.cancelButtonText = cancelText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonText, cancelText1 ) , true, "cancelButtonText" );
            modalDialog.cancelButtonText = cancelText2;
            compare( qtest_compareInternal( modalDialog.cancelButtonText, cancelText2 ) , true, "cancelButtonText" );
            modalDialog.cancelButtonText = cancelText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonText, cancelText1 ) , true, "cancelButtonText" );

            modalDialog.acceptButtonText = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonText, acceptText1 ) , true, "acceptButtonText" );
            modalDialog.acceptButtonText = acceptText2;
            compare( qtest_compareInternal( modalDialog.acceptButtonText, acceptText2 ) , true, "acceptButtonText" );
            modalDialog.acceptButtonText = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonText, acceptText1 ) , true, "acceptButtonText" );

            modalDialog.title = acceptText1;
            compare( qtest_compareInternal( modalDialog.title, acceptText1 ) , true, "title" );
            modalDialog.title = acceptText2;
            compare( qtest_compareInternal( modalDialog.title, acceptText2 ) , true, "title" );
            modalDialog.title = acceptText1;
            compare( qtest_compareInternal( modalDialog.title, acceptText1 ) , true, "title" );

            modalDialog.aligneTitleCenter = true
            compare( qtest_compareInternal( modalDialog.aligneTitleCenter, true ) , true, "aligneTitleCenter" );
            modalDialog.aligneTitleCenter = false;
            compare( qtest_compareInternal( modalDialog.aligneTitleCenter, false ) , true, "aligneTitleCenter" );
            modalDialog.aligneTitleCenter = true;
            compare( qtest_compareInternal( modalDialog.aligneTitleCenter, true ) , true, "aligneTitleCenter" );

            modalDialog.cancelButtonImage = acceptText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonImage, acceptText1 ) , true, "cancelButtonImage" );
            modalDialog.cancelButtonImage = acceptText2;
            compare( qtest_compareInternal( modalDialog.cancelButtonImage, acceptText2 ) , true, "cancelButtonImage" );
            modalDialog.cancelButtonImage = acceptText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonImage, acceptText1 ) , true, "cancelButtonImage" );

            modalDialog.cancelButtonImagePressed = acceptText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonImagePressed, acceptText1 ) , true, "cancelButtonImagePressed" );
            modalDialog.cancelButtonImagePressed = acceptText2;
            compare( qtest_compareInternal( modalDialog.cancelButtonImagePressed, acceptText2 ) , true, "cancelButtonImagePressed" );
            modalDialog.cancelButtonImagePressed = acceptText1;
            compare( qtest_compareInternal( modalDialog.cancelButtonImagePressed, acceptText1 ) , true, "cancelButtonImagePressed" );

            modalDialog.acceptButtonImage = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonImage, acceptText1 ) , true, "acceptButtonImage" );
            modalDialog.acceptButtonImage = acceptText2;
            compare( qtest_compareInternal( modalDialog.acceptButtonImage, acceptText2 ) , true, "acceptButtonImage" );
            modalDialog.acceptButtonImage = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonImage, acceptText1 ) , true, "acceptButtonImage" );

            modalDialog.acceptButtonImagePressed = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonImagePressed, acceptText1 ) , true, "acceptButtonImagePressed" );
            modalDialog.acceptButtonImagePressed = acceptText2;
            compare( qtest_compareInternal( modalDialog.acceptButtonImagePressed, acceptText2 ) , true, "acceptButtonImagePressed" );
            modalDialog.acceptButtonImagePressed = acceptText1;
            compare( qtest_compareInternal( modalDialog.acceptButtonImagePressed, acceptText1 ) , true, "acceptButtonImagePressed");

            modalDialog.buttonWidth = int1;
            compare( qtest_compareInternal( modalDialog.buttonWidth, int1 ) , true, "buttonWidth" );
            modalDialog.buttonWidth = int2;
            compare( qtest_compareInternal( modalDialog.buttonWidth, int2 ) , true, "buttonWidth" );
            modalDialog.buttonWidth = int1;
            compare( qtest_compareInternal( modalDialog.buttonWidth, int1 ) , true, "buttonWidth" );

            modalDialog.buttonHeight = int1;
            compare( qtest_compareInternal( modalDialog.buttonHeight, int1 ) , true, "buttonHeight" );
            modalDialog.buttonHeight = int2;
            compare( qtest_compareInternal( modalDialog.buttonHeight, int2 ) , true, "buttonHeight" );
            modalDialog.buttonHeight = int1;
            compare( qtest_compareInternal( modalDialog.buttonHeight, int1 ) , true, "buttonHeight" );

        }
    }

    TestCase {
        id: test_ModalDialog_Buttons
        name: "test_ModalDialog_Buttons"

        function test_ModalDialog_Buttons() {
            console.log( "todo" )
        }

    }

    TestCase {
        id: test_ModalDialog_ButtonRow
        name: "test_ModalDialog_ButtonRow"

        function test_ModalDialog_ButtonRow() {
            console.log( "todo" )
        }

    }

    TestCase {
        id: test_ModalDialog_Content
        name: "test_ModalDialog_Content"

        function test_ModalDialog_Content() {
            console.log( "todo" )
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
