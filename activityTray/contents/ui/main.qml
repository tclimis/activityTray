/**************************************************************************
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

	property int preferredItemSize: 128 // will be set by the grid, just needs a high-enough default

	// Sizes depend on the font, and thus on DPI
	property int baseSize: theme.mSize(theme.defaultFont).height
	property int itemSize: LayoutManager.alignedSize(Math.min(baseSize * 2, preferredItemSize))

	function togglePopup() {
		if (!plasmoid.expanded) {
			plasmoid.expanded = true;
		}
	}

	// This is the main view in the panel
	Plasmoid.compactRepresentation: CompactRepresentation {
		activityTrayModel: activityModel
		hiddenActivityModel: stoppedActivityModel
	}
	// This is the view when clicking on the arrow
	Plasmoid.fullRepresentation: ExpandedRepresentation {
		stoppedActivityTrayModel: stoppedActivityModel
	}
	
	function action_manageActivities() {
		var service = dataSource.serviceForSource("Status");
		var operation = service.operationDescription("toggleActivityManager");
		service.startOperationCall(operation);
	}
	
	PlasmaCore.DataSource {
		id: dataSource
		engine: "org.kde.activities"
		connectedSources: ["Status"]
	}

	Component.onCompleted: {
		plasmoid.setAction("manageActivities", i18n("Manage Activities..."), "preferences-activities");
		//activityModel.setShownStates(activityModel.shownStates);
		//stoppedActivityModel.setShownStates(stoppedActivityModel.shownStates);
	}
	
	Activities.ActivityModel {
		id: stoppedActivityModel
		shownStates: "Stopped"
	}

	Activities.ActivityModel {
		id: activityModel
		shownStates: "Running"
	}
}
