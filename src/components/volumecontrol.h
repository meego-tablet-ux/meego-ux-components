#ifndef VolumeSTATUS_H
#define VolumeSTATUS_H

#include <pulse/volume.h>
#include <pulse/pulseaudio.h>
#include <pulse/glib-mainloop.h>

#include <QString>
#include <QObject>

class Sink
{
public:
        Sink(const pa_sink_info* sink)
        {
            update(sink);
        }
        ~Sink()
        {

        }

        void update(const pa_sink_info* sink)
        {
            m_name = QString(sink->name);
            m_index = sink->index;
            m_vol = sink->volume;
            m_mute = sink->mute;
        }

        QString name(){ return m_name; }
        uint index() { return m_index; }
        pa_cvolume volume() { return m_vol; }
        int mute() { return m_mute; }

private:
        QString m_name;
        uint m_index;
        pa_cvolume m_vol;
        int m_mute;
};


class VolumeControl: public QObject
{
        Q_OBJECT
        Q_PROPERTY(int volume READ volume WRITE setVolume NOTIFY volumeChanged)
        Q_PROPERTY(bool mute READ muted WRITE mute NOTIFY muteChanged)

public:

        VolumeControl(QObject* = 0);
        virtual ~VolumeControl();
        Sink* sink(){ return m_sink; }

        void setSink(const pa_sink_info *info)
        {
            if(!m_sink) m_sink = new Sink(info);
            else m_sink->update(info);
        }

        void update();
        void updateSink();
        void setSubscribeCallback();

        bool muted() { return sink() ? sink()->mute():false; }

public slots:
        void setVolume(int value);
        int volume() { return m_volume; }

        void mute(bool muted);

signals:
        void volumeChanged(int value);
        void muteChanged(bool muted);

private:
        void initPulse();
        void cleanup();
        int m_volume;
        Sink* m_sink;
};

#endif // VolumeSTATUS_H
