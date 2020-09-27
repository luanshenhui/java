/**
 * GetRequest3.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.services.RequestService;

public class GetRequest3  implements java.io.Serializable {
    private oa.weaver.workflow.request.RequestManager in0;

    private int in1;

    public GetRequest3() {
    }

    public GetRequest3(
    		oa.weaver.workflow.request.RequestManager in0,
           int in1) {
           this.in0 = in0;
           this.in1 = in1;
    }


    /**
     * Gets the in0 value for this GetRequest3.
     * 
     * @return in0
     */
    public oa.weaver.workflow.request.RequestManager getIn0() {
        return in0;
    }


    /**
     * Sets the in0 value for this GetRequest3.
     * 
     * @param in0
     */
    public void setIn0(oa.weaver.workflow.request.RequestManager in0) {
        this.in0 = in0;
    }


    /**
     * Gets the in1 value for this GetRequest3.
     * 
     * @return in1
     */
    public int getIn1() {
        return in1;
    }


    /**
     * Sets the in1 value for this GetRequest3.
     * 
     * @param in1
     */
    public void setIn1(int in1) {
        this.in1 = in1;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof GetRequest3)) return false;
        GetRequest3 other = (GetRequest3) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.in0==null && other.getIn0()==null) || 
             (this.in0!=null &&
              this.in0.equals(other.getIn0()))) &&
            this.in1 == other.getIn1();
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
        if (getIn0() != null) {
            _hashCode += getIn0().hashCode();
        }
        _hashCode += getIn1();
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(GetRequest3.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", ">getRequest3"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("in0");
        elemField.setXmlName(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "in0"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.weaver", "RequestManager"));
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("in1");
        elemField.setXmlName(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "in1"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
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
