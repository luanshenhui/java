package oa.weaver.services.RequestService;

public class RequestServicePortTypeProxy implements oa.weaver.services.RequestService.RequestServicePortType {
  private String _endpoint = null;
  private oa.weaver.services.RequestService.RequestServicePortType requestServicePortType = null;
  
  public RequestServicePortTypeProxy() {
    _initRequestServicePortTypeProxy();
  }
  
  public RequestServicePortTypeProxy(String endpoint) {
    _endpoint = endpoint;
    _initRequestServicePortTypeProxy();
  }
  
  private void _initRequestServicePortTypeProxy() {
    try {
      requestServicePortType = (new oa.weaver.services.RequestService.RequestServiceLocator()).getRequestServiceHttpPort();
      if (requestServicePortType != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)requestServicePortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)requestServicePortType)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (requestServicePortType != null)
      ((javax.xml.rpc.Stub)requestServicePortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public oa.weaver.services.RequestService.RequestServicePortType getRequestServicePortType() {
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType;
  }
  
  public boolean nextNodeByReject(int in0, int in1, java.lang.String in2) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.nextNodeByReject(in0, in1, in2);
  }
  
  public oa.weaver.soa.workflow.request.Log[] getRequestLogs(java.lang.String in0, int in1, int in2) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRequestLogs(in0, in1, in2);
  }
  
  public boolean deleteRequest(int in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.deleteRequest(in0);
  }
  
  public oa.weaver.soa.workflow.request.RequestBase[] getProcessedRequestBySearch(int in0, java.lang.String in1, java.lang.String in2, java.lang.String in3) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getProcessedRequestBySearch(in0, in1, in2, in3);
  }
  
  public boolean forwardFlow(int in0, int in1, java.lang.String in2, java.lang.String in3, java.lang.String in4) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.forwardFlow(in0, in1, in2, in3, in4);
  }
  
  public java.lang.String getPropValue(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getPropValue(in0, in1);
  }
  
  public boolean nextNodeBySubmit1(oa.weaver.soa.workflow.request.RequestInfo in0, int in1, int in2, java.lang.String in3, java.lang.String in4) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.nextNodeBySubmit1(in0, in1, in2, in3, in4);
  }
  
  public oa.weaver.soa.workflow.request.RequestBase[] getHendledRequestBySearch(int in0, java.lang.String in1, java.lang.String in2, java.lang.String in3) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getHendledRequestBySearch(in0, in1, in2, in3);
  }
  
  public oa.weaver.services.RequestService.AnyType2AnyTypeMapEntry[] loadTemplateProp(java.lang.String in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.loadTemplateProp(in0);
  }
  
  public oa.weaver.soa.workflow.request.RequestBase[] getMyRequestBySearch(int in0, java.lang.String in1, java.lang.String in2, java.lang.String in3) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getMyRequestBySearch(in0, in1, in2, in3);
  }
  
  public void writeLog1(java.lang.String in0, java.lang.Object in1) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    requestServicePortType.writeLog1(in0, in1);
  }
  
  public void writeLog(java.lang.Object in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    requestServicePortType.writeLog(in0);
  }
  
  public boolean whetherMustInputRemark(int in0, int in1, int in2, int in3, int in4) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.whetherMustInputRemark(in0, in1, in2, in3, in4);
  }
  
  public java.lang.String getRightMenu(int in0, int in1, int in2, int in3, int in4, boolean in5) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRightMenu(in0, in1, in2, in3, in4, in5);
  }
  
  public java.lang.String createRequest(oa.weaver.soa.workflow.request.RequestInfo in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.createRequest(in0);
  }
  
  public oa.weaver.soa.workflow.request.RequestBase[] getPendingRequestBySearch(int in0, java.lang.String in1, java.lang.String in2, java.lang.String in3) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getPendingRequestBySearch(in0, in1, in2, in3);
  }
  
  public oa.weaver.soa.workflow.request.RequestInfo getRequest(int in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRequest(in0);
  }
  
  public oa.weaver.soa.workflow.request.RequestInfo getRequest2(int in0, int in1) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRequest2(in0, in1);
  }
  
  public oa.weaver.soa.workflow.request.RequestInfo getRequest1(oa.weaver.workflow.request.RequestManager in0) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRequest1(in0);
  }
  
  public boolean nextNodeBySubmit(oa.weaver.soa.workflow.request.RequestInfo in0, int in1, int in2, java.lang.String in3) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.nextNodeBySubmit(in0, in1, in2, in3);
  }
  
  public oa.weaver.soa.workflow.request.RequestInfo getRequest3(oa.weaver.workflow.request.RequestManager in0, int in1) throws java.rmi.RemoteException{
    if (requestServicePortType == null)
      _initRequestServicePortTypeProxy();
    return requestServicePortType.getRequest3(in0, in1);
  }
  
  
}