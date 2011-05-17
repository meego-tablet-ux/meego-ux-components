/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
   \qmlclass ThemeBorderImage
   \title ThemeBorderImage
   \section1 ThemeBorderImage
   This is a workaround for settings also the border pixels of a BorderImage by the Theme.
      
  \section2 Example
  \qml
      ThemeBorderImage {
         id: image

         source: "image://myProvider/image";
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

BorderImage {

    id: container

    border.bottom:  themeImageBorder.borderBottom;
    border.top:     themeImageBorder.borderTop;
    border.left:    themeImageBorder.borderLeft
    border.right:   themeImageBorder.borderRight;

    ThemeImageBorder { // from kernel
	id: themeImageBorder
    }

}

