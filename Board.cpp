#include "Board.h"

Board::Board()
    : m_pieces(initPieces())
    , turn(WhitePlayer)
{}

Board::~Board() {}

Board::Player Board::colortoPlayer(Pieces::Color color)
{
    switch (color) {
    case Pieces::White:
        return WhitePlayer;
    case Pieces::Black:
        return BlackPlayer;
    }
}

QVector<QSharedPointer<Pieces>> Board::initPieces()
{
    QVector<QSharedPointer<Pieces>> pieces
        = {// 黑
           QSharedPointer<Pieces>{new Rook{0, 0, Pieces::Black, 0}},
           QSharedPointer<Pieces>{new Knight{1, 0, Pieces::Black, 1}},
           QSharedPointer<Pieces>{new Bishop{2, 0, Pieces::Black, 2}},
           QSharedPointer<Pieces>{new Queen{3, 0, Pieces::Black, 3}},
           QSharedPointer<Pieces>{new King{4, 0, Pieces::Black, 4}},
           QSharedPointer<Pieces>{new Bishop{5, 0, Pieces::Black, 5}},
           QSharedPointer<Pieces>{new Knight{6, 0, Pieces::Black, 6}},
           QSharedPointer<Pieces>{new Rook{7, 0, Pieces::Black, 7}},
           QSharedPointer<Pieces>{new Pawn{0, 1, Pieces::Black, 8}},
           QSharedPointer<Pieces>{new Pawn{1, 1, Pieces::Black, 9}},
           QSharedPointer<Pieces>{new Pawn{2, 1, Pieces::Black, 10}},
           QSharedPointer<Pieces>{new Pawn{3, 1, Pieces::Black, 11}},
           QSharedPointer<Pieces>{new Pawn{4, 1, Pieces::Black, 12}},
           QSharedPointer<Pieces>{new Pawn{5, 1, Pieces::Black, 13}},
           QSharedPointer<Pieces>{new Pawn{6, 1, Pieces::Black, 14}},
           QSharedPointer<Pieces>{new Pawn{7, 1, Pieces::Black, 15}},

           // 白
           QSharedPointer<Pieces>{new Pawn{0, 6, Pieces::White, 16}},
           QSharedPointer<Pieces>{new Pawn{1, 6, Pieces::White, 17}},
           QSharedPointer<Pieces>{new Pawn{2, 6, Pieces::White, 18}},
           QSharedPointer<Pieces>{new Pawn{3, 6, Pieces::White, 19}},
           QSharedPointer<Pieces>{new Pawn{4, 6, Pieces::White, 20}},
           QSharedPointer<Pieces>{new Pawn{5, 6, Pieces::White, 21}},
           QSharedPointer<Pieces>{new Pawn{6, 6, Pieces::White, 22}},
           QSharedPointer<Pieces>{new Pawn{7, 6, Pieces::White, 23}},
           QSharedPointer<Pieces>{new Rook{0, 7, Pieces::White, 24}},
           QSharedPointer<Pieces>{new Knight{1, 7, Pieces::White, 25}},
           QSharedPointer<Pieces>{new Bishop{2, 7, Pieces::White, 26}},
           QSharedPointer<Pieces>{new Queen{3, 7, Pieces::White, 27}},
           QSharedPointer<Pieces>{new King{4, 7, Pieces::White, 28}},
           QSharedPointer<Pieces>{new Bishop{5, 7, Pieces::White, 29}},
           QSharedPointer<Pieces>{new Knight{6, 7, Pieces::White, 30}},
           QSharedPointer<Pieces>{new Rook{7, 7, Pieces::White, 31}}};

    return pieces;
}

int Board::rowCount(const QModelIndex &parent) const
{
    return 8 * 8;
}

