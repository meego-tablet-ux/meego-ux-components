 
/*!
    \page Test-themeimageprovider
    \title Test-themeimageprovider
    \unittest Test themeimageprovider

    Units tests for the \l { themeimageprovider }

    \testcase test image loading
    \testcm switches the source of an image multiple times and checks the
            image status to see if each source has been properly loaded.
            Also checks if the border, width and height values match the
            .sci and .png files of the image. \endtestcm


*/

import Qt 4.7
import QtQuickTest 1.0
import MeeGo.Ux.Components.Common 0.1
import MeeGo.Ux.Kernel 0.1

Item {
    id: item

    ThemeImage {
        id: image

        source: "image://themedimage/widgets/common/button/button-default"
    }

    TestCase {
        id: test_image_loading
        name: "test_themeimageprovider_imageLoading"

        function test_switch_sources() {
            image.source = "image://themedimage/widgets/common/button/button-default-pressed"
            compare( image.status, Image.Ready, "first image source switch failed" )
            image.source = "image://themedimage/widgets/common/button/button-negative"
            compare( image.status, Image.Ready, "second image source switch failed" )
            image.source = "image://themedimage/widgets/common/button/button-negative-pressed"
            compare( image.status, Image.Ready, "third image source switch failed" )
            image.source = "image://themedimage/widgets/common/button/button-default"
            compare( image.status, Image.Ready, "fourth image source switch failed" )
        }

        //values taken from button-default.sci
        function test_checkImageBorders() {
            compare( image.border.left, 11, "left image border doesn't match" )
            compare( image.border.top, 9, "top image border doesn't match" )
            compare( image.border.bottom, 12, "bottom image border doesn't match" )
            compare( image.border.right, 11, "right image border doesn't match" )
        }

        //values taken from button-default.png
        function test_checkImageSize() {
            compare( image.width, 106, "image width doesn't match" )
            compare( image.height, 35, "image height doesn't match" )
        }
    }
}
