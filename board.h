#pragma once

#include <QAbstractListModel>
#include <QObject>
#include <QSharedPointer>

#include "chess.h"
#include "pieces.h"

class Board : public QAbstractListModel
{
    Q_OBJECT
public:
    Board();
    virtual ~Board();

    enum Role { PieceImgRole = Qt::UserRole };

    //初始化棋子
    QVector<QSharedPointer<Pieces>> initPieces();

    // QAbstractListModel的虚函数，用于提供模型数据
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    // 移动
    Q_INVOKABLE void move(int fromX, int fromY, int toX, int toY);
    Q_INVOKABLE QVector<int> possibleMoves(int x, int y);

private:
    QVector<QSharedPointer<Pieces>> m_pieces;
};
