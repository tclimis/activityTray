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
	
	PlasmaCore.IconItem {
		id: activityIcon
		source: iconSource.length > 0 ? iconSource : "preferences-activities"
		anchors.horizontalCenter: parent.horizontalCenter
		
		PlasmaCore.ToolTipArea {
			id: toolTip
			anchors.fill: parent
			
			active: !isExpanded
			icon: icon
			mainText: name
			subText: iconSource
			//location: 
		}
		
		function action_stopActivity() {
			activityTrayModel.stopActivity(id, function() {});
		}
		
		Component.onCompleted: {
			plasmoid.setAction("stopActivity", i18n("Stop " + name));
		}
	}
	
	onClicked: {
		if( state == "Stopped" )
			activityTrayModel.startActivity(id, function() {});
		
		activityTrayModel.setCurrentActivity(id, function() {});
		gridView.currentIndex = index;
	}
}

/*KQuickControlsAddonsComponents.MouseEventListener {
    id: activityContainer
    objectName: "activityContainer"

    height: root.itemSize + (units.smallSpacing * 2)
    width: snExpanded ? parent.width : height

    property bool isCurrentActivity: modelData.current

    function hideToolTip() {
        toolTip.hideToolTip()
    }

    // opacity is raised when: plasmoid is collapsed, we are the current task, or it's hovered
    opacity: (containsMouse || !plasmoid.expanded || isCurrentTask) || (plasmoid.expanded && root.expandedTask == null) ? 1.0 : 0.6
    Behavior on opacity { NumberAnimation { duration: units.shortDuration * 3 } }


    property string icon: icon
    property string name: name

    onWidthChanged: updatePlasmoidGeometry()
    onHeightChanged: updatePlasmoidGeometry()

	onIconChanged: updateToolTip()
	onNameChanged: updateToolTip()

    function updatePlasmoidGeometry() {
        var _size = Math.min(activityContainer.width, activityContainer.height);
        var _m = (activityContainer.height - _size) / 2

        modelData.icon.anchors.verticalCenter = activityContainer.verticalCenter;
            if (isHiddenItem) {
                modelData.icon.x = 0;
            } else {
                modelData.icon.anchors.centerIn = activityContainer;
            }
            modelData.taskItem.height = _size;
            modelData.taskItem.width = isHiddenItem ? _size * 1.5 : _size;
        }
    }

    function updateToolTip() {

    }

    PlasmaCore.ToolTipArea {
        id: toolTip
        anchors.fill: parent

        active: !isExpanded
        icon: activityContainer.icon
        mainText: activityContainer.name
        location: activityContainer.location
        //Loader {
        //    id: sniLoader
        //    anchors.fill: parent
        //}
    }

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
