package com.dpn.ciqqlc.common.util.ApInterface;

public interface ApInterface_PortType extends java.rmi.Remote {
    public java.lang.String smsReceive(java.lang.String message) throws java.rmi.RemoteException;
    public java.lang.String smsGetReport(java.lang.String message) throws java.rmi.RemoteException;
    public java.lang.String smsSend(java.lang.String message) throws java.rmi.RemoteException;
}
