package com.dpn.ciqqlc.common.util.ApInterface;

public class ApInterfaceServiceLocator extends org.apache.axis.client.Service implements com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceService {

    public ApInterfaceServiceLocator() {
    }


    public ApInterfaceServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public ApInterfaceServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for ApInterface
    private java.lang.String ApInterface_address = "http://10.21.255.40/services/ApInterface";

    public java.lang.String getApInterfaceAddress() {
        return ApInterface_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String ApInterfaceWSDDServiceName = "ApInterface";

    public java.lang.String getApInterfaceWSDDServiceName() {
        return ApInterfaceWSDDServiceName;
    }

    public void setApInterfaceWSDDServiceName(java.lang.String name) {
        ApInterfaceWSDDServiceName = name;
    }

    public com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType getApInterface() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(ApInterface_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getApInterface(endpoint);
    }

    public com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType getApInterface(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceSoapBindingStub _stub = new com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceSoapBindingStub(portAddress, this);
            _stub.setPortName(getApInterfaceWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setApInterfaceEndpointAddress(java.lang.String address) {
        ApInterface_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (com.dpn.ciqqlc.common.util.ApInterface.ApInterface_PortType.class.isAssignableFrom(serviceEndpointInterface)) {
                com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceSoapBindingStub _stub = new com.dpn.ciqqlc.common.util.ApInterface.ApInterfaceSoapBindingStub(new java.net.URL(ApInterface_address), this);
                _stub.setPortName(getApInterfaceWSDDServiceName());
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
        if ("ApInterface".equals(inputPortName)) {
            return getApInterface();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://10.21.255.40/services/ApInterface", "ApInterfaceService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://10.21.255.40/services/ApInterface", "ApInterface"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("ApInterface".equals(portName)) {
            setApInterfaceEndpointAddress(address);
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
