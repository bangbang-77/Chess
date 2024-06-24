#include "mynetwork.h"
#include <QBitArray>
#include <QDebug>
MyNetWork::MyNetWork(QObject *parent)
    : QObject(parent)
{
    m_sender = new QUdpSocket(this);
    m_receiver = new QUdpSocket(this);
    m_receiver->bind(
        45456,
        QUdpSocket::ShareAddress); //使用 bind() 方法将套接字绑定到一个端口上，以便监听该端口上的数据。
    connect(m_receiver, SIGNAL(readyRead()), this, SLOT(readMessage()));
}

QString MyNetWork::getMyip4() const
{
    return m_ip4;
}

void MyNetWork::setMyip4(const QString &value)
{
    if (m_ip4 == value)
        return;
    m_ip4 = value;
    emit myip4Changed();
}
QString MyNetWork::getSend() const
{
    return m_send;
}
void MyNetWork::setSend(const QString &value)
{
    if (m_send == value)
        return;
    m_send = value;
    emit sendChanged();
    //sendMessage();
    //qDebug() << "sendmessage";
}
QString MyNetWork::getRecive() const
{
    return m_recive;
}

void MyNetWork::setRecive(const QString &value)
{
    if (m_recive == value)
        return;
    m_recive = value;
    emit reciveChanged();
}

void MyNetWork::sendMessage()
{
    QByteArray datagram = m_send.toUtf8();
    m_sender->writeDatagram(datagram.data(), datagram.size(), QHostAddress(m_ip4), 45456);
}
void MyNetWork::readMessage()
{
    while (m_receiver->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(m_receiver->pendingDatagramSize());
        m_receiver->readDatagram(datagram.data(), datagram.size());
        m_recive.clear();
        m_recive.prepend(datagram);
        emit reciveChanged();
        qDebug() << "readmessage:" + m_recive;
    }
}
