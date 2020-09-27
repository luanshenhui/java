
package com.service.cn;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>vslUpdateDecIo complex type的 Java 类。
 * 
 * <p>以下模式片段指定包含在此类中的预期内容。
 * 
 * <pre>
 * &lt;complexType name="vslUpdateDecIo">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="APPROVE_DATE" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="APPROVE_USER" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *         &lt;element name="ARRV_RST" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
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
    "arrvrst",
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
    @XmlElement(name = "ARRV_RST")
    protected String arrvrst;
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
     * 获取approvedate属性的值。
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
     * 设置approvedate属性的值。
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
     * 获取approveuser属性的值。
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
     * 设置approveuser属性的值。
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
     * 获取arrvrst属性的值。
     * 
     * @return
     *     possible object is
     *     {@link String }
     *     
     */
    public String getARRVRST() {
        return arrvrst;
    }

    /**
     * 设置arrvrst属性的值。
     * 
     * @param value
     *     allowed object is
     *     {@link String }
     *     
     */
    public void setARRVRST(String value) {
        this.arrvrst = value;
    }

    /**
     * 获取callsign属性的值。
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
     * 设置callsign属性的值。
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
     * 获取checkrst属性的值。
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
     * 设置checkrst属性的值。
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
     * 获取countrycnname属性的值。
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
     * 设置countrycnname属性的值。
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
     * 获取countryenname属性的值。
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
     * 设置countryenname属性的值。
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
     * 获取curcargosit属性的值。
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
     * 设置curcargosit属性的值。
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
     * 获取decdate属性的值。
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
     * 设置decdate属性的值。
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
     * 获取decorg属性的值。
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
     * 设置decorg属性的值。
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
     * 获取decuser属性的值。
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
     * 设置decuser属性的值。
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
     * 获取estarrivdate属性的值。
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
     * 设置estarrivdate属性的值。
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
     * 获取havebier属性的值。
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
     * 设置havebier属性的值。
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
     * 获取havecorpse属性的值。
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
     * 设置havecorpse属性的值。
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
     * 获取havingcorpse属性的值。
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
     * 设置havingcorpse属性的值。
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
     * 获取havingmdkmdicps属性的值。
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
     * 设置havingmdkmdicps属性的值。
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
     * 获取havingpatient属性的值。
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
     * 设置havingpatient属性的值。
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
     * 获取hiscargosit属性的值。
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
     * 设置hiscargosit属性的值。
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
     * 获取insporgcode属性的值。
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
     * 设置insporgcode属性的值。
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
     * 获取insporgname属性的值。
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
     * 设置insporgname属性的值。
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
     * 获取lastfourport属性的值。
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
     * 设置lastfourport属性的值。
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
     * 获取loadport属性的值。
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
     * 设置loadport属性的值。
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
     * 获取netton属性的值。
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
     * 设置netton属性的值。
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
     * 获取quartypeappr属性的值。
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
     * 设置quartypeappr属性的值。
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
     * 获取quartypedec属性的值。
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
     * 设置quartypedec属性的值。
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
     * 获取shipperpsnnum属性的值。
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
     * 设置shipperpsnnum属性的值。
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
     * 获取shipsanitcert属性的值。
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
     * 设置shipsanitcert属性的值。
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
     * 获取shiptype属性的值。
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
     * 设置shiptype属性的值。
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
     * 获取startshipsit属性的值。
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
     * 设置startshipsit属性的值。
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
     * 获取totalton属性的值。
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
     * 设置totalton属性的值。
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
     * 获取trafcert属性的值。
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
     * 设置trafcert属性的值。
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
     * 获取visitorpsnnum属性的值。
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
     * 设置visitorpsnnum属性的值。
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
     * 获取voyageno属性的值。
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
     * 设置voyageno属性的值。
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
     * 获取vslcnname属性的值。
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
     * 设置vslcnname属性的值。
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
     * 获取vsldecid属性的值。
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
     * 设置vsldecid属性的值。
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
     * 获取vslenname属性的值。
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
     * 设置vslenname属性的值。
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
