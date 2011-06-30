/*!
    \page Test-ThemeImage
    \title Test-ThemeImage
    \unittest Test ThemeImage

    Units tests for the component \l { ThemeImage }

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

Rectangle {
    id: rect

    width: qApp.screenWidth
    height: qApp.screenHeight

    property string simpleImage:   "simpleImage.png"
    property string sciImage:      "sciImage.sci"
    property string wrongImage:    "YUNOIMAGE.png"
    property string defaultImage:  "defaultImage.sci"
    property string rightImage:    "sciImage.sci"
    property string firstImage:    "firstImage.sci"
    property string secondImage:   "secondImage.sci"
    
    TestCase {
        id: loadSimple
        name: "test_ThemeImage_loadSimpleImage"
        
        ThemeImage {
            id: loadSimpleImage

            anchors.fill: rect
            source: simpleImage

        }

        function test_ThemeImage_Properties() {

            compare( qtest_compareInternal( loadSimpleImage.source, simpleImage ), true);

        }

    }

    TestCase {
        id: loadSciFile
        name: "test_ThemeImage_loadBorderImage"

        ThemeImage {
            id: loadBorderImage

            anchors.fill: rect
            source: sciImage

        }


        function test_ThemeImage_Properties() {

            compare( qtest_compareInternal( loadBorderImage.source, sciImage ), true);

        }

    }

    TestCase {
        id: loadDefaultSource
        name: "test_ThemeImage_loadDefaultImage"

        ThemeImage {
            id: loadDefaultSourceImage

            anchors.fill: rect
            source: wrongImage
            defaultSource: rightImage;

        }


        function test_ThemeImage_Properties() {

            compare( qtest_compareInternal( loadDefaultSourceImage.source, rightImage ), true);

        }

    }
    
    TestCase {
        id: loadScriptedSource
        name: "test_ThemeImage_loadScriptedSource"

        property bool test: false

        ThemeImage {
            id: loadScriptedSourceImage

            anchors.fill: rect
            source: test ? firstImage : secondImage

        }

        function test_ThemeImage_Properties() {

            compare( qtest_compareInternal( loadScriptedSourceImage.source, secondImage ), true);

            help_wait( 1 )

            loadScriptedSource.test = true;

            compare( qtest_compareInternal( loadScriptedSourceImage.source, firstImage ), true);

            loadScriptedSourceImage.source = secondImage;

            compare( qtest_compareInternal( loadScriptedSourceImage.source, secondImage ), true);

        }
    }

    TestCase {
        id: testIsValidFlag
        name: "test_ThemeImage_testIsValidFlag"

        ThemeImage {
            id: testIsValidFlagImage

            anchors.fill: rect
            source: wrongImage;

            onIsValidSourceChanged: {

                if( !isValidSourceChanged )
                    source = rightImage;

            }
        }

        function test_ThemeImage_Properties() {

            compare( qtest_compareInternal( testIsValidFlagImage.source, rightImage ), true);

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
