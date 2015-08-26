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
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.activities 0.1 as Activities


Item {
	id: compactRepresentation

	Layout.minimumWidth: !root.vertical ? computeDimensionWidth() : 0
	Layout.minimumHeight: !root.vertical ? 0 : computeDimensionHeight()
	Layout.maximumWidth: plasmoid.formFactor == PlasmaCore.Types.Planar ? units.gridUnit * 3 : Layout.minimumWidth
	Layout.maximumHeight: plasmoid.formFactor == PlasmaCore.Types.Planar ? units.gridUnit * 3 : Layout.minimumHeight
	Layout.preferredWidth: Layout.minimumWidth
	Layout.preferredHeight: Layout.minimumHeight

	Layout.fillWidth: false
	Layout.fillHeight: false

	property QtObject activityTrayModel: undefined
	property QtObject hiddenActivityModel: undefined

	Connections {
		target: root
	}

	function computeDimensionWidth() {
		var dim = root.vertical ? compactRepresentation.width : compactRepresentation.height
		var rows = Math.floor(dim / root.itemSize);
		var cols = Math.ceil(gridView.count / rows);
		var res = cols * (root.itemSize + units.smallSpacing) + units.smallSpacing + (tooltip.visible ? tooltip.width : 0);
		return res;
	}

	function computeDimensionHeight() {
		var dim = root.vertical ? compactRepresentation.width : compactRepresentation.height
		var cols = Math.floor(dim / root.itemSize);
		var rows = Math.ceil(gridView.count / cols);
		var res = rows * (root.itemSize + units.smallSpacing) + units.smallSpacing + (tooltip.visible ? tooltip.height : 0);
		return res;
	}

	function setItemPreferredSize() {
		var dim = (root.vertical ? compactRepresentation.width : compactRepresentation.height);
		if (root.preferredItemSize != dim) {
			root.preferredItemSize = dim;
		}
	}

	Component {
		id: activityDelegateComponent
		ActivityDelegate {
			id: activityDelegate
			width: gridView.cellWidth
			height: gridView.cellHeight
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
		Component.onCompleted: {
		}
	}
	


	// Tooltip for arrow --------------------------------
	PlasmaCore.ToolTipArea {
		id: tooltip

		width: root.vertical ? compactRepresentation.width : units.iconSizes.smallMedium
		height: !root.vertical ? compactRepresentation.height : units.iconSizes.smallMedium
		visible: true
		anchors {
			right: parent.right
			bottom: parent.bottom
		}

		subText: plasmoid.expanded ? i18n("Hide activies") : i18n("Show hidden activities")

		MouseArea {
			id: arrowMouseArea
			anchors.fill: parent
			onClicked: plasmoid.expanded = !plasmoid.expanded

			readonly property int arrowAnimationDuration: units.shortDuration * 3

			PlasmaCore.Svg {
				id: arrowSvg
				imagePath: "widgets/arrows"
			}

			PlasmaCore.SvgItem {
				id: arrow

				anchors.centerIn: parent
				width: Math.min(parent.width, parent.height)
				height: width

				rotation: plasmoid.expanded ? 180 : 0
				Behavior on rotation {
					RotationAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}
				opacity: plasmoid.expanded ? 0 : 1
				Behavior on opacity {
					NumberAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}

				svg: arrowSvg
				elementId: {
					if (plasmoid.location == PlasmaCore.Types.BottomEdge) {
						return "up-arrow"
					} else if (plasmoid.location == PlasmaCore.Types.TopEdge) {
						return "down-arrow"
					} else if (plasmoid.location == PlasmaCore.Types.LeftEdge) {
						return "right-arrow"
					} else {
						return "left-arrow"
					}
				}
			}

			PlasmaCore.SvgItem {
				anchors.centerIn: parent
				width: arrow.width
				height: arrow.height

				rotation: plasmoid.expanded ? 0 : -180
				Behavior on rotation {
					RotationAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}
				opacity: plasmoid.expanded ? 1 : 0
				Behavior on opacity {
					NumberAnimation {
						duration: arrowMouseArea.arrowAnimationDuration
					}
				}

				svg: arrowSvg
				elementId: {
					if (plasmoid.location == PlasmaCore.Types.BottomEdge) {
						return "down-arrow"
					} else if (plasmoid.location == PlasmaCore.Types.TopEdge) {
						return "up-arrow"
					} else if (plasmoid.location == PlasmaCore.Types.LeftEdge) {
						return "left-arrow"
					} else {
						return "right-arrow"
					}
				}
			}
		}
	}

	onHeightChanged: setItemPreferredSize();
	onWidthChanged: setItemPreferredSize();
}
