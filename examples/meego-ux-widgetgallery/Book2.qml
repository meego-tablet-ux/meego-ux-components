/*
 * Copyright 2011 Intel Corporation.
 *
 * This program is licensed under the terms and conditions of the
 * LGPL, version 2.1.  The full text of the LGPL Licence is at
 * http://www.gnu.org/licenses/lgpl.html
 */

/* This file contains relativy empty pages and is meant to demonstrate the
   book/page concept */

import Qt 4.7

PageDummy {
    id: pageDummy

    innerText: "book 2, page 1"
    rectColor: "lightblue"
    showButton: true
    buttonLabel: "Page 2"
    pageTitle: "Dummy book 2"

    onClicked: { addPage( page2 ) }

    Component{
        id: page2;

        PageDummy {
            id: pageDummy2

            innerText: "book 2, page 2"
            rectColor: "lightgreen"
            showButton: true
            buttonLabel: "Page 3"
            pageTitle: "Dummy book 2"

            onClicked: { addPage( page3 )
            }
        }
    }

    Component{
        id: page3;

        PageDummy {
            id: pageDummy3

            innerText: "book 2, page 3"
            rectColor: "orange"
            showButton: true
            buttonLabel: "Page 4"
            pageTitle: "Dummy book 2"

            onClicked: { addPage( page4 )
            }
        }
    }

    Component{
        id: page4;

        PageDummy {
            id: pageDummy4

            innerText: "book 2, page 4"
            rectColor: "darkgrey"
            pageTitle: "Dummy book 2"
        }
    }
}

