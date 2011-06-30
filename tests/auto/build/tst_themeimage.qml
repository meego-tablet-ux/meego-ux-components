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
import MeeGo.Ux.Kernel 0.1
import MeeGo.Ux.Components.Common 0.1

Item {
    id: item

    width: qApp.screenWidth
    height: qApp.screenHeight

    property string simpleImage:   "image://themedimage/widgets/common/button/button-default-pressed"
    property string sciImage:      "image://themedimage/widgets/common/button/button-default-pressed"
    property string wrongImage:    "YUNOIMAGE.png"
    property string defaultImage:  "image://themedimage/widgets/common/button/button-negative"
    property string rightImage:    "image://themedimage/widgets/common/button/button-default-pressed"
    property string firstImage:    "image://themedimage/widgets/common/button/button-default-pressed"
    property string secondImage:   "image://themedimage/widgets/common/button/button-negative"

    ThemeImage {
        id: loadSimpleImage
        source: simpleImage
    }

    TestCase {
	id: loadSimple
	name: "test_ThemeImage_loadSimpleImage"

	function test_ThemeImage_loadSimpleImage() {

	    compare( qtest_compareInternal( loadSimpleImage.source, simpleImage ), true );

	}
    }

    ThemeImage {
        id: loadBorderImage
        source: sciImage
    }

    TestCase {
	id: loadSciFile
	name: "test_ThemeImage_loadBorderImage"

	function test_ThemeImage_loadBorderImage() {

	    compare( qtest_compareInternal( loadBorderImage.source, sciImage ), true);

	}
    }

    ThemeImage {
        id: loadDefaultSourceImage
        source: wrongImage
        defaultSource: rightImage

        TestCase {
            id: loadDefaultSource
            name: "test_ThemeImage_loadDefaultImage"

            function test_ThemeImage_loadDefaultImage() {

                compare( qtest_compareInternal( loadDefaultSourceImage.source, rightImage ), true);

            }
        }

    }


    ThemeImage {
        id: loadScriptedSourceImage
        property bool test: false
        source: test ? firstImage : secondImage
    }

    TestCase {
	id: loadScriptedSource
	name: "test_ThemeImage_loadScriptedSource"

	function test_ThemeImage_loadScriptedSource() {

	    compare( qtest_compareInternal( loadScriptedSourceImage.source, secondImage ), true);

	    help_wait( 1 )

	    loadScriptedSourceImage.test = true;

	    compare( qtest_compareInternal( loadScriptedSourceImage.source, firstImage ), true);

	    loadScriptedSourceImage.source = secondImage;

	    compare( qtest_compareInternal( loadScriptedSourceImage.source, secondImage ), true);

	}
    }

    ThemeImage {
        id: testIsValidFlagImage
        source: wrongImage

        Component.onCompleted: {
            if( !isValidSource )
                source = rightImage;

        }
    }

    TestCase {
        id: testIsValidFlag
        name: "test_ThemeImage_testIsValidFlag"

        function test_ThemeImage_testIsValidFlag() {

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
