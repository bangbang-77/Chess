#pragma once

#include <QObject>

class Pieces : public QObject
{
    Q_OBJECT
public:
    enum Color { White, Black };
    enum PieceType {
        king,   // 王
        queen,  // 后
        rook,   // 车
        knight, // 马
        bishop, // 象
        pawn    // 兵
    };
    Pieces(int x, int y, const Color color, const QString &name, const int index);

    virtual ~Pieces();

    const int index();

    int x();

    void setX(int value);

    int y();

    void setY(int value);

    const Color color();

    const QString &name();

private:
    int m_x;
    int m_y;
    Color m_color;
    QString m_name;
    int m_index;
};

// 兵
class Pawn : public Pieces
{
public:
    Pawn(int x, int y, const Color color, const QString &name, const int index);
    virtual ~Pawn();
};

// 象
class Bishop : public Pieces
{
public:
    Bishop(int x, int y, const Color color, const QString &name, const int index);
    virtual ~Bishop();
};

// 马
class Knight : public Pieces
{
public:
    Knight(int x, int y, const Color color, const QString &name, const int index);
    virtual ~Knight();
};

// 车
class Rook : public Pieces
{
public:
    Rook(int x, int y, const Color color, const QString &name, const int index);
    virtual ~Rook();
};

// 后
class Queen : public Pieces
{
public:
    Queen(int x, int y, const Color color, const QString &name, const int index);
    virtual ~Queen();
};

// 王
class King : public Pieces
{
public:
    King(int x, int y, const Color color, const QString &name, const int index);
    virtual ~King();
};
