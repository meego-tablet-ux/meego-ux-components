/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This pages shows the VerticalSlider.qml and offers controls to manipulate it.
 */

import Qt 4.7
import MeeGo.Components 0.1

WidgetPage {
    id: widgetPage

    property bool mute: false

    pageTitle: "VerticalSlider"

    controlContent: [
        LabeledEntry {
            id: widthEntry

            label:  "width: "
            defaultValue: slider.width

            onTextUpdated: {
                if( value >= 0 ){
                    slider.width = value
                }
            }
        },

        LabeledEntry {
            id: heightEntry

            label:  "height: "
            defaultValue: slider.height

            onTextUpdated: {
                if( value >= 0 ){
                    slider.height = value
                }
            }
        },

        LabeledEntry {
            id: markerSizeEntry

            label:  "markerSize: "
            defaultValue: slider.markerSize

            onTextUpdated: {
                if( value >= 0 ){
                    slider.markerSize = parseInt(value)
                }
            }
        },

        LabeledEntry {
            id: minEntry

            label:  "min: "
            defaultValue: slider.min

            onTextUpdated: slider.min = parseInt( value )
        },

        LabeledEntry {
            id: maxEntry

            label:  "max: "
            defaultValue: slider.max

            onTextUpdated: slider.max = parseInt( value )
        },

        LabeledEntry {
            id: valueEntry

            label: "value: "
            defaultValue: "0"

            onTextUpdated: slider.value = parseInt( value )
        },

        LabeledEntry {
            id: percentageEntry

            label: "percentage: "
            defaultValue: "0"

            onTextUpdated: slider.percentage = parseFloat( value )
        },

        CheckBoxEntry {
            id: overlayBox

            label: "textOverlyVisible:"

            isChecked: true
        }
    ]

    statusContent: [
        StatusEntry {
            label: "Current value:"
            value: slider.value
        }
    ]

    description: "This is a vertical slider with customizable size and value ranges and options to set the current value. \n"
               + "The slider also has a progress bar which can be set through the percentage property."
               + "Note: the 'value' entry under API Properties is not linked to the current value property for demonstration reasons."

    widget: Flickable {

        anchors.fill: parent
        contentHeight: height > slider.height ? height : slider.height
        contentWidth: width > slider.width ? width : slider.width
        clip: true

        VerticalSlider {
            id: slider

            anchors.centerIn: parent
            textOverlayVisible: overlayBox.isChecked
            min: 0
            max: 100
        }
    }
}
