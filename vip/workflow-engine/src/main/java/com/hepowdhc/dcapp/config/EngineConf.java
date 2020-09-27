package com.hepowdhc.dcapp.config;

/**
 *
 */
public class EngineConf {

    private int serverPort;

    private String socketHost;

    private int socketPort;

    private String title;

    private String cron;

    public String getSocketHost() {
        return socketHost;
    }

    public void setSocketHost(String socketHost) {
        this.socketHost = socketHost;
    }

    public int getSocketPort() {
        return socketPort;
    }

    public void setSocketPort(int socketPort) {
        this.socketPort = socketPort;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCron() {
        return cron;
    }

    public void setCron(String cron) {
        this.cron = cron;
    }
}
