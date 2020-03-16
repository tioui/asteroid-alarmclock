/*
 * Copyright (C) 2020 - Louis Marchand <prog@tioui.com>
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


#ifndef PROCESS_H
#define PROCESS_H

#include <QObject>
#include <stdlib.h>

class Process : public QObject {
    Q_OBJECT

public:
    Process(QObject *parent = 0) : QObject(parent) { }

    Q_INVOKABLE int start(const QString &commands) {
        int return_code;
        QByteArray bytes = commands.toLocal8Bit();
        return_code = system(bytes.data());
        return return_code;
    }
};


#endif // PROCESS_H
