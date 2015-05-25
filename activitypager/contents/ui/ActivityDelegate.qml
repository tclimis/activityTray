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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents

import org.kde.activities 0.1 as Activities

MouseArea {
	id: wrapper
	property bool isExpanded: false
	
	Rectangle {
		id: highlightBackground
		color: theme.highlightColor
		width: gridView.cellWidth
		height: gridView.cellHeight
		opacity: current ? 0.6 : 0
		radius: 3
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
	}
	
	PlasmaCore.IconItem {
		id: activityIcon
		source: iconSource
		height: gridView.cellHeight
		width: gridView.cellWidth
		anchors.horizontalCenter: parent.horizontalCenter
		
		PlasmaCore.ToolTipArea {
			id: toolTip
			anchors.fill: parent
			
			active: !isExpanded
			icon: icon
			mainText: name
			subText: "::" + state + "::"
		}
	}
	
	onClicked: {
		activityTrayModel.setCurrentActivity(id, function() {});
		gridView.currentIndex = index;
	}
	
	function action_stopActivity() {
		activityTrayModel.stopActivity(id, function() {});
	}
	
	Component.onCompleted: {
		plasmoid.setAction("stopActivity", i18n("Stop Activity"));
		
	}
}

/*KQuickControlsAddonsComponents.MouseEventListener {

    Component.onCompleted: {
        if (taskType == SystemTray.Task.TypeStatusItem) {
            sniLoader.source = "StatusNotifierItem.qml";
        } else if (modelData && modelData.taskItem != undefined) {
            sniLoader.source = "PlasmoidItem.qml";
            modelData.taskItem.parent = activityContainer;
            modelData.taskItem.z = -1;
            updatePlasmoidGeometry();
        } else {
            console.warning("Trying to add item to system tray of an unknown type. Ignoring");
        }
    }
}*/
