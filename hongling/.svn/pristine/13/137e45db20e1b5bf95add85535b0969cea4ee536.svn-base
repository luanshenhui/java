package oa.weaver.services.HrmService;

public class HrmServicePortTypeProxy implements oa.weaver.services.HrmService.HrmServicePortType {
  private String _endpoint = null;
  private oa.weaver.services.HrmService.HrmServicePortType hrmServicePortType = null;
  
  public HrmServicePortTypeProxy() {
    _initHrmServicePortTypeProxy();
  }
  
  public HrmServicePortTypeProxy(String endpoint) {
    _endpoint = endpoint;
    _initHrmServicePortTypeProxy();
  }
  
  private void _initHrmServicePortTypeProxy() {
    try {
      hrmServicePortType = (new oa.weaver.services.HrmService.HrmServiceLocator()).getHrmServiceHttpPort();
      if (hrmServicePortType != null) {
        if (_endpoint != null)
          ((javax.xml.rpc.Stub)hrmServicePortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((javax.xml.rpc.Stub)hrmServicePortType)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (javax.xml.rpc.ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (hrmServicePortType != null)
      ((javax.xml.rpc.Stub)hrmServicePortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public oa.weaver.services.HrmService.HrmServicePortType getHrmServicePortType() {
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType;
  }
  
  public java.lang.String synSubCompany(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.synSubCompany(in0, in1);
  }
  
  public java.lang.String getPropValue(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.getPropValue(in0, in1);
  }
  
  public oa.weaver.hrm.webservice.DepartmentBean[] getHrmDepartmentInfo(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.getHrmDepartmentInfo(in0, in1);
  }
  
  public oa.weaver.hrm.webservice.UserBean[] getHrmUserInfo(java.lang.String in0, java.lang.String in1, java.lang.String in2, java.lang.String in3, java.lang.String in4, java.lang.String in5) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.getHrmUserInfo(in0, in1, in2, in3, in4, in5);
  }
  
  public boolean checkUser(java.lang.String in0, java.lang.String in1, java.lang.String in2) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.checkUser(in0, in1, in2);
  }
  
  public oa.weaver.hrm.webservice.JobTitleBean[] getHrmJobTitleInfo(java.lang.String in0, java.lang.String in1, java.lang.String in2) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.getHrmJobTitleInfo(in0, in1, in2);
  }
  
  public boolean changeUserPassword(java.lang.String in0, java.lang.String in1, java.lang.String in2) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.changeUserPassword(in0, in1, in2);
  }
  
  public oa.weaver.services.HrmService.AnyType2AnyTypeMapEntry[] loadTemplateProp(java.lang.String in0) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.loadTemplateProp(in0);
  }
  
  public java.lang.String synDepartment(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.synDepartment(in0, in1);
  }
  
  public void writeLog1(java.lang.String in0, java.lang.Object in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    hrmServicePortType.writeLog1(in0, in1);
  }
  
  public java.lang.String synJobtitle(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.synJobtitle(in0, in1);
  }
  
  public void writeLog(java.lang.Object in0) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    hrmServicePortType.writeLog(in0);
  }
  
  public java.lang.String synHrmResource(java.lang.String in0, java.lang.String in1) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.synHrmResource(in0, in1);
  }
  
  public oa.weaver.hrm.webservice.SubCompanyBean[] getHrmSubcompanyInfo(java.lang.String in0) throws java.rmi.RemoteException{
    if (hrmServicePortType == null)
      _initHrmServicePortTypeProxy();
    return hrmServicePortType.getHrmSubcompanyInfo(in0);
  }
  
  
}