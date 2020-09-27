/**
 * RequestServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.services.RequestService;

public class RequestServiceLocator extends org.apache.axis.client.Service implements oa.weaver.services.RequestService.RequestService {

    public RequestServiceLocator() {
    }


    public RequestServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public RequestServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for RequestServiceHttpPort
    private java.lang.String RequestServiceHttpPort_address = "http://oa.rcmtm.com/services/RequestService";

    public java.lang.String getRequestServiceHttpPortAddress() {
        return RequestServiceHttpPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String RequestServiceHttpPortWSDDServiceName = "RequestServiceHttpPort";

    public java.lang.String getRequestServiceHttpPortWSDDServiceName() {
        return RequestServiceHttpPortWSDDServiceName;
    }

    public void setRequestServiceHttpPortWSDDServiceName(java.lang.String name) {
        RequestServiceHttpPortWSDDServiceName = name;
    }

    public oa.weaver.services.RequestService.RequestServicePortType getRequestServiceHttpPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(RequestServiceHttpPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getRequestServiceHttpPort(endpoint);
    }

    public oa.weaver.services.RequestService.RequestServicePortType getRequestServiceHttpPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
        	oa.weaver.services.RequestService.RequestServiceHttpBindingStub _stub = new oa.weaver.services.RequestService.RequestServiceHttpBindingStub(portAddress, this);
            _stub.setPortName(getRequestServiceHttpPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setRequestServiceHttpPortEndpointAddress(java.lang.String address) {
        RequestServiceHttpPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (oa.weaver.services.RequestService.RequestServicePortType.class.isAssignableFrom(serviceEndpointInterface)) {
            	oa.weaver.services.RequestService.RequestServiceHttpBindingStub _stub = new oa.weaver.services.RequestService.RequestServiceHttpBindingStub(new java.net.URL(RequestServiceHttpPort_address), this);
                _stub.setPortName(getRequestServiceHttpPortWSDDServiceName());
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
        if ("RequestServiceHttpPort".equals(inputPortName)) {
            return getRequestServiceHttpPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "RequestService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "RequestServiceHttpPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("RequestServiceHttpPort".equals(portName)) {
            setRequestServiceHttpPortEndpointAddress(address);
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
