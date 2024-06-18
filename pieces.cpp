#include "pieces.h"

Pieces::Pieces(int x, int y, Color color, const QString &name, int index)
    : m_x(x)
    , m_y(y)
    , m_color(color)
    , m_name(name)
    , m_index(index)
{}

Pieces::~Pieces() {}

//返回棋子的索引
const int Pieces::index()
{
    return m_index;
}

//返回棋子的x坐标
int Pieces::x()
{
    return m_x;
}
//设置棋子的x坐标
void Pieces::setX(int value)
{
    m_x = value;
}
//返回棋子的y坐标
int Pieces::y()
{
    return m_y;
}
//设置棋子的y坐标
void Pieces::setY(int value)
{
    m_y = value;
}
//返回棋子的颜色
const Pieces::Color Pieces::color()
{
    return m_color;
}
//返回棋子的名字
const QString &Pieces::name()
{
    return m_name;
}

Pawn::Pawn(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

Pawn::~Pawn() {}

Bishop::Bishop(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

Bishop::~Bishop() {}

Knight::Knight(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

Knight::~Knight() {}

Rook::Rook(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

Rook::~Rook() {}

Queen::Queen(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

Queen::~Queen() {}

King::King(int x, int y, const Color color, const QString &name, const int index)
    : Pieces(x, y, color, name, index)
{}

King::~King() {}
