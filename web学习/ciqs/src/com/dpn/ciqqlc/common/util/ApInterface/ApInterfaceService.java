package com.dpn.ciqqlc.common.util.ApInterface;

public interface ApInterfaceService extends javax.xml.rpc.Service {
    public java.lang.String getApInterfaceAddress();

    public com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType getApInterface() throws javax.xml.rpc.ServiceException;

    public com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType getApInterface(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
