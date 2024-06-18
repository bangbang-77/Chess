#include "board.h"

Board::Board()
    : m_pieces(initPieces())
{}

Board::~Board() {}

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
