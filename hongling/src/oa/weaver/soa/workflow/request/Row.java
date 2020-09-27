/**
 * Row.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.soa.workflow.request;

public class Row  implements java.io.Serializable {
    private oa.weaver.soa.workflow.request.Cell[] cell;

    private java.lang.Integer cellCount;

    private java.lang.String id;

    public Row() {
    }

    public Row(
    		oa.weaver.soa.workflow.request.Cell[] cell,
           java.lang.Integer cellCount,
           java.lang.String id) {
           this.cell = cell;
           this.cellCount = cellCount;
           this.id = id;
    }


    /**
     * Gets the cell value for this Row.
     * 
     * @return cell
     */
    public oa.weaver.soa.workflow.request.Cell[] getCell() {
        return cell;
    }


    /**
     * Sets the cell value for this Row.
     * 
     * @param cell
     */
    public void setCell(oa.weaver.soa.workflow.request.Cell[] cell) {
        this.cell = cell;
    }


    /**
     * Gets the cellCount value for this Row.
     * 
     * @return cellCount
     */
    public java.lang.Integer getCellCount() {
        return cellCount;
    }


    /**
     * Sets the cellCount value for this Row.
     * 
     * @param cellCount
     */
    public void setCellCount(java.lang.Integer cellCount) {
        this.cellCount = cellCount;
    }


    /**
     * Gets the id value for this Row.
     * 
     * @return id
     */
    public java.lang.String getId() {
        return id;
    }


    /**
     * Sets the id value for this Row.
     * 
     * @param id
     */
    public void setId(java.lang.String id) {
        this.id = id;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof Row)) return false;
        Row other = (Row) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.cell==null && other.getCell()==null) || 
             (this.cell!=null &&
              java.util.Arrays.equals(this.cell, other.getCell()))) &&
            ((this.cellCount==null && other.getCellCount()==null) || 
             (this.cellCount!=null &&
              this.cellCount.equals(other.getCellCount()))) &&
            ((this.id==null && other.getId()==null) || 
             (this.id!=null &&
              this.id.equals(other.getId())));
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
        if (getCell() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getCell());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getCell(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getCellCount() != null) {
            _hashCode += getCellCount().hashCode();
        }
        if (getId() != null) {
            _hashCode += getId().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(Row.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Row"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cell");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "cell"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Cell"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "Cell"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("cellCount");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "cellCount"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("id");
        elemField.setXmlName(new javax.xml.namespace.QName("http://request.workflow.soa.weaver", "id"));
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
