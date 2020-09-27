/**
 * IServiceToBxpp.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package chinsoft.wsdl;

public interface IServiceToBxpp extends java.rmi.Remote {
    public java.lang.String doOrderToERP(java.lang.String arg0, java.lang.String arg1, java.lang.String arg2) throws java.rmi.RemoteException;
    public java.lang.String getOrderByEcodeIsXml(java.lang.String arg0) throws java.rmi.RemoteException;
    public java.lang.String doPaymentOrder(java.lang.String arg0, java.lang.String arg1) throws java.rmi.RemoteException;
    public java.lang.String doDelOrder(java.lang.String arg0) throws java.rmi.RemoteException;
    public java.lang.String getFabrics(java.lang.String arg0, java.lang.String arg1, java.lang.String arg2, java.lang.String arg3, java.lang.String arg4, java.lang.String arg5, java.lang.String arg6, java.lang.String arg7) throws java.rmi.RemoteException;
    public java.lang.String doSaveOrder(java.lang.String arg0) throws java.rmi.RemoteException;
    public java.lang.String doFabricDischarged(java.lang.String arg0, java.lang.String arg1) throws java.rmi.RemoteException;
    public java.lang.String doSaveDeliveryTime(java.lang.String arg0, java.lang.String arg1) throws java.rmi.RemoteException;
    public java.lang.String doAdvanceSaveOrder(java.lang.String arg0, java.lang.String arg1, java.lang.String arg2, java.lang.String arg3) throws java.rmi.RemoteException;
}
