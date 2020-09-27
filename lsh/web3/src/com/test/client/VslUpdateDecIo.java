
package com.test.client;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for vslUpdateDecIo complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="vslUpdateDecIo">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="APPROVE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="APPROVE_USER" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="CALL_SIGN" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="CHECK_RST" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="COUNTRY_CN_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="COUNTRY_EN_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="CUR_CARGO_SIT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DEC_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DEC_ORG" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="DEC_USER" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="EST_ARRIV_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HAVE_BIER" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HAVE_CORPSE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HAVING_CORPSE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HAVING_MDK_MDI_CPS" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HAVING_PATIENT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="HIS_CARGO_SIT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="INSP_ORG_CODE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="INSP_ORG_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="LAST_FOUR_PORT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="LOAD_PORT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="NET_TON" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="QUAR_TYPE_APPR" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="QUAR_TYPE_DEC" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="SHIPPER_PSN_NUM" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="SHIP_SANIT_CERT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="SHIP_TYPE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="START_SHIP_SIT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TOTAL_TON" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="TRAF_CERT" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VISITOR_PSN_NUM" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VOYAGE_NO" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VSL_CN_NAME" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="VSL_DEC_ID" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
@XmlType(name = "vslUpdateDecIo", propOrder = {
    "approvedate",
    "approveuser",
    "callsign",
    "checkrst",
    "countrycnname",
    "countryenname",
    "curcargosit",
    "decdate",
    "decorg",
    "decuser",
    "estarrivdate",
    "havebier",
    "havecorpse",
    "havingcorpse",
    "havingmdkmdicps",
    "havingpatient",
    "hiscargosit",
    "insporgcode",
    "insporgname",
    "lastfourport",
    "loadport",
    "netton",
    "quartypeappr",
    "quartypedec",
    "shipperpsnnum",
    "shipsanitcert",
    "shiptype",
    "startshipsit",
    "totalton",
    "trafcert",
    "visitorpsnnum",
    "voyageno",
    "vslcnname",
    "vsldecid",
    "vslenname"
})
public class VslUpdateDecIo {

    @XmlElement(name = "APPROVE_DATE")
    protected String approvedate;
    @XmlElement(name = "APPROVE_USER")
    protected String approveuser;
    @XmlElement(name = "CALL_SIGN")
    protected String callsign;
    @XmlElement(name = "CHECK_RST")
    protected String checkrst;
    @XmlElement(name = "COUNTRY_CN_NAME")
    protected String countrycnname;
    @XmlElement(name = "COUNTRY_EN_NAME")
    protected String countryenname;
    @XmlElement(name = "CUR_CARGO_SIT")
    protected String curcargosit;
    @XmlElement(name = "DEC_DATE")
    protected String decdate;
    @XmlElement(name = "DEC_ORG")
    protected String decorg;
    @XmlElement(name = "DEC_USER")
    protected String decuser;
    @XmlElement(name = "EST_ARRIV_DATE")
    protected String estarrivdate;
    @XmlElement(name = "HAVE_BIER")
    protected String havebier;
    @XmlElement(name = "HAVE_CORPSE")
    protected String havecorpse;
    @XmlElement(name = "HAVING_CORPSE")
    protected String havingcorpse;
    @XmlElement(name = "HAVING_MDK_MDI_CPS")
    protected String havingmdkmdicps;
    @XmlElement(name = "HAVING_PATIENT")
    protected String havingpatient;
    @XmlElement(name = "HIS_CARGO_SIT")
    protected String hiscargosit;
    @XmlElement(name = "INSP_ORG_CODE")
    protected String insporgcode;
    @XmlElement(name = "INSP_ORG_NAME")
    protected String insporgname;
    @XmlElement(name = "LAST_FOUR_PORT")
    protected String lastfourport;
    @XmlElement(name = "LOAD_PORT")
    protected String loadport;
    @XmlElement(name = "NET_TON")
    protected String netton;
    @XmlElement(name = "QUAR_TYPE_APPR")
    protected String quartypeappr;
    @XmlElement(name = "QUAR_TYPE_DEC")
    protected String quartypedec;
    @XmlElement(name = "SHIPPER_PSN_NUM")
    protected String shipperpsnnum;
    @XmlElement(name = "SHIP_SANIT_CERT")
    protected String shipsanitcert;
    @XmlElement(name = "SHIP_TYPE")
    protected String shiptype;
    @XmlElement(name = "START_SHIP_SIT")
    protected String startshipsit;
    @XmlElement(name = "TOTAL_TON")
    protected String totalton;
    @XmlElement(name = "TRAF_CERT")
    protected String trafcert;
    @XmlElement(name = "VISITOR_PSN_NUM")
    protected String visitorpsnnum;
    @XmlElement(name = "VOYAGE_NO")
    protected String voyageno;
    @XmlElement(name = "VSL_CN_NAME")
    protected String vslcnname;
    @XmlElement(name = "VSL_DEC_ID")
    protected String vsldecid;
    @XmlElement(name = "VSL_EN_NAME")
    protected String vslenname;

