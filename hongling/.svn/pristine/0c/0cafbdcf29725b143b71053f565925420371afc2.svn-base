/**
 * MainTableInfo.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.soa.workflow.request;

public class MainTableInfo  implements java.io.Serializable {
    private oa.weaver.soa.workflow.request.Property[] property;

    private java.lang.Integer propertyCount;

    public MainTableInfo() {
    }

    public MainTableInfo(
    		oa.weaver.soa.workflow.request.Property[] property,
           java.lang.Integer propertyCount) {
           this.property = property;
           this.propertyCount = propertyCount;
    }


    /**
     * Gets the property value for this MainTableInfo.
     * 
     * @return property
     */
    public oa.weaver.soa.workflow.request.Property[] getProperty() {
        return property;
    }


    /**
     * Sets the property value for this MainTableInfo.
     * 
     * @param property
     */
    public void setProperty(oa.weaver.soa.workflow.request.Property[] property) {
        this.property = property;
    }


    /**
     * Gets the propertyCount value for this MainTableInfo.
     * 
     * @return propertyCount
     */
    public java.lang.Integer getPropertyCount() {
        return propertyCount;
    }


    /**
     * Sets the propertyCount value for this MainTableInfo.
     * 
     * @param propertyCount
     */
    public void setPropertyCount(java.lang.Integer propertyCount) {
        this.propertyCount = propertyCount;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof MainTableInfo)) return false;
        MainTableInfo other = (MainTableInfo) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.property==null && other.getProperty()==null) || 
             (this.property!=null &&
              java.util.Arrays.equals(this.property, other.getProperty()))) &&
            ((this.propertyCount==null && other.getPropertyCount()==null) || 
             (this.propertyCount!=null &&
              this.propertyCount.equals(other.getPropertyCount())));
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
        if (getProperty() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getProperty());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getProperty(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getPropertyCount() != null) {
            _hashCode += getPropertyCount().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(MainTableInfo.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "MainTableInfo"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("property");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "property"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Property"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Property"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("propertyCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "propertyCount"));
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
