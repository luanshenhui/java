/**
 * RequestLog.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.soa.workflow.request;

public class RequestLog  implements java.io.Serializable {
    private oa.weaver.soa.workflow.request.Log[] log;

    private java.lang.Integer logCount;

    public RequestLog() {
    }

    public RequestLog(
    		oa.weaver.soa.workflow.request.Log[] log,
           java.lang.Integer logCount) {
           this.log = log;
           this.logCount = logCount;
    }


    /**
     * Gets the log value for this RequestLog.
     * 
     * @return log
     */
    public oa.weaver.soa.workflow.request.Log[] getLog() {
        return log;
    }


    /**
     * Sets the log value for this RequestLog.
     * 
     * @param log
     */
    public void setLog(oa.weaver.soa.workflow.request.Log[] log) {
        this.log = log;
    }


    /**
     * Gets the logCount value for this RequestLog.
     * 
     * @return logCount
     */
    public java.lang.Integer getLogCount() {
        return logCount;
    }


    /**
     * Sets the logCount value for this RequestLog.
     * 
     * @param logCount
     */
    public void setLogCount(java.lang.Integer logCount) {
        this.logCount = logCount;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RequestLog)) return false;
        RequestLog other = (RequestLog) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.log==null && other.getLog()==null) || 
             (this.log!=null &&
              java.util.Arrays.equals(this.log, other.getLog()))) &&
            ((this.logCount==null && other.getLogCount()==null) || 
             (this.logCount!=null &&
              this.logCount.equals(other.getLogCount())));
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
        if (getLog() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getLog());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getLog(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getLogCount() != null) {
            _hashCode += getLogCount().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RequestLog.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "RequestLog"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("log");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "log"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Log"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Log"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("logCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "logCount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
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
