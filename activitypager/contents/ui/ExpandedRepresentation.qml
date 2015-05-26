/***************************************************************************
*   Copyright 2013 Sebastian Kügler <sebas@kde.org>                       *
*                                                                         *
*   This program is free software; you can redistribute it and/or modify  *
*   it under the terms of the GNU Library General Public License as       *
*   published by the Free Software Foundation; either version 2 of the    *
*   License, or (at your option) any later version.                       *
*                                                                         *
*   This program is distributed in the hope that it will be useful,       *
*   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
*   GNU Library General Public License for more details.                  *
*                                                                         *
*   You should have received a copy of the GNU Library General Public     *
*   License along with this program; if not, write to the                 *
*   Free Software Foundation, Inc.,                                       *
*   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .        *
***************************************************************************/

import QtQuick 2.0
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import org.kde.activities 0.1 as Activities

KQuickControlsAddons.MouseEventListener {
	
	property QtObject stoppedActivityModel: undefined

	ListView {
		id: hiddenView
		objectName: "hiddenView"
		clip: false
		width: parent.width

		interactive: (contentHeight > height)

		anchors {
			topMargin: units.largeSpacing / 2
			bottom: parent.bottom
			left: parent.left
		}
		spacing: units.smallSpacing

		model: stoppedActivityModel

		delegate: ActivityDelegate {
			height: units.iconSizing.small
			width: units.iconSizing.small
		}

	}

	Connections {
		target: plasmoid
		onExpandedChanged: {
			if (!plasmoid.expanded) {
				expandedItemContainer.animate = false;
			}
		}

	}

}
