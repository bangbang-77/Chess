#pragma once
#include <QString>
//#include <QUdpSocket>
#include <QtNetwork>
class MyNetWork : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString myip4 READ getMyip4 WRITE setMyip4 NOTIFY myip4Changed)
    Q_PROPERTY(QString send READ getSend WRITE setSend NOTIFY sendChanged)
    Q_PROPERTY(QString recive READ getRecive WRITE setRecive NOTIFY reciveChanged)
public:
    explicit MyNetWork(QObject *parent = nullptr);

    QString getMyip4() const;
    void setMyip4(const QString &value);
    QString getSend() const;
    void setSend(const QString &value);
    QString getRecive() const;
    void setRecive(const QString &value);

    Q_INVOKABLE void sendMessage();

signals:
    void myip4Changed();
    void sendChanged();
    void reciveChanged();

private:
    QString m_ip4;
    QString m_send;
    QString m_recive;
    QUdpSocket *m_sender;
    QUdpSocket *m_receiver;
private slots:
    void readMessage();
};
