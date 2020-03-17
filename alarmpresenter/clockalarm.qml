import QtQuick 2.9
import Nemo.Alarms 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import Nemo.Ngf 1.0
import org.asteroid.controls 1.0
import Process 1.0
Item {

    function dismissAlarm(){
        for(var i = 0; alarmModel.count > i; i++) {
            if (alarmModel.get(i).alarmTime === (+twoDigits(alarmDialog.hour)+":"+twoDigits(alarmDialog.minute))) {
                if (alarmModel.get(i).alarmName === alarmDialog.title) {
                    alarmModel.get(i).alarmEnabled = false;
                }
            }
        }
        feedback.stop()
        if(alarmDialog !== undefined && alarmDialog !== null)
            alarmDialog.dismiss()
        alarmTimeField.text = ""
        alarmHandler.dialogOnScreen = false
        window.close()
    }

    function snoozeAlarm(){
        feedback.stop()
        if(alarmDialog !== undefined && alarmDialog !== null)
            alarmDialog.snooze()
        alarmTimeField.text = ""
        alarmHandler.dialogOnScreen = false
        window.close()
    }

    ConfigurationValue {
        id: use12H
        key: "/org/asteroidos/settings/use-12h-format"
        defaultValue: false
    }

    StatusPage {
        id:statusPage
        icon: "ios-alarm-outline"
    }

    Label {
        id: alarmTimeField
        font.pixelSize: Dims.l(15)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Dims.h(13)
        text: {
            if(alarmDialog == undefined || alarmDialog == null)
                return ""
            else {
                if(use12H.value) {
                    var amPm = "AM";
                    if(alarm.hour >= 12)
                        amPm = "PM";
                    return twoDigits(alarmDialog.hour%12) + ":" + twoDigits(alarmDialog.minute) + amPm
                } else {
                    return twoDigits(alarmDialog.hour) + ":" + twoDigits(alarmDialog.minute)
                }


            }
        }
    }

    IconButton {
        id: alarmDismiss
        iconName: "ios-checkmark-circle-outline"
        edge: Qt.LeftEdge
        onClicked: {
            // Disable the alarm if it is a singleshot
            for(var i = 0; alarmModel.count > i; i++) {
                if (alarmModel.get(i).alarmTime === (+twoDigits(alarmDialog.hour)+":"+twoDigits(alarmDialog.minute))) {
                    if (alarmModel.get(i).alarmName === alarmDialog.title) {
                        alarmModel.get(i).alarmEnabled = false;
                    }
                }
            }
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.dismiss()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    IconButton {
        id: alarmSnooze
        iconName: "ios-sleep-circle-outline"
        edge: Qt.RightEdge
        onClicked: {
            feedback.stop()
            if(alarmDialog !== undefined && alarmDialog !== null)
                alarmDialog.snooze()
            alarmTimeField.text = ""
            alarmHandler.dialogOnScreen = false
            window.close()
        }
    }

    DBusInterface {
        bus: DBus.SystemBus
        service: 'com.nokia.mce'
        path: '/com/nokia/mce/signal'
        iface: 'com.nokia.mce.signal'
        signalsEnabled: true

        function alarm_ui_feedback_ind(event) {
            if (event === "powerkey") {
                snoozeAlarm()
            }
        }
    }
}
