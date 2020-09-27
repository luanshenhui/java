/**
 * IServiceToBxppServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package chinsoft.wsdl;

import chinsoft.core.ConfigHelper;
import chinsoft.core.Utility;

public class IServiceToBxppServiceLocator extends org.apache.axis.client.Service implements chinsoft.wsdl.IServiceToBxppService {

    public IServiceToBxppServiceLocator() {
    }


    public IServiceToBxppServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public IServiceToBxppServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for IServiceToBxppPort
//    private java.lang.String IServiceToBxppPort_address = "http://172.16.6.78/Services/services/BxppService";
    private java.lang.String IServiceToBxppPort_address =Utility.toSafeString(ConfigHelper.getContextParam().get("WebService_Bxpp_Address"));
    public java.lang.String getIServiceToBxppPortAddress() {
        return IServiceToBxppPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String IServiceToBxppPortWSDDServiceName = "IServiceToBxppPort";

    public java.lang.String getIServiceToBxppPortWSDDServiceName() {
        return IServiceToBxppPortWSDDServiceName;
    }

    public void setIServiceToBxppPortWSDDServiceName(java.lang.String name) {
        IServiceToBxppPortWSDDServiceName = name;
    }

    public chinsoft.wsdl.IServiceToBxpp getIServiceToBxppPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(IServiceToBxppPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getIServiceToBxppPort(endpoint);
    }

    public chinsoft.wsdl.IServiceToBxpp getIServiceToBxppPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	chinsoft.wsdl.IServiceToBxppServiceSoapBindingStub _stub = new chinsoft.wsdl.IServiceToBxppServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getIServiceToBxppPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setIServiceToBxppPortEndpointAddress(java.lang.String address) {
        IServiceToBxppPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (chinsoft.wsdl.IServiceToBxpp.class.isAssignableFrom(serviceEndpointInterface)) {
            	chinsoft.wsdl.IServiceToBxppServiceSoapBindingStub _stub = new chinsoft.wsdl.IServiceToBxppServiceSoapBindingStub(new java.net.URL(IServiceToBxppPort_address), this);
                _stub.setPortName(getIServiceToBxppPortWSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("IServiceToBxppPort".equals(inputPortName)) {
            return getIServiceToBxppPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://services.redcollar.cn/", "IServiceToBxppService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://services.redcollar.cn/", "IServiceToBxppPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("IServiceToBxppPort".equals(portName)) {
            setIServiceToBxppPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
