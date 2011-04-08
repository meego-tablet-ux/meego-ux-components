/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/*!
  \qmlclass TopItem
  \title TopItem
  \section1 TopItem
  The TopItem follows the parent properties to the top most item.
  The top most item's dimensions can be accessed via topWidth and
  topHeight. It is recommended to call calcTopParent() before the
  values are accessed to ensure the top most item is referenced.

  \section2 API properties
      \qmlproperty Item topItem
      \qmlcm the top most item.

      \qmlproperty int topWidth
      \qmlcm the top most item's width.

      \qmlproperty int topHeight
      \qmlcm the top most item's height.

  \section2 Private Properties
  \qmlnone

  \section2 Signals
  \qmlfn orientationChangeFinished
  \qmlcm is sent when the orientation has changed.

  \qmlfn geometryChanged
  \qmlcm is sent when the geometry has changed
        \param real newWidth
        \qmlpcm the new width \endparam
        \param real newHeight
        \qmlpcm the new height \endparam

  \section2 Functions
      \qmlfn calcTopParent
      \qmlcm  searches the top most object of type Window and stores
             it in the property topItem. If no object of type Window
             is found, the top most object is stored instead.

  \section2 Example
  \qml  
      Rectangle {
         id: exampleRect

         width: topItem.topWidth * 0.5
         height: topItem.topheight * 0.5

         TopItem { id: topItem }

         Component.onCompleted: {
             topItem.calcTopParent()
         }
      }
  \endqml
*/

import Qt 4.7
import MeeGo.Components 0.1

Item {
    id: top

    //This should be read only, but not possible currently in QML...
    //See http://bugreports.qt.nokia.com/browse/QTBUG-15257
    property Item topItem: null
    property int topWidth: 0
    property int topHeight: 0
    property int topDecorationHeight

    signal orientationChangeFinished()
    signal geometryChanged( real newWidth, real newHeight )

    topDecorationHeight: {
       try {
            if (window.topDecorationHeight == undefined)
                return 0;
            else
                return window.topDecorationHeight;
        }
        catch(err){
            return 0;
        }
    }

    function calcTopParent() {
        var p = top;
        var lastp;
        while(p) {
            if(p.toString().indexOf("Window_QMLTYPE") == 0) {
                topItem = lastp;//.content;		
                break;
            }
            lastp = p;
            p = p.parent;
        }
        //Try to fallback to the last valid item, if we don't find a window type...
        if (!p) 
	{	    
            topItem = lastp;
	}

        topWidth = topItem.width
        topHeight = topItem.height
    }

    Connections {
        target: topItem

        onWidthChanged: {
            top.calcTopParent()
            geometryChanged( top.topWidth, top.topHeight )
            console.log("================== ping")
        }
        onHeightChanged: {
            top.calcTopParent()
            geometryChanged( top.topWidth, top.topHeight )
        }
    }


    Component.onCompleted: { calcTopParent() }

    onParentChanged: calcTopParent()
}
