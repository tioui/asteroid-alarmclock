import QtQuick 2.9
import Nemo.Alarms 1.0
import Nemo.DBus 2.0
import Nemo.Configuration 1.0
import Nemo.Ngf 1.0
import org.asteroid.controls 1.0
import Process 1.0
Item {

    function snooze(){
        if(alarmDialog !== undefined && alarmDialog !== null){
            alarmDialog.dismiss()
        }
    }

    StatusPage {
        id:statusPage
        icon: "ios-timer-outline"
    }

    Label {
        id: alarmTimeField
        font.pixelSize: Dims.l(15)
        anchors.centerIn: parent
        anchors.verticalCenterOffset: Dims.h(13)
        text: qsTr("Finished!")
    }

    IconButton {
        id: alarmDismiss
        iconName: "ios-checkmark-circle-outline"
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


}
