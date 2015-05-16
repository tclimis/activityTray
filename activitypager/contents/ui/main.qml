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
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.activities 0.1 as Activities
import "Layout.js" as LayoutManager

Item {
	id: root
	objectName: "ActivityTrayRootItem"

	property bool vertical: (plasmoid.formFactor == PlasmaCore.Types.Vertical)

	Plasmoid.toolTipMainText: ""
	Plasmoid.toolTipSubText: ""

	Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
	Plasmoid.onExpandedChanged: {
		if (!plasmoid.expanded && root.expandedTask) {
			root.expandedTask.expanded = false;
			root.expandedTask = null;
		}
	}

	property int preferredItemSize: 128 // will be set by the grid, just needs a high-enough default

	// Sizes depend on the font, and thus on DPI
	property int baseSize: theme.mSize(theme.defaultFont).height
	property int itemSize: LayoutManager.alignedSize(Math.min(baseSize * 2, preferredItemSize))

	//a pointer to the Task* that is the current one expanded, that shows full ui
	property QtObject expandedTask: null;

	function togglePopup() {
		if (!plasmoid.expanded) {
			plasmoid.expanded = true
		}
	}

	Plasmoid.compactRepresentation: CompactRepresentation {
		activityTrayModel: activityModel
		hiddenActivityModel: hiddenActivityModel
	}
	// FIXME: This needs to be reimplemented.
	/*Plasmoid.fullRepresentation: ExpandedRepresentation {
		Layout.minimumWidth: Layout.minimumHeight * 1.75
		Layout.minimumHeight: units.gridUnit * 14
		Layout.preferredWidth: Layout.minimumWidth
		Layout.preferredHeight: Layout.minimumHeight * 1.5
	}*/

	Connections {
		target: plasmoid.configuration
		onRunningActivitiesShownChanged: plasmoid.configuration.runningActivitiesShown ? appendState("Running") : removeState("Running");
		
		onStoppedActivitiesShownChanged: plasmoid.configuration.stoppedActivitiesShown ? appendState("Stopped") : removeState("Stopped");
	}
	
	function appendState(state) {
		var states = activityModel.shownStates;
		if( !states.isEmpty() )
			states.append(",");
		states.append(state);
		activityModel.setShownStates(states);
	}
	
	function removeState(state) {
		var states = activityModel.shownStates;
		var stateWithComma = "," + state;
		if( states.contains(stateWithComma, Qt.CaseInsensitive) )
			states.remove(stateWithComma, Qt.CaseInsensitive);
		else if( states.contains(state, Qt.CaseInsensitive) )
			states.remove(state, Qt.CaseInsensitive);
		activityModel.setShownStates(states);
	}

	Component.onCompleted: {
	}

	Activities.ActivityModel {
		id: activityModel
		shownStates: "Running"
	}
	
	Activities.ActivityModel {
		id: hiddenActivityModel
		shownStates: "Stopped"
	}
}
