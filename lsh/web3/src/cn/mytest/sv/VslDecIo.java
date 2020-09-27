
package cn.mytest.sv;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for vslDecIo complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="vslDecIo">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="ID" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VSL_CN_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VSL_EN_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "vslDecIo", propOrder = {
    "id",
    "vslcnname",
    "vslenname"
})
public class VslDecIo {

    @XmlElement(name = "ID")
    protected String id;
    @XmlElement(name = "VSL_CN_NAME")
    protected String vslcnname;
    @XmlElement(name = "VSL_EN_NAME")
    protected String vslenname;

    /**
     * Gets the value of the id property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getID() {
        return id;
    }

    /**
     * Sets the value of the id property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setID(String value) {
        this.id = value;
    }

    /**
     * Gets the value of the vslcnname property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVSLCNNAME() {
        return vslcnname;
    }

    /**
     * Sets the value of the vslcnname property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVSLCNNAME(String value) {
        this.vslcnname = value;
    }

    /**
     * Gets the value of the vslenname property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVSLENNAME() {
        return vslenname;
    }

    /**
     * Sets the value of the vslenname property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVSLENNAME(String value) {
        this.vslenname = value;
    }

}
