/*
 * Copyright (C) 2017 - Florent Revest <revestflo@gmail.com>
 *               2013 - Santtu Mansikkamaa <santtu.mansikkamaa@nomovok.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Nemo.Alarms 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import Nemo.Ngf 1.0
import org.asteroid.controls 1.0

Application {
    id: app
    property var alarmDialog
    overridesSystemGestures: alarmDialog !== undefined && alarmDialog !== null
    leftIndicVisible: false
    topIndicVisible: false

    centerColor: "#333333"
    outerColor: "#000000"

    function twoDigits(x) {
        if (x<10) return "0"+x;
        else      return x;
    }

    AlarmsModel  { id: alarmModel }
    AlarmHandler {
        id: alarmHandler
        onError: console.log("asteroid-alarmpresenter: error in AlarmHandler: " + message);
        onActiveDialogsChanged: {
            if (activeDialogs[0].type === Alarm.Clock || activeDialogs[0].type === Alarm.Countdown){
                alarmDialog = activeDialogs[0]
                dialogOnScreen = true
            }
            if (alarmDialog.type === Alarm.Countdown){
                loader.source = "countdownalarm.qml"
            } else {
                loader.source = "clockalarm.qml"
            }
        }
    }


    Loader{
            id:loader;
            anchors.fill: parent;
        }

    NonGraphicalFeedback {
        id: feedback
        event: "alarm"
    }

    DBusInterface {
        id: mceRequest

        service: "com.nokia.mce"
        path: "/com/nokia/mce/request"
        iface: "com.nokia.mce.request"

        bus: DBus.SystemBus
    }

    Timer {
        id: autoSnoozeTimer
        interval: 30000
        onTriggered: {
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.snooze()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    Component.onCompleted: {
        mceRequest.call("req_display_state_on", undefined)
        feedback.play()
        autoSnoozeTimer.start()
    }
}
