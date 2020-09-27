/**
 * RecordSetTrans.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package oa.weaver.conn;

public class RecordSetTrans  implements java.io.Serializable {
    private java.lang.String DBType;

    private java.lang.Boolean checksql;

    private java.lang.Integer colCounts;

    private java.lang.String[] columnName;

    private int[] columnType;

    private java.lang.Integer counts;

    private java.lang.Integer flag;

    private java.lang.String msg;

    public RecordSetTrans() {
    }

    public RecordSetTrans(
           java.lang.String DBType,
           java.lang.Boolean checksql,
           java.lang.Integer colCounts,
           java.lang.String[] columnName,
           int[] columnType,
           java.lang.Integer counts,
           java.lang.Integer flag,
           java.lang.String msg) {
           this.DBType = DBType;
           this.checksql = checksql;
           this.colCounts = colCounts;
           this.columnName = columnName;
           this.columnType = columnType;
           this.counts = counts;
           this.flag = flag;
           this.msg = msg;
    }


    /**
     * Gets the DBType value for this RecordSetTrans.
     * 
     * @return DBType
     */
    public java.lang.String getDBType() {
        return DBType;
    }


    /**
     * Sets the DBType value for this RecordSetTrans.
     * 
     * @param DBType
     */
    public void setDBType(java.lang.String DBType) {
        this.DBType = DBType;
    }


    /**
     * Gets the checksql value for this RecordSetTrans.
     * 
     * @return checksql
     */
    public java.lang.Boolean getChecksql() {
        return checksql;
    }


    /**
     * Sets the checksql value for this RecordSetTrans.
     * 
     * @param checksql
     */
    public void setChecksql(java.lang.Boolean checksql) {
        this.checksql = checksql;
    }


    /**
     * Gets the colCounts value for this RecordSetTrans.
     * 
     * @return colCounts
     */
    public java.lang.Integer getColCounts() {
        return colCounts;
    }


    /**
     * Sets the colCounts value for this RecordSetTrans.
     * 
     * @param colCounts
     */
    public void setColCounts(java.lang.Integer colCounts) {
        this.colCounts = colCounts;
    }


    /**
     * Gets the columnName value for this RecordSetTrans.
     * 
     * @return columnName
     */
    public java.lang.String[] getColumnName() {
        return columnName;
    }


    /**
     * Sets the columnName value for this RecordSetTrans.
     * 
     * @param columnName
     */
    public void setColumnName(java.lang.String[] columnName) {
        this.columnName = columnName;
    }


    /**
     * Gets the columnType value for this RecordSetTrans.
     * 
     * @return columnType
     */
    public int[] getColumnType() {
        return columnType;
    }


    /**
     * Sets the columnType value for this RecordSetTrans.
     * 
     * @param columnType
     */
    public void setColumnType(int[] columnType) {
        this.columnType = columnType;
    }


    /**
     * Gets the counts value for this RecordSetTrans.
     * 
     * @return counts
     */
    public java.lang.Integer getCounts() {
        return counts;
    }


    /**
     * Sets the counts value for this RecordSetTrans.
     * 
     * @param counts
     */
    public void setCounts(java.lang.Integer counts) {
        this.counts = counts;
    }


    /**
     * Gets the flag value for this RecordSetTrans.
     * 
     * @return flag
     */
    public java.lang.Integer getFlag() {
        return flag;
    }


    /**
     * Sets the flag value for this RecordSetTrans.
     * 
     * @param flag
     */
    public void setFlag(java.lang.Integer flag) {
        this.flag = flag;
    }


    /**
     * Gets the msg value for this RecordSetTrans.
     * 
     * @return msg
     */
    public java.lang.String getMsg() {
        return msg;
    }


    /**
     * Sets the msg value for this RecordSetTrans.
     * 
     * @param msg
     */
    public void setMsg(java.lang.String msg) {
        this.msg = msg;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof RecordSetTrans)) return false;
        RecordSetTrans other = (RecordSetTrans) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.DBType==null && other.getDBType()==null) || 
             (this.DBType!=null &&
              this.DBType.equals(other.getDBType()))) &&
            ((this.checksql==null && other.getChecksql()==null) || 
             (this.checksql!=null &&
              this.checksql.equals(other.getChecksql()))) &&
            ((this.colCounts==null && other.getColCounts()==null) || 
             (this.colCounts!=null &&
              this.colCounts.equals(other.getColCounts()))) &&
            ((this.columnName==null && other.getColumnName()==null) || 
             (this.columnName!=null &&
              java.util.Arrays.equals(this.columnName, other.getColumnName()))) &&
            ((this.columnType==null && other.getColumnType()==null) || 
             (this.columnType!=null &&
              java.util.Arrays.equals(this.columnType, other.getColumnType()))) &&
            ((this.counts==null && other.getCounts()==null) || 
             (this.counts!=null &&
              this.counts.equals(other.getCounts()))) &&
            ((this.flag==null && other.getFlag()==null) || 
             (this.flag!=null &&
              this.flag.equals(other.getFlag()))) &&
            ((this.msg==null && other.getMsg()==null) || 
             (this.msg!=null &&
              this.msg.equals(other.getMsg())));
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
        if (getDBType() != null) {
            _hashCode += getDBType().hashCode();
        }
        if (getChecksql() != null) {
            _hashCode += getChecksql().hashCode();
        }
        if (getColCounts() != null) {
            _hashCode += getColCounts().hashCode();
        }
        if (getColumnName() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getColumnName());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getColumnName(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getColumnType() != null) {
            for (int i=0;
                 i<java.lang.reflect.Array.getLength(getColumnType());
                 i++) {
                java.lang.Object obj = java.lang.reflect.Array.get(getColumnType(), i);
                if (obj != null &&
                    !obj.getClass().isArray()) {
                    _hashCode += obj.hashCode();
                }
            }
        }
        if (getCounts() != null) {
            _hashCode += getCounts().hashCode();
        }
        if (getFlag() != null) {
            _hashCode += getFlag().hashCode();
        }
        if (getMsg() != null) {
            _hashCode += getMsg().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(RecordSetTrans.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://conn.weaver", "RecordSetTrans"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("DBType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "DBType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("checksql");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "checksql"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "boolean"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("colCounts");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "colCounts"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("columnName");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "columnName"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "string"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("columnType");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "columnType"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        elemField.setItemQName(new javax.xml.namespace.QName("http://oa.rcmtm.com/services/RequestService", "int"));
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("counts");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "counts"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("flag");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "flag"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"));
        elemField.setMinOccurs(0);
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("msg");
        elemField.setXmlName(new javax.xml.namespace.QName("http://conn.weaver", "msg"));
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
