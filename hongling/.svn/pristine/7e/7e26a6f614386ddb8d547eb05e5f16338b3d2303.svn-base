/**
 * IServiceToLogisticsServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package rcmtm.endpoint;

public class IServiceToLogisticsServiceLocator extends org.apache.axis.client.Service implements rcmtm.endpoint.IServiceToLogisticsService {

    public IServiceToLogisticsServiceLocator() {
    }


    public IServiceToLogisticsServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public IServiceToLogisticsServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for IServiceToLogisticsPort
    private java.lang.String IServiceToLogisticsPort_address = "http://172.16.6.78/Services/services/LogisticService";

    public java.lang.String getIServiceToLogisticsPortAddress() {
        return IServiceToLogisticsPort_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String IServiceToLogisticsPortWSDDServiceName = "IServiceToLogisticsPort";

    public java.lang.String getIServiceToLogisticsPortWSDDServiceName() {
        return IServiceToLogisticsPortWSDDServiceName;
    }

    public void setIServiceToLogisticsPortWSDDServiceName(java.lang.String name) {
        IServiceToLogisticsPortWSDDServiceName = name;
    }

    public rcmtm.endpoint.IServiceToLogistics getIServiceToLogisticsPort() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(IServiceToLogisticsPort_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getIServiceToLogisticsPort(endpoint);
    }

    public rcmtm.endpoint.IServiceToLogistics getIServiceToLogisticsPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            rcmtm.endpoint.IServiceToLogisticsServiceSoapBindingStub _stub = new rcmtm.endpoint.IServiceToLogisticsServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getIServiceToLogisticsPortWSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setIServiceToLogisticsPortEndpointAddress(java.lang.String address) {
        IServiceToLogisticsPort_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (rcmtm.endpoint.IServiceToLogistics.class.isAssignableFrom(serviceEndpointInterface)) {
                rcmtm.endpoint.IServiceToLogisticsServiceSoapBindingStub _stub = new rcmtm.endpoint.IServiceToLogisticsServiceSoapBindingStub(new java.net.URL(IServiceToLogisticsPort_address), this);
                _stub.setPortName(getIServiceToLogisticsPortWSDDServiceName());
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
        if ("IServiceToLogisticsPort".equals(inputPortName)) {
            return getIServiceToLogisticsPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://services.redcollar.cn/", "IServiceToLogisticsService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://services.redcollar.cn/", "IServiceToLogisticsPort"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("IServiceToLogisticsPort".equals(portName)) {
            setIServiceToLogisticsPortEndpointAddress(address);
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
