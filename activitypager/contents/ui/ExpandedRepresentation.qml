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
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.activities 0.1 as Activities
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	id: expandedItemContainer
	height: (units.iconSizes.medium + units.smallSpacing) * hiddenView.count + units.smallSpacing
	
	property QtObject stoppedActivityTrayModel: undefined
	property bool animate: true
	
	Component {
		id: stoppedActivitiesDelegate
		ActivityDelegate {
			height: units.iconSizes.medium + units.smallSpacing
			acceptedButtons: Qt.LeftButton
			state: "list"
		}
	}
	
	ListView {
		id: hiddenView
		model: stoppedActivityTrayModel
		delegate: stoppedActivitiesDelegate
		interactive: false;
		anchors.fill: parent
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
