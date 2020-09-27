
package com.service.cn;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>vslUpdateDecIo complex type�� Java �ࡣ
 * 
 * <p>����ģʽƬ��ָ�������ڴ����е�Ԥ�����ݡ�
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
     * ��ȡapprovedate���Ե�ֵ��
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
     * ����approvedate���Ե�ֵ��
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
     * ��ȡapproveuser���Ե�ֵ��
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
     * ����approveuser���Ե�ֵ��
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
     * ��ȡarrvrst���Ե�ֵ��
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
     * ����arrvrst���Ե�ֵ��
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
     * ��ȡcallsign���Ե�ֵ��
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
     * ����callsign���Ե�ֵ��
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
     * ��ȡcheckrst���Ե�ֵ��
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
     * ����checkrst���Ե�ֵ��
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
     * ��ȡcountrycnname���Ե�ֵ��
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
     * ����countrycnname���Ե�ֵ��
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
     * ��ȡcountryenname���Ե�ֵ��
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
     * ����countryenname���Ե�ֵ��
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
     * ��ȡcurcargosit���Ե�ֵ��
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
     * ����curcargosit���Ե�ֵ��
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
     * ��ȡdecdate���Ե�ֵ��
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
     * ����decdate���Ե�ֵ��
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
     * ��ȡdecorg���Ե�ֵ��
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
     * ����decorg���Ե�ֵ��
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
     * ��ȡdecuser���Ե�ֵ��
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
     * ����decuser���Ե�ֵ��
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
     * ��ȡestarrivdate���Ե�ֵ��
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
     * ����estarrivdate���Ե�ֵ��
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
     * ��ȡhavebier���Ե�ֵ��
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
     * ����havebier���Ե�ֵ��
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
     * ��ȡhavecorpse���Ե�ֵ��
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
     * ����havecorpse���Ե�ֵ��
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
     * ��ȡhavingcorpse���Ե�ֵ��
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
     * ����havingcorpse���Ե�ֵ��
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
     * ��ȡhavingmdkmdicps���Ե�ֵ��
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
     * ����havingmdkmdicps���Ե�ֵ��
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
     * ��ȡhavingpatient���Ե�ֵ��
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
     * ����havingpatient���Ե�ֵ��
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
     * ��ȡhiscargosit���Ե�ֵ��
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
     * ����hiscargosit���Ե�ֵ��
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
     * ��ȡinsporgcode���Ե�ֵ��
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
     * ����insporgcode���Ե�ֵ��
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
     * ��ȡinsporgname���Ե�ֵ��
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
     * ����insporgname���Ե�ֵ��
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
     * ��ȡlastfourport���Ե�ֵ��
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
     * ����lastfourport���Ե�ֵ��
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
     * ��ȡloadport���Ե�ֵ��
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
     * ����loadport���Ե�ֵ��
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
     * ��ȡnetton���Ե�ֵ��
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
     * ����netton���Ե�ֵ��
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
     * ��ȡquartypeappr���Ե�ֵ��
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
     * ����quartypeappr���Ե�ֵ��
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
     * ��ȡquartypedec���Ե�ֵ��
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
     * ����quartypedec���Ե�ֵ��
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
     * ��ȡshipperpsnnum���Ե�ֵ��
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
     * ����shipperpsnnum���Ե�ֵ��
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
     * ��ȡshipsanitcert���Ե�ֵ��
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
     * ����shipsanitcert���Ե�ֵ��
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
     * ��ȡshiptype���Ե�ֵ��
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
     * ����shiptype���Ե�ֵ��
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
     * ��ȡstartshipsit���Ե�ֵ��
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
     * ����startshipsit���Ե�ֵ��
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
     * ��ȡtotalton���Ե�ֵ��
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
     * ����totalton���Ե�ֵ��
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
     * ��ȡtrafcert���Ե�ֵ��
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
     * ����trafcert���Ե�ֵ��
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
     * ��ȡvisitorpsnnum���Ե�ֵ��
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
     * ����visitorpsnnum���Ե�ֵ��
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
     * ��ȡvoyageno���Ե�ֵ��
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
     * ����voyageno���Ե�ֵ��
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
     * ��ȡvslcnname���Ե�ֵ��
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
     * ����vslcnname���Ե�ֵ��
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
     * ��ȡvsldecid���Ե�ֵ��
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
     * ����vsldecid���Ե�ֵ��
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
     * ��ȡvslenname���Ե�ֵ��
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
     * ����vslenname���Ե�ֵ��
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
