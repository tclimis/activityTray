/*
 *  Copyright 2013 Sebastian Kügler <sebas@kde.org>
 *  Copyright 2014 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

import org.kde.private.systemtray 2.0 as SystemTray

Item {
    id: iconsPage

    signal configurationChanged

    width: childrenRect.width
    height: childrenRect.height
    implicitWidth: mainColumn.implicitWidth
    implicitHeight: pageColumn.implicitHeight

    property alias cfg_runningActivitiesShown: running.checked
    property alias cfg_stoppedActivitiesShown: stopped.checked

    SystemPalette {
        id: palette
    }

    QtLayouts.ColumnLayout {
        id: pageColumn

        PlasmaExtras.Heading {
            level: 2
            text: i18n("Categories")
            color: palette.text
        }
        Item {
            width: height
            height: units.gridUnit / 2
        }
        QtLayouts.ColumnLayout {
            spacing: units.smallSpacing * 2
            QtControls.CheckBox {
                id: running
                text: i18n("Show Running Activities")
            }
            QtControls.CheckBox {
                id: stopped
                text: i18n("Show Stopped Activities")
            }
        }
    }
}
