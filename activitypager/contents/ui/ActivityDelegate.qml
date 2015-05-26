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
	property bool isExpanded: plasmoid.expanded
	
	Rectangle {
		id: highlightBackground
		color: theme.highlightColor
		width: parent.width
		height: parent.height
		opacity: current ? 0.6 : 0
		radius: 3
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
	}
	
	PlasmaCore.IconItem {
		id: activityIcon
		source: iconSource
		height: parent.height
		width: parent.width
		anchors.horizontalCenter: parent.horizontalCenter
		
		PlasmaCore.ToolTipArea {
			id: toolTip
			anchors.fill: parent
			
			active: !isExpanded
			icon: icon
			mainText: name
		}
	}
	
	onClicked: {
		activityTrayModel.setCurrentActivity(id, function() {});
	}
	
	function action_stopActivity() {
		activityTrayModel.stopActivity(id, function() {});
	}
	
	Component.onCompleted: {
		plasmoid.setAction("stopActivity", i18n("Stop Activity"));
	}
}
