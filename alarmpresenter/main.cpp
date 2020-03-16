/*
 * Copyright (C) 2017 - Florent Revest <revestflo@gmail.com>
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

#include <QQuickView>
#include <QGuiApplication>
#include <QScreen>
#include <MDeclarativeCache>
#include <QFileInfo>
#include <QTranslator>

#include "process.h"

static QString applicationPath()
{
    QString argv0 = QCoreApplication::arguments()[0];

    if (argv0.startsWith("/")) {
        // First, try argv[0] if it's an absolute path (needed for booster)
        return argv0;
    } else {
        // If that doesn't give an absolute path, use /proc-based detection
        return QCoreApplication::applicationFilePath();
    }
}

QString appName()
    {
        QFileInfo exe = QFileInfo(applicationPath());
        return exe.fileName();
    }

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    QScopedPointer<QGuiApplication> app(MDeclarativeCache::qApplication(argc, argv));
    QTranslator* translator = new QTranslator();
    int retour = translator->load(QLocale(), appName(), ".", "/usr/share/translations", ".qm");
    app->installTranslator(translator);
    QScopedPointer<QQuickView> view(MDeclarativeCache::qQuickView());
    view->setSource(QUrl("qrc:/main.qml"));
    view->setTitle("Alarm Presenter");
    view->resize(app->primaryScreen()->size());
    view->show();
    return app->exec();
}
