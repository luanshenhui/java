/**
 * DetailTableInfo.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.soa.workflow.request;

public class DetailTableInfo  implements java.io.Serializable {
    private oa.weaver.soa.workflow.request.DetailTable[] detailTable;

    private java.lang.Integer detailTableCount;

    public DetailTableInfo() {
    }

    public DetailTableInfo(
    		oa.weaver.soa.workflow.request.DetailTable[] detailTable,
           java.lang.Integer detailTableCount) {
           this.detailTable = detailTable;
           this.detailTableCount = detailTableCount;
    }


    /**
     * Gets the detailTable value for this DetailTableInfo.
     * 
     * @return detailTable
     */
    public oa.weaver.soa.workflow.request.DetailTable[] getDetailTable() {
        return detailTable;
    }


    /**
     * Sets the detailTable value for this DetailTableInfo.
     * 
     * @param detailTable
     */
    public void setDetailTable(oa.weaver.soa.workflow.request.DetailTable[] detailTable) {
        this.detailTable = detailTable;
    }


    /**
     * Gets the detailTableCount value for this DetailTableInfo.
     * 
     * @return detailTableCount
     */
    public java.lang.Integer getDetailTableCount() {
        return detailTableCount;
    }


    /**
     * Sets the detailTableCount value for this DetailTableInfo.
     * 
     * @param detailTableCount
     */
    public void setDetailTableCount(java.lang.Integer detailTableCount) {
        this.detailTableCount = detailTableCount;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof DetailTableInfo)) return false;
        DetailTableInfo other = (DetailTableInfo) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.detailTable==null && other.getDetailTable()==null) || 
             (this.detailTable!=null &&
              java.util.Arrays.equals(this.detailTable, other.getDetailTable()))) &&
            ((this.detailTableCount==null && other.getDetailTableCount()==null) || 
             (this.detailTableCount!=null &&
              this.detailTableCount.equals(other.getDetailTableCount())));
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
        if (getDetailTable() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getDetailTable());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getDetailTable(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getDetailTableCount() != null) {
            _hashCode += getDetailTableCount().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(DetailTableInfo.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "DetailTableInfo"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("detailTable");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "detailTable"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "DetailTable"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "DetailTable"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("detailTableCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "detailTableCount"));
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
