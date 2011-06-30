/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ThemeImage
   \title ThemeImage
   \section1 ThemeImage
   This component is derived from BorderImage and contains some functions that are usefull when using meego-ux-components and meego-ux theme.
   
   \section2 General API
   see BorderImage.qml
   
   \section2  API properties
      \qmlproperty property alias defaultSource: themeImageBorder.defaultSource
      The defaultSource will be loaded if the source could not be found.
      
      \qmlproperty property alias isValidSource: themeImageBorder.isValidSource
      determines if the source and the defaultSource strings are valid.
      
  \section2  Signals
      \qmlnone

  \section2 Functions
      \qmlnone

  \section2 Example
  \qml
      ThemeImage {
         id: image

         source: "image://myProvider/image";
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Ux.Kernel 0.1
import MeeGo.Components 0.1

BorderImage {

    id: container

    border.bottom:  themeImageBorder.borderBottom;
    border.top:     themeImageBorder.borderTop;
    border.left:    themeImageBorder.borderLeft
    border.right:   themeImageBorder.borderRight;

    property alias defaultSource: themeImageBorder.defaultSource
    property alias isValidSource: themeImageBorder.isValidSource

    ThemeImageBorder { // from kernel
        id: themeImageBorder

        Component.onCompleted: {
	    if( themeImageBorder.needReplacement )
	      container.source = themeImageBorder.source;
	    
        }
        onSourceChanged: {
	    if( themeImageBorder.needReplacement )
	      container.source = themeImageBorder.source;
        }
    }

    Component.onCompleted: {
        container.sourceSizeChanged( container.sourceSize )
    }
    onSourceChanged: {
        themeImageBorder.source = source
    }
}

