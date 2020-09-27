package rcmtm.endpoint;

public class IServiceToLogisticsProxy implements rcmtm.endpoint.IServiceToLogistics {
  private String _endpoint = null;
  private rcmtm.endpoint.IServiceToLogistics iServiceToLogistics = null;
  
  public IServiceToLogisticsProxy() {
    _initIServiceToLogisticsProxy();
  }
  
  public IServiceToLogisticsProxy(String endpoint) {
    _endpoint = endpoint;
    _initIServiceToLogisticsProxy();
  }
  
  private void _initIServiceToLogisticsProxy() {
    try {
      iServiceToLogistics = (new rcmtm.endpoint.IServiceToLogisticsServiceLocator()).getIServiceToLogisticsPort();
      if (iServiceToLogistics != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)iServiceToLogistics)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)iServiceToLogistics)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (iServiceToLogistics != null)
      ((javax.xml.rpc.Stub)iServiceToLogistics)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public rcmtm.endpoint.IServiceToLogistics getIServiceToLogistics() {
    if (iServiceToLogistics == null)
      _initIServiceToLogisticsProxy();
    return iServiceToLogistics;
  }
  
  public java.lang.String doSaveLogistic(java.lang.String arg0) throws java.rmi.RemoteException{
    if (iServiceToLogistics == null)
      _initIServiceToLogisticsProxy();
    return iServiceToLogistics.doSaveLogistic(arg0);
  }
  
  
}