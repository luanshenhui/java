/**
 * RequestInfo.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.soa.workflow.request;

public class RequestInfo  implements java.io.Serializable {
    private java.lang.String creatorid;

    private java.lang.String description;

    private oa.weaver.soa.workflow.request.DetailTableInfo detailTableInfo;

    private java.lang.String hostid;

    private java.lang.String isNextFlow;

    private java.lang.String lastoperator;

    private oa.weaver.soa.workflow.request.MainTableInfo mainTableInfo;

    private java.lang.String remindtype;

    private oa.weaver.soa.workflow.request.RequestLog requestLog;

    private oa.weaver.workflow.request.RequestManager requestManager;

    private java.lang.String requestid;

    private java.lang.String requestlevel;

    private oa.weaver.conn.RecordSetTrans rsTrans;

    private java.lang.String workflowid;

    public RequestInfo() {
    }

    public RequestInfo(
           java.lang.String creatorid,
           java.lang.String description,
           oa.weaver.soa.workflow.request.DetailTableInfo detailTableInfo,
           java.lang.String hostid,
           java.lang.String isNextFlow,
           java.lang.String lastoperator,
           oa.weaver.soa.workflow.request.MainTableInfo mainTableInfo,
           java.lang.String remindtype,
           oa.weaver.soa.workflow.request.RequestLog requestLog,
           oa.weaver.workflow.request.RequestManager requestManager,
           java.lang.String requestid,
           java.lang.String requestlevel,
           oa.weaver.conn.RecordSetTrans rsTrans,
           java.lang.String workflowid) {
           this.creatorid = creatorid;
           this.description = description;
           this.detailTableInfo = detailTableInfo;
           this.hostid = hostid;
           this.isNextFlow = isNextFlow;
           this.lastoperator = lastoperator;
           this.mainTableInfo = mainTableInfo;
           this.remindtype = remindtype;
           this.requestLog = requestLog;
           this.requestManager = requestManager;
           this.requestid = requestid;
           this.requestlevel = requestlevel;
           this.rsTrans = rsTrans;
           this.workflowid = workflowid;
    }


    /**
     * Gets the creatorid value for this RequestInfo.
     * 
     * @return creatorid
     */
    public java.lang.String getCreatorid() {
        return creatorid;
    }


    /**
     * Sets the creatorid value for this RequestInfo.
     * 
     * @param creatorid
     */
    public void setCreatorid(java.lang.String creatorid) {
        this.creatorid = creatorid;
    }


    /**
     * Gets the description value for this RequestInfo.
     * 
     * @return description
     */
    public java.lang.String getDescription() {
        return description;
    }


    /**
     * Sets the description value for this RequestInfo.
     * 
     * @param description
     */
    public void setDescription(java.lang.String description) {
        this.description = description;
    }


    /**
     * Gets the detailTableInfo value for this RequestInfo.
     * 
     * @return detailTableInfo
     */
    public oa.weaver.soa.workflow.request.DetailTableInfo getDetailTableInfo() {
        return detailTableInfo;
    }


    /**
     * Sets the detailTableInfo value for this RequestInfo.
     * 
     * @param detailTableInfo
     */
    public void setDetailTableInfo(oa.weaver.soa.workflow.request.DetailTableInfo detailTableInfo) {
        this.detailTableInfo = detailTableInfo;
    }


    /**
     * Gets the hostid value for this RequestInfo.
     * 
     * @return hostid
     */
    public java.lang.String getHostid() {
        return hostid;
    }


    /**
     * Sets the hostid value for this RequestInfo.
     * 
     * @param hostid
     */
    public void setHostid(java.lang.String hostid) {
        this.hostid = hostid;
    }


    /**
     * Gets the isNextFlow value for this RequestInfo.
     * 
     * @return isNextFlow
     */
    public java.lang.String getIsNextFlow() {
        return isNextFlow;
    }


    /**
     * Sets the isNextFlow value for this RequestInfo.
     * 
     * @param isNextFlow
     */
    public void setIsNextFlow(java.lang.String isNextFlow) {
        this.isNextFlow = isNextFlow;
    }


    /**
     * Gets the lastoperator value for this RequestInfo.
     * 
     * @return lastoperator
     */
    public java.lang.String getLastoperator() {
        return lastoperator;
    }


    /**
     * Sets the lastoperator value for this RequestInfo.
     * 
     * @param lastoperator
     */
    public void setLastoperator(java.lang.String lastoperator) {
        this.lastoperator = lastoperator;
    }


    /**
     * Gets the mainTableInfo value for this RequestInfo.
     * 
     * @return mainTableInfo
     */
    public oa.weaver.soa.workflow.request.MainTableInfo getMainTableInfo() {
        return mainTableInfo;
    }


    /**
     * Sets the mainTableInfo value for this RequestInfo.
     * 
     * @param mainTableInfo
     */
    public void setMainTableInfo(oa.weaver.soa.workflow.request.MainTableInfo mainTableInfo) {
        this.mainTableInfo = mainTableInfo;
    }


    /**
     * Gets the remindtype value for this RequestInfo.
     * 
     * @return remindtype
     */
    public java.lang.String getRemindtype() {
        return remindtype;
    }


    /**
     * Sets the remindtype value for this RequestInfo.
     * 
     * @param remindtype
     */
    public void setRemindtype(java.lang.String remindtype) {
        this.remindtype = remindtype;
    }


    /**
     * Gets the requestLog value for this RequestInfo.
     * 
     * @return requestLog
     */
    public oa.weaver.soa.workflow.request.RequestLog getRequestLog() {
        return requestLog;
    }


    /**
     * Sets the requestLog value for this RequestInfo.
     * 
     * @param requestLog
     */
    public void setRequestLog(oa.weaver.soa.workflow.request.RequestLog requestLog) {
        this.requestLog = requestLog;
    }


    /**
     * Gets the requestManager value for this RequestInfo.
     * 
     * @return requestManager
     */
    public oa.weaver.workflow.request.RequestManager getRequestManager() {
        return requestManager;
    }


    /**
     * Sets the requestManager value for this RequestInfo.
     * 
     * @param requestManager
     */
    public void setRequestManager(oa.weaver.workflow.request.RequestManager requestManager) {
        this.requestManager = requestManager;
    }


    /**
     * Gets the requestid value for this RequestInfo.
     * 
     * @return requestid
     */
    public java.lang.String getRequestid() {
        return requestid;
    }


    /**
     * Sets the requestid value for this RequestInfo.
     * 
     * @param requestid
     */
    public void setRequestid(java.lang.String requestid) {
        this.requestid = requestid;
    }


    /**
     * Gets the requestlevel value for this RequestInfo.
     * 
     * @return requestlevel
     */
    public java.lang.String getRequestlevel() {
        return requestlevel;
    }


    /**
     * Sets the requestlevel value for this RequestInfo.
     * 
     * @param requestlevel
     */
    public void setRequestlevel(java.lang.String requestlevel) {
        this.requestlevel = requestlevel;
    }


    /**
     * Gets the rsTrans value for this RequestInfo.
     * 
     * @return rsTrans
     */
    public oa.weaver.conn.RecordSetTrans getRsTrans() {
        return rsTrans;
    }


    /**
     * Sets the rsTrans value for this RequestInfo.
     * 
     * @param rsTrans
     */
    public void setRsTrans(oa.weaver.conn.RecordSetTrans rsTrans) {
        this.rsTrans = rsTrans;
    }


    /**
     * Gets the workflowid value for this RequestInfo.
     * 
     * @return workflowid
     */
    public java.lang.String getWorkflowid() {
        return workflowid;
    }


    /**
     * Sets the workflowid value for this RequestInfo.
     * 
     * @param workflowid
     */
    public void setWorkflowid(java.lang.String workflowid) {
        this.workflowid = workflowid;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RequestInfo)) return false;
        RequestInfo other = (RequestInfo) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.creatorid==null && other.getCreatorid()==null) || 
             (this.creatorid!=null &&
              this.creatorid.equals(other.getCreatorid()))) &&
            ((this.description==null && other.getDescription()==null) || 
             (this.description!=null &&
              this.description.equals(other.getDescription()))) &&
            ((this.detailTableInfo==null && other.getDetailTableInfo()==null) || 
             (this.detailTableInfo!=null &&
              this.detailTableInfo.equals(other.getDetailTableInfo()))) &&
            ((this.hostid==null && other.getHostid()==null) || 
             (this.hostid!=null &&
              this.hostid.equals(other.getHostid()))) &&
            ((this.isNextFlow==null && other.getIsNextFlow()==null) || 
             (this.isNextFlow!=null &&
              this.isNextFlow.equals(other.getIsNextFlow()))) &&
            ((this.lastoperator==null && other.getLastoperator()==null) || 
             (this.lastoperator!=null &&
              this.lastoperator.equals(other.getLastoperator()))) &&
            ((this.mainTableInfo==null && other.getMainTableInfo()==null) || 
             (this.mainTableInfo!=null &&
              this.mainTableInfo.equals(other.getMainTableInfo()))) &&
            ((this.remindtype==null && other.getRemindtype()==null) || 
             (this.remindtype!=null &&
              this.remindtype.equals(other.getRemindtype()))) &&
            ((this.requestLog==null && other.getRequestLog()==null) || 
             (this.requestLog!=null &&
              this.requestLog.equals(other.getRequestLog()))) &&
            ((this.requestManager==null && other.getRequestManager()==null) || 
             (this.requestManager!=null &&
              this.requestManager.equals(other.getRequestManager()))) &&
            ((this.requestid==null && other.getRequestid()==null) || 
             (this.requestid!=null &&
              this.requestid.equals(other.getRequestid()))) &&
            ((this.requestlevel==null && other.getRequestlevel()==null) || 
             (this.requestlevel!=null &&
              this.requestlevel.equals(other.getRequestlevel()))) &&
            ((this.rsTrans==null && other.getRsTrans()==null) || 
             (this.rsTrans!=null &&
              this.rsTrans.equals(other.getRsTrans()))) &&
            ((this.workflowid==null && other.getWorkflowid()==null) || 
             (this.workflowid!=null &&
              this.workflowid.equals(other.getWorkflowid())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getCreatorid() != null) {
            _hashCode += getCreatorid().hashCode();
        }
        if (getDescription() != null) {
            _hashCode += getDescription().hashCode();
        }
        if (getDetailTableInfo() != null) {
            _hashCode += getDetailTableInfo().hashCode();
        }
        if (getHostid() != null) {
            _hashCode += getHostid().hashCode();
        }
        if (getIsNextFlow() != null) {
            _hashCode += getIsNextFlow().hashCode();
        }
        if (getLastoperator() != null) {
            _hashCode += getLastoperator().hashCode();
        }
        if (getMainTableInfo() != null) {
            _hashCode += getMainTableInfo().hashCode();
        }
        if (getRemindtype() != null) {
            _hashCode += getRemindtype().hashCode();
        }
        if (getRequestLog() != null) {
            _hashCode += getRequestLog().hashCode();
        }
        if (getRequestManager() != null) {
            _hashCode += getRequestManager().hashCode();
        }
        if (getRequestid() != null) {
            _hashCode += getRequestid().hashCode();
        }
        if (getRequestlevel() != null) {
            _hashCode += getRequestlevel().hashCode();
        }
        if (getRsTrans() != null) {
            _hashCode += getRsTrans().hashCode();
        }
        if (getWorkflowid() != null) {
            _hashCode += getWorkflowid().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RequestInfo.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "RequestInfo"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("creatorid");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "creatorid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("description");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "description"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("detailTableInfo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "detailTableInfo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "DetailTableInfo"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("hostid");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "hostid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("isNextFlow");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "isNextFlow"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("lastoperator");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "lastoperator"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mainTableInfo");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "mainTableInfo"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "MainTableInfo"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("remindtype");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "remindtype"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requestLog");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "requestLog"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "RequestLog"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requestManager");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "requestManager"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.weaver", "RequestManager"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requestid");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "requestid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("requestlevel");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "requestlevel"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("rsTrans");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "rsTrans"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://conn.weaver", "RecordSetTrans"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("workflowid");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "workflowid"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