QVariant Board::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    int row = index.row() / 8; // 行，对应y
    int col = index.row() % 8; // 列，对应x

    switch (role) {
    case PieceImgRole: {
        QString src = QString("qrc:/img/");

        for (int i = 0; i < m_pieces.length(); ++i) {
            auto p = m_pieces[i];
            if (p->x() == col && p->y() == row) {
                switch (p->type()) {
                case Pieces::king:
                    src.append("king");
                    break;

                case Pieces::queen:
                    src.append("queen");
                    break;

                case Pieces::rook:
                    src.append("castle");
                    break;

                case Pieces::knight:
                    src.append("knight");
                    break;

                case Pieces::bishop:
                    src.append("bishop");
                    break;

                case Pieces::pawn:
                    src.append("pawn");
                    break;
                default:
                    break;
                }
                switch (p->color()) {
                case Pieces::White:
                    src.append("-white.png");
                    return src;
                case Pieces::Black:
                    src.append("-black.png");
                    return src;
                default:
                    break;
                }
            }
        }

    } break;
    }

    return QVariant();
}

QHash<int, QByteArray> Board::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PieceImgRole] = "pieceImg";
    return roles;
}

void Board::move(int fromX, int fromY, int toX, int toY)
{
    QSharedPointer<Pieces> p, tmp;
    bool isEmpty = true;

    for (int i = 0; i < m_pieces.length(); ++i) {
        p = m_pieces[i];
        if (p->x() == fromX && p->y() == fromY) {
            break; // 找到当前棋子
        }
    }

    if (turn != colortoPlayer(p->color())) {
        return;
    }

    for (int i = 0; i < m_pieces.length(); ++i) {
        tmp = m_pieces[i];
        if (tmp->x() == toX && tmp->y() == toY) {
            isEmpty = false;
            break; // 找到当前棋子
        }
        tmp = nullptr;
    }

    if (isEmpty) {
        // 选中的位置没有棋子
        // 设置第一次移动
        if (p->isFirstMove()) {
            p->setFirstMove();
        }
    } else if (!isEmpty && p->color() != tmp->color()) {
        // 选中的位置有敌方棋子
        // 该棋子被移除
        for (int i = 0; i < m_pieces.length(); ++i) {
            if (m_pieces[i]->id() == tmp->id()) {
                m_pieces.remove(i);
                qDebug() << "remove id: " << tmp->id();
                qDebug() << "m_pieces.length(): " << m_pieces.length();
            }
        }
    }

    p->setX(toX);
    p->setY(toY);

    if (turn == WhitePlayer) {
        turn = BlackPlayer;
    } else if (turn == BlackPlayer) {
        turn = WhitePlayer;
    }

    // createIndex创建并返回一个 QModelIndex 对象，该对象指向模型中移动后的位置
    QModelIndex fromIndex = createIndex(fromY * 8 + fromX, 0);
    QModelIndex toIndex = createIndex(toY * 8 + toX, 0);

    // dataChanged是QAbstractItemModel的一个信号，通知界面更新棋子的位置
    // 两个参数都是newIndex，意味着只通知了一个数据项的改变，用于单个数据项的更新
    emit dataChanged(fromIndex, fromIndex);
    emit dataChanged(toIndex, toIndex);
}
void Board::setBlackPlayer()
{
    if (turn == BlackPlayer) {
        return;
    } else {
        turn = BlackPlayer;
    }
}
void Board::setWhitePlayer()
{
    if (turn == WhitePlayer) {
        return;
    } else {
        turn = WhitePlayer;
    }
}
void Board::setWaitPlayer()
{
    if (turn == waitPlayer) {
        return;
    } else
        turn = waitPlayer;
}
QVector<int> Board::possibleMoves(int x, int y)
{
    QSharedPointer<Pieces> p;
    for (int i = 0; i < m_pieces.length(); ++i) {
        p = m_pieces[i];
        if (p->x() == x && p->y() == y) {
            break; // 找到当前棋子
        }
    }

    if (turn != colortoPlayer(p->color())) {
        qDebug() << "不是此方回合";
        return {};
    }

    switch (p->type()) {
    case Pieces::pawn: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 白子上移（y减少），黑子下移（y增加）
        int offset = p->color() == Pieces::Color::White ? -1 : 1;

        isEmpty = true;
        auto newPawn = new Pawn{p->x(), p->y() + 1 * offset, p->color(), p->id()};
        for (int i = 0; i < m_pieces.length(); ++i) {
            tmp = m_pieces[i];
            if (tmp->x() == newPawn->x() && tmp->y() == newPawn->y()) {
                isEmpty = false;
                break; // 找到棋子, 说明当前x,y位置不为空
            }
            tmp = nullptr;
        }
        // 没有棋子才可以前进
        if (isEmpty && newPawn->y() < 8 && newPawn->y() >= 0) {
            int pos = newPawn->y() * 8 + newPawn->x();
            if (newPawn->y() == 0 || newPawn->y() == 7) {
                moveList.append(pos); // 晋升(兵升变)
            } else {
                moveList.append(pos); // 移动
            }

            //第一次移动可以再 + 1 * offset
            isEmpty = true;
            newPawn->setY(newPawn->y() + 1 * offset);
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == newPawn->x() && tmp->y() == newPawn->y()) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }
            pos = newPawn->y() * 8 + newPawn->x();
            if (p->isFirstMove() && isEmpty) {
                moveList.append(pos); // 移动
                // p->setFirstMove();
            }
        }

        // 吃子(斜着)
        // 右上/右下
        isEmpty = true;
        newPawn = new Pawn{p->x() + 1, p->y() + 1 * offset, p->color(), p->id()};
        for (int i = 0; i < m_pieces.length(); ++i) {
            tmp = m_pieces[i];
            if (tmp->x() == newPawn->x() && tmp->y() == newPawn->y()) {
                isEmpty = false;
                break; // 找到棋子, 说明当前x,y位置不为空
            }
            tmp = nullptr;
        }
        int pos = newPawn->y() * 8 + newPawn->x();
        if (newPawn->y() < 8 && newPawn->y() >= 0 && newPawn->x() < 8 && !isEmpty
            && tmp->color() != p->color()) {
            moveList.append(pos); // 吃子
        }

        // 左上/左下
        isEmpty = true;
        newPawn = new Pawn{p->x() - 1, p->y() + 1 * offset, p->color(), p->id()};
        for (int i = 0; i < m_pieces.length(); ++i) {
            tmp = m_pieces[i];
            if (tmp->x() == newPawn->x() && tmp->y() == newPawn->y()) {
                isEmpty = false;
                break; // 找到棋子, 说明当前x,y位置不为空
            }
            tmp = nullptr;
        }
        pos = newPawn->y() * 8 + newPawn->x();
        if (newPawn->y() < 8 && newPawn->y() >= 0 && newPawn->x() >= 0 && !isEmpty
            && tmp->color() != p->color()) {
            moveList.append(pos); // 吃子
        }

        // 吃过路兵
        // ...

        return moveList;
    }
    case Pieces::bishop: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 左上
        for (int x = p->x() - 1, y = p->y() - 1; x >= 0 && y >= 0; x--, y--) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 右上
        for (int x = p->x() + 1, y = p->y() - 1; x < 8 && y >= 0; x++, y--) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到当前棋子, 说明当前x,y不为空, tmp != nullptr
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 右下
        for (int x = p->x() + 1, y = p->y() + 1; x < 8 && y < 8; x++, y++) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到当前棋子, 说明当前x,y不为空, tmp != nullptr
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 左下
        for (int x = p->x() - 1, y = p->y() + 1; x >= 0 && y < 8; x--, y++) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到当前棋子, 说明当前x,y不为空, tmp != nullptr
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        return moveList;
    }
    case Pieces::knight: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 马能走八个位置（两格拐一格）   变化量：{x, y}
        int offsets[8][2] = {{1, 2}, {2, 1}, {2, -1}, {1, -2}, {-1, -2}, {-2, -1}, {-2, 1}, {-1, 2}};

        for (int i = 0; i < 8; i++) {
            int x = p->x() + offsets[i][0];
            int y = p->y() + offsets[i][1];

            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (x >= 0 && x < 8 && y >= 0 && y < 8) {
                if (isEmpty) {
                    moveList.append(pos); // 移动
                } else if (tmp->color() != p->color()) {
                    moveList.append(pos); // 吃子
                }
            }
        }

        return moveList;
    }
    case Pieces::rook: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 向上移动
        for (int i = p->y() - 1; i >= 0; i--) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == p->x() && tmp->y() == i) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = i * 8 + p->x();
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向下移动
        for (int i = p->y() + 1; i < 8; i++) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == p->x() && tmp->y() == i) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = i * 8 + p->x();
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向左移动
        for (int i = p->x() - 1; i >= 0; i--) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == i && tmp->y() == p->y()) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = p->y() * 8 + i;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向右移动
        for (int i = p->x() + 1; i < 8; i++) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == i && tmp->y() == p->y()) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = i * 8 + p->y();
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        return moveList;
    }
    case Pieces::queen: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 直着走，上下左右
        // 向上移动
        for (int i = p->y() - 1; i >= 0; i--) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == p->x() && tmp->y() == i) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = i * 8 + p->x();
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向下移动
        for (int i = p->y() + 1; i < 8; i++) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == p->x() && tmp->y() == i) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = i * 8 + p->x();
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向左移动
        for (int i = p->x() - 1; i >= 0; i--) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == i && tmp->y() == p->y()) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = p->y() * 8 + i;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向右移动
        for (int i = p->x() + 1; i < 8; i++) {
            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == i && tmp->y() == p->y()) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = p->y() * 8 + i;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 斜着走，
        // 左上--、右上+-、右下++、左下-+

        // 向左上移动
        for (int x = p->x() - 1, y = p->y() - 1; x >= 0 && y >= 0; x--, y--) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向右上移动
        for (int x = p->x() + 1, y = p->y() - 1; x < 8 && y >= 0; x++, y--) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向左下移动
        for (int x = p->x() + 1, y = p->y() + 1; x < 8 && y < 8; x++, y++) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        // 向右下移动
        for (int x = p->x() - 1, y = p->y() + 1; x >= 0 && y < 8; x--, y++) {
            isEmpty = true;
            for (int i = 0; i < m_pieces.length(); ++i) {
                tmp = m_pieces[i];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }

            int pos = y * 8 + x;
            if (isEmpty) {
                moveList.append(pos); // 移动
            } else if (tmp->color() != p->color()) {
                moveList.append(pos); // 吃子
                break;
            } else {
                // isEmpty == false && tmp->color() == p->color()    同色
                break;
            }
        }

        return moveList;
    }
    case Pieces::king: {
        QVector<int> moveList;
        QSharedPointer<Pieces> tmp;
        bool isEmpty;

        // 王走八个位置（“米”字型，一次只能走一格）   变化量：{x, y}
        int offsets[8][2] = {{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {-1, 1}, {1, -1}, {-1, -1}};

        for (int i = 0; i < 8; i++) {
            int x = p->x() + offsets[i][0];
            int y = p->y() + offsets[i][1];

            isEmpty = true;
            for (int j = 0; j < m_pieces.length(); ++j) {
                tmp = m_pieces[j];
                if (tmp->x() == x && tmp->y() == y) {
                    isEmpty = false;
                    break; // 找到棋子, 说明当前x,y位置不为空
                }
                tmp = nullptr;
            }
            int pos = y * 8 + x;
            if (x >= 0 && x < 8 && y >= 0 && y < 8) {
                if (isEmpty) {
                    moveList.append(pos); // 移动
                } else if (tmp->color() != p->color()) {
                    moveList.append(pos); // 吃子
                }
            }
        }

        // 王车易位
        // ...

        return moveList;
    }
    default:
        return {};
    }
}
