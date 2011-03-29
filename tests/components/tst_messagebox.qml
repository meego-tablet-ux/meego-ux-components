/*!
    \page Test-ModalMessageBox
    \title Test-ModalMessageBox
    \unittest Test ModalMessageBox

    Unit test of component: \l { ModalMessageBox }. Most of the
    test cases will be don in the base component \l { ModalDialog }.

    \testcase Properties Check
    \testcm Check of all regular API Properties \endtestcm

    \testcase show ModalMessageBox
    \testcm to be done \endtestcm

    \testcase close ModalMessageBox
    \testcm to be done \endtestcm

    \testcase accept ModalMessageBox
    \testcm to be done \endtestcm

    \testcase reject ModalMessageBox
    \testcm to be done \endtestcm

    \testcase move ModalMessageBox
    \testcm to be done \endtestcm

    \testcase resize ModalMessageBox
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

    ModalMessageBox {
        id: messageBox

        width: 600
        height: 400

        showCancelButton: true
        showAcceptButton: true

        cancelButtonActive: true
        acceptButtonActive: true
    }

    TestCase {
        id: test_MessageBox_Properties
        name: "test_MessageBox_Properties"

        property string message1: "message1 message1 message1 message1 message1 "
        property string message2: "message2 message2 message2 message2 message2 "
        property string message3: "message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 message3 "
        property string title1: "title1"
        property string title2: "title2"
        property string title3: "title3 title3 title3 title3 title3 title3 title3 title3 title3 "

        function test_MessageBox_Properties() {

            messageBox.title = title1;
            compare(qtest_compareInternal(messageBox.title, title1), true);

            messageBox.title = title2;
            compare(qtest_compareInternal(messageBox.title, title2), true);

            messageBox.title = title3;
            compare(qtest_compareInternal(messageBox.title, title3), true);

            messageBox.title = title1;
            compare(qtest_compareInternal(messageBox.title, title1), true);

            messageBox.text = message1;
            compare(qtest_compareInternal(messageBox.text, message1), true);

            messageBox.text = message2;
            compare(qtest_compareInternal(messageBox.text, message2), true);

            messageBox.text = message3;
            compare(qtest_compareInternal(messageBox.text, message3), true);

            messageBox.text = message1;
            compare(qtest_compareInternal(messageBox.text, message1), true);

        }
    }

    TestCase {
        id: test_MessageBox_ShowHide
        name: "test_MessageBox_Properties"

        function test_MessageBox_ShowHide() {
            console.log( "todo" );
        }
    }

    TestCase {
        id: test_MessageBox_Accept
        name: "test_MessageBox_Properties"

        function test_MessageBox_Accept() {
             console.log( "todo" );
        }
    }

    TestCase {
        id: test_MessageBox_Reject
        name: "test_MessageBox_Properties"

        function test_MessageBox_Reject() {
            console.log( "todo" );
        }
    }

    TestCase {
        id: test_MessageBox_Message
        name: "test_MessageBox_Message"

        function test_MessageBox_Message() {
            console.log( "todo" );
        }
    }

    TestCase {
        id: test_MessageBox_Buttons
        name: "test_MessageBox_buttons"

        function test_MessageBox_Buttons() {

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