    /**
     * Gets the value of the approvedate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAPPROVEDATE() {
        return approvedate;
    }

    /**
     * Sets the value of the approvedate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAPPROVEDATE(String value) {
        this.approvedate = value;
    }

    /**
     * Gets the value of the approveuser property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getAPPROVEUSER() {
        return approveuser;
    }

    /**
     * Sets the value of the approveuser property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setAPPROVEUSER(String value) {
        this.approveuser = value;
    }

    /**
     * Gets the value of the callsign property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCALLSIGN() {
        return callsign;
    }

    /**
     * Sets the value of the callsign property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCALLSIGN(String value) {
        this.callsign = value;
    }

    /**
     * Gets the value of the checkrst property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCHECKRST() {
        return checkrst;
    }

    /**
     * Sets the value of the checkrst property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCHECKRST(String value) {
        this.checkrst = value;
    }

    /**
     * Gets the value of the countrycnname property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCOUNTRYCNNAME() {
        return countrycnname;
    }

    /**
     * Sets the value of the countrycnname property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCOUNTRYCNNAME(String value) {
        this.countrycnname = value;
    }

    /**
     * Gets the value of the countryenname property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCOUNTRYENNAME() {
        return countryenname;
    }

    /**
     * Sets the value of the countryenname property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCOUNTRYENNAME(String value) {
        this.countryenname = value;
    }

    /**
     * Gets the value of the curcargosit property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getCURCARGOSIT() {
        return curcargosit;
    }

    /**
     * Sets the value of the curcargosit property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setCURCARGOSIT(String value) {
        this.curcargosit = value;
    }

    /**
     * Gets the value of the decdate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDECDATE() {
        return decdate;
    }

    /**
     * Sets the value of the decdate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDECDATE(String value) {
        this.decdate = value;
    }

    /**
     * Gets the value of the decorg property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDECORG() {
        return decorg;
    }

    /**
     * Sets the value of the decorg property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDECORG(String value) {
        this.decorg = value;
    }

    /**
     * Gets the value of the decuser property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getDECUSER() {
        return decuser;
    }

    /**
     * Sets the value of the decuser property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setDECUSER(String value) {
        this.decuser = value;
    }

    /**
     * Gets the value of the estarrivdate property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getESTARRIVDATE() {
        return estarrivdate;
    }

    /**
     * Sets the value of the estarrivdate property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setESTARRIVDATE(String value) {
        this.estarrivdate = value;
    }

    /**
     * Gets the value of the havebier property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHAVEBIER() {
        return havebier;
    }

    /**
     * Sets the value of the havebier property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHAVEBIER(String value) {
        this.havebier = value;
    }

    /**
     * Gets the value of the havecorpse property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHAVECORPSE() {
        return havecorpse;
    }

    /**
     * Sets the value of the havecorpse property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHAVECORPSE(String value) {
        this.havecorpse = value;
    }

    /**
     * Gets the value of the havingcorpse property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHAVINGCORPSE() {
        return havingcorpse;
    }

    /**
     * Sets the value of the havingcorpse property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHAVINGCORPSE(String value) {
        this.havingcorpse = value;
    }

    /**
     * Gets the value of the havingmdkmdicps property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHAVINGMDKMDICPS() {
        return havingmdkmdicps;
    }

    /**
     * Sets the value of the havingmdkmdicps property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHAVINGMDKMDICPS(String value) {
        this.havingmdkmdicps = value;
    }

    /**
     * Gets the value of the havingpatient property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHAVINGPATIENT() {
        return havingpatient;
    }

    /**
     * Sets the value of the havingpatient property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHAVINGPATIENT(String value) {
        this.havingpatient = value;
    }

    /**
     * Gets the value of the hiscargosit property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getHISCARGOSIT() {
        return hiscargosit;
    }

    /**
     * Sets the value of the hiscargosit property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setHISCARGOSIT(String value) {
        this.hiscargosit = value;
    }

    /**
     * Gets the value of the insporgcode property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINSPORGCODE() {
        return insporgcode;
    }

    /**
     * Sets the value of the insporgcode property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINSPORGCODE(String value) {
        this.insporgcode = value;
    }

    /**
     * Gets the value of the insporgname property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getINSPORGNAME() {
        return insporgname;
    }

    /**
     * Sets the value of the insporgname property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setINSPORGNAME(String value) {
        this.insporgname = value;
    }

    /**
     * Gets the value of the lastfourport property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLASTFOURPORT() {
        return lastfourport;
    }

    /**
     * Sets the value of the lastfourport property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLASTFOURPORT(String value) {
        this.lastfourport = value;
    }

    /**
     * Gets the value of the loadport property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getLOADPORT() {
        return loadport;
    }

    /**
     * Sets the value of the loadport property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setLOADPORT(String value) {
        this.loadport = value;
    }

    /**
     * Gets the value of the netton property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getNETTON() {
        return netton;
    }

    /**
     * Sets the value of the netton property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setNETTON(String value) {
        this.netton = value;
    }

    /**
     * Gets the value of the quartypeappr property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getQUARTYPEAPPR() {
        return quartypeappr;
    }

    /**
     * Sets the value of the quartypeappr property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setQUARTYPEAPPR(String value) {
        this.quartypeappr = value;
    }

    /**
     * Gets the value of the quartypedec property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getQUARTYPEDEC() {
        return quartypedec;
    }

    /**
     * Sets the value of the quartypedec property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setQUARTYPEDEC(String value) {
        this.quartypedec = value;
    }

    /**
     * Gets the value of the shipperpsnnum property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSHIPPERPSNNUM() {
        return shipperpsnnum;
    }

    /**
     * Sets the value of the shipperpsnnum property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSHIPPERPSNNUM(String value) {
        this.shipperpsnnum = value;
    }

    /**
     * Gets the value of the shipsanitcert property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSHIPSANITCERT() {
        return shipsanitcert;
    }

    /**
     * Sets the value of the shipsanitcert property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSHIPSANITCERT(String value) {
        this.shipsanitcert = value;
    }

    /**
     * Gets the value of the shiptype property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSHIPTYPE() {
        return shiptype;
    }

    /**
     * Sets the value of the shiptype property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSHIPTYPE(String value) {
        this.shiptype = value;
    }

    /**
     * Gets the value of the startshipsit property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getSTARTSHIPSIT() {
        return startshipsit;
    }

    /**
     * Sets the value of the startshipsit property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setSTARTSHIPSIT(String value) {
        this.startshipsit = value;
    }

    /**
     * Gets the value of the totalton property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTOTALTON() {
        return totalton;
    }

    /**
     * Sets the value of the totalton property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTOTALTON(String value) {
        this.totalton = value;
    }

    /**
     * Gets the value of the trafcert property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getTRAFCERT() {
        return trafcert;
    }

    /**
     * Sets the value of the trafcert property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setTRAFCERT(String value) {
        this.trafcert = value;
    }

    /**
     * Gets the value of the visitorpsnnum property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVISITORPSNNUM() {
        return visitorpsnnum;
    }

    /**
     * Sets the value of the visitorpsnnum property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVISITORPSNNUM(String value) {
        this.visitorpsnnum = value;
    }

    /**
     * Gets the value of the voyageno property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVOYAGENO() {
        return voyageno;
    }

    /**
     * Sets the value of the voyageno property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVOYAGENO(String value) {
        this.voyageno = value;
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
     * Gets the value of the vsldecid property.
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getVSLDECID() {
        return vsldecid;
    }

    /**
     * Sets the value of the vsldecid property.
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setVSLDECID(String value) {
        this.vsldecid = value;
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
