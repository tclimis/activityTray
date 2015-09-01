/***************************************************************************
 *   Copyright 2015 Tim Climis <tim.climis@gmail.com>                      *
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
import org.kde.plasma.components 2.0 as PlasmaComponents

MouseArea {
	id: wrapper
	hoverEnabled: true
	acceptedButtons: Qt.LeftButton | Qt.RightButton
	onClicked: {
		if( mouse.button === Qt.LeftButton ) {
			activityModel.setCurrentActivity(id, function() {})
		}
		else if( mouse.button === Qt.RightButton ) {
			contextMenu.visualParent = menuAnchor
			contextMenu.open()
		}
	}
	
	property bool isExpanded: plasmoid.expanded
	property string state: undefined
	property string pressedItem: ""
	
	Item {
		id: activity
		anchors.fill: parent
		
		PlasmaComponents.Highlight {
			opacity: getOpacity()
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			anchors.fill: parent
		}
		
		PlasmaComponents.Label {
			id: mainLabel
			text: name
			visible: wrapper.state == "list"
			
			anchors {
				left: parent.left
				leftMargin: units.iconSizes.medium + units.smallSpacing
				verticalCenter: activityIcon.verticalCenter
				fill: parent
			}
		}
	
		PlasmaCore.IconItem {
			id: activityIcon
			source: iconSource
			width: wrapper.state == "grid" ? parent.width : units.iconSizes.medium
			height: wrapper.state == "grid" ? parent.height : units.iconSizes.medium
			state: parent.state
			anchors.leftMargin: wrapper.state == "list" ? 15 : 0
			
			PlasmaCore.ToolTipArea {
				id: toolTip
				anchors.fill: parent
				active: !isExpanded
				mainText: name
			}
			
			PlasmaComponents.ContextMenu {
				id: contextMenu
				
				PlasmaComponents.MenuItem {
					text: i18n("Stop Activity");
					onClicked: activityModel.stopActivity(id, function() {})
				}
			}
			
			Item {
				id: menuAnchor
				width: 0
				height: 0
				anchors.top: parent.verticalCenter
				anchors.left: parent.horizontalCenter
			}
		}
	}
	
	function getOpacity() {
		if( state == "grid" && current ) {
			return 1;
		}
		else if( (state == "grid" && containsMouse)
			|| (state == "list" && containsMouse)
		) {
			return 0.5;
		}
		return 0;
	}
	
	State {
		name: "grid"
		AnchorChanges {
			target: activityIcon
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.left: undefined
		}
	}
	
	State {
		name: "list"
		AnchorChanges {
			target: activityIcon
			anchors.horizontalCenter: undefined
			anchors.left: parent.left
		}
	}
}
