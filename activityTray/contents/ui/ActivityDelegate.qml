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
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddonsComponents
import org.kde.activities 0.1 as Activities

MouseArea {
	id: wrapper
	acceptedButtons: Qt.LeftButton | Qt.RightButton
	onClicked: {
		wrapper.pressedItem = id
		if( mouse.button == Qt.LeftButton ) {
			activityModel.setCurrentActivity(wrapper.pressedItem, function() {})
		}
		else if( mouse.button == Qt.RightButton ) {
			action_stopActivity();
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
			Behavior on opacity { NumberAnimation {} }
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
		}
	}
	
	function getOpacity() {
		if( (state == "grid" && current) || (state == "list" && containsMouse) ) {
			return 1;
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
	
	function action_stopActivity() {
		activityModel.stopActivity(wrapper.pressedItem, function() {});
	}
	
	Component.onCompleted: {
		if( wrapper.pressedItem != "" ) {
			plasmoid.setAction("stopActivity", i18n("Stop Activity"));
		}
	}
}
