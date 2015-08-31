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
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
	id: compactRepresentation
	
	property QtObject activityTrayModel: undefined
	property QtObject hiddenActivityModel: undefined

	Layout.minimumWidth: !root.vertical ? computeDimensionWidth() : 0
	
	function computeDimensionWidth() {
		var dim = root.vertical ? compactRepresentation.width : compactRepresentation.height
		var rows = Math.floor(dim / root.itemSize);
		var cols = Math.ceil(gridView.count / rows);
		var res = cols * (root.itemSize + units.smallSpacing) + units.smallSpacing + (tooltip.visible ? tooltip.width : 0);
		return res;
	}
	
	Layout.minimumHeight: !root.vertical ? 0 : computeDimensionHeight()
	
	function computeDimensionHeight() {
		var dim = root.vertical ? compactRepresentation.width : compactRepresentation.height
		var cols = Math.floor(dim / root.itemSize);
		var rows = Math.ceil(gridView.count / cols);
		var res = rows * (root.itemSize + units.smallSpacing) + units.smallSpacing + (tooltip.visible ? tooltip.height : 0);
		return res;
	}
	
	Layout.maximumWidth: plasmoid.formFactor == PlasmaCore.Types.Planar ? units.gridUnit * 3 : Layout.minimumWidth
	Layout.maximumHeight: plasmoid.formFactor == PlasmaCore.Types.Planar ? units.gridUnit * 3 : Layout.minimumHeight
	Layout.preferredWidth: Layout.minimumWidth
	Layout.preferredHeight: Layout.minimumHeight

	Layout.fillWidth: false
	Layout.fillHeight: false

	Connections {
		target: root
	}

	Component {
		id: activityDelegateComponent
		ActivityDelegate {
			id: activityDelegate
			width: gridView.cellWidth
			height: gridView.cellHeight
			state: "grid"
		}
	}

	GridView {
		id: gridView
		objectName: "gridView"
		flow: root.vertical ? GridView.LeftToRight : GridView.TopToBottom

		anchors {
			top: parent.top
			bottom: !root.vertical || !tooltip.visible ? parent.bottom : tooltip.top
			left: parent.left
			right: !root.vertical && tooltip.visible ? tooltip.left : parent.right
		}
		cellWidth: root.vertical ? gridView.width / Math.floor(gridView.width / root.itemSize) : root.itemSize + units.smallSpacing
		cellHeight: !root.vertical ? gridView.height / Math.floor(gridView.height / root.itemSize) : root.itemSize + units.smallSpacing
		interactive: false

		model: activityTrayModel
		delegate: activityDelegateComponent
	}
	
	// kludgy: can't tell how many items are in the model 
	// without displaying them, but make the display invisible
	ListView {
		id: hiddenItemList
		model: hiddenActivityModel
		delegate: activityDelegateComponent
		visible: false
	}

	// Tooltip for arrow --------------------------------
	PlasmaCore.ToolTipArea {
		id: tooltip

		width: root.vertical ? compactRepresentation.width : units.iconSizes.smallMedium
		height: !root.vertical ? compactRepresentation.height : units.iconSizes.smallMedium
		visible: hiddenItemList.count > 0
		anchors {
			right: parent.right
			bottom: parent.bottom
		}

		subText: plasmoid.expanded ? i18n("Hide activies") : i18n("Show hidden activities")

		MouseArea {
			id: arrowMouseArea
			onClicked: plasmoid.expanded = !plasmoid.expanded
			anchors.fill: parent

			readonly property int arrowAnimationDuration: units.shortDuration * 3

			PlasmaCore.Svg {
				id: arrowSvg
				imagePath: "widgets/arrows"
			}

			PlasmaCore.SvgItem {
				id: arrow
				width: Math.min(parent.width, parent.height)
				height: width
				rotation: plasmoid.expanded ? 180 : 0
				opacity: plasmoid.expanded ? 0 : 1
				svg: arrowSvg
				elementId: getCompactElementID()

				anchors.centerIn: parent

				Behavior on rotation {
					RotationAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}

				Behavior on opacity {
					NumberAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}
			}

			PlasmaCore.SvgItem {
				width: arrow.width
				height: arrow.height
				rotation: plasmoid.expanded ? 0 : -180
				opacity: plasmoid.expanded ? 1 : 0
				svg: arrowSvg
				elementId: getExpandedElementID()
				
				anchors.centerIn: parent
				
				Behavior on rotation {
					RotationAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}
				
				Behavior on opacity {
					NumberAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}
			}
		}
	}
	
	function getCompactElementID() {
		if (plasmoid.location == PlasmaCore.Types.BottomEdge) {
			return "up-arrow";
		} 
		else if (plasmoid.location == PlasmaCore.Types.TopEdge) {
			return "down-arrow";
		} 
		else if (plasmoid.location == PlasmaCore.Types.LeftEdge) {
			return "right-arrow";
		} 
		return "left-arrow";
	}
	
	function getExpandedElementID() {
		if (plasmoid.location == PlasmaCore.Types.BottomEdge) {
			return "down-arrow"
		} 
		else if (plasmoid.location == PlasmaCore.Types.TopEdge) {
			return "up-arrow"
		} 
		else if (plasmoid.location == PlasmaCore.Types.LeftEdge) {
			return "left-arrow"
		}
		return "right-arrow"
	}

	onHeightChanged: setItemPreferredSize();
	onWidthChanged: setItemPreferredSize();
	
	function setItemPreferredSize() {
		var dim = (root.vertical ? compactRepresentation.width : compactRepresentation.height);
		if (root.preferredItemSize != dim) {
			root.preferredItemSize = dim;
		}
	}
}
