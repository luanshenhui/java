<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <title>CERTIFICATE OF ORIGIN</title>
        <meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE;" />
        <%@ include file="/common/resource.jsp"%>
        <style type="text/css">
            body div{
               width:1000px;
               margin: 5px auto;
            }
            .chatTitle{
                text-align: center;
                font-size: 30px;
                font-weight: 600;
            }
            .tableLine {
                border: 1px solid #000;
                padding-left: 10px;
                padding-right: 10px;
            }
            .fangxingLine {
                font-size:10;
                margin-left:5px;
                margin-right:5px;
                border: 2px solid #000;
                font-weight:900;
                padding-left: 3px;
                padding-right: 3px;
            }
            .tableLine2 {
                border: 1px solid #000;
                padding-left: 10px; 
            }
            .tableLine_noright {
                padding-left: 10px;
                border-top-width: 1px;
                border-bottom-width: 1px;
                border-left-width: 1px;
                border-top-style: solid;
                border-bottom-style: solid;
                border-left-style: solid;
                border-top-color: #000;
                border-bottom-color: #000;
                border-left-color: #000;
            }
            .tableLine_noleft {
                padding-left: 10px;
                border-top-width: 1px;
                border-right-width: 1px;
                border-bottom-width: 1px;
                border-top-style: solid;
                border-right-style: solid;
                border-bottom-style: solid;
                border-top-color: #000;
                border-right-color: #000;
                border-bottom-color: #000;
            }
            .tableLineno {
                border: 0px solid #000;
            }
            .tableLine_bottom {
                border-top-width: 0px;
                border-left-width: 0px;
                border-right-width: 0px;
                border-bottom-width: 1px;
                border-style: solid;
                border-color: #000;
            }
        </style>
        <script src="${ctx}/static/viewer/assets/js/jquery.min.js"></script>
    </head>
    <body>
        <div>
            <div class="chatTitle">CERTIFICATE OF ORIGIN</div>
            <table width="980px" border="0" align="center" style="font-size:14px;line-height:30px;" cellpadding="0" cellspacing="0" class="tableLine">
                <tr>
                    <td height="200px" class="tableLine" align="left" valign="top" colspan="3">
                        <table class="tableLineno">
                            <tr>
                                <td height="100px" class="tableLine_bottom" align="left" valign="top" width="490px"><b>1. Exporter</b> (Name, full address, country)</td>
                            </tr>
                            <tr>
                                <td height="100px" class="tableLineno" align="left" valign="top" width="490px"><b>2. Consignee</b> (Name, full address, country)</td>
                            </tr>
                        </table>
                    </td>
                    <td class="tableLine" align="center" valign="middle" colspan="4"><b>Certificate of Origin used in FTA between<br />CHINA<br />and<br />ICELAND</b></td>
                </tr>
                <tr>
                    <td height="170px" class="tableLine" align="left" valign="top" colspan="3"><b>3. Transport details</b> (as far as known)<br />Departure Date<br />Vessel / Flight/ Train/ Vehicle No.<br />Port of loading<br />Port of discharge</td>
                    <td class="tableLine" align="left" valign="top" colspan="4"><b>4. Remarks</b></td>
                </tr>
                <tr>
                    <td height="300px" class="tableLine" align="left" valign="top" width="122px"><b>5. Item number (Max 20)</b></td>
                    <td class="tableLine" align="left" valign="top" width="122px"><b>6. Marks and numbers</b></td>
                    <td class="tableLine" align="left" valign="top" width="246px"><b>7. Number and kind of packages; Description of goods</b></td>
                    <td class="tableLine" align="left" valign="top" width="122px"><b>8. HS code (Six digit code)</b></td>
                    <td class="tableLine" align="left" valign="top" width="123px"><b>9. Origin criterion</b></td>
                    <td class="tableLine" align="left" valign="top" width="122px"><b>10. Gross mass (kg) or other measure (liters, m3, etc.)</b></td>
                    <td class="tableLine" align="left" valign="top" width="123px"><b>11. Invoices (Number and date)</b></td>
                </tr>
                <tr>
                    <td height="400px" class="tableLine" align="left" valign="top" colspan="3"><b>12. ENDORSEMENT BY THE AUTHORIZED BODY</b><br /><br />It is hereby certified, on the basis of control carried out, that the declaration of the exporter is correct<br /><br /><br /><br /><br /><br /><br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />Place and date, signature and stamp of authorized body</td>
                    <td class="tableLine" align="left" valign="top" colspan="4"><b>13. DECLARATION BY THE EXPORTER</b><br /><br />The undersigned hereby declares that the details and statement above are correct, that all the goods were produced in<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;......................................... (country)<br />and that they comply with the  origin requirements specified in the FTA for the goods exported to<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;......................................... (Importing country)<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />Place and date, signature of authorized signatory</td>
                </tr>
                <tr>
                    <td height="400px" class="tableLine" align="left" valign="top" colspan="3">
                        <table class="tableLineno">
                            <tr>
                                <td height="150px" class="tableLine_bottom" align="left" valign="top" width="490px"><b>14. REQUEST FOR VERIFICATION, to:</b></td>
                            </tr>
                            <tr>
                                <td height="250px" class="tableLineno" align="left" valign="top" width="490px">Verification of the authenticity and accuracy of this certificate is requested.<br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Place and date)<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Signature)</td>
                            </tr>
                        </table>
                    </td>
                    <td class="tableLine" align="center" valign="middle" colspan="4">
                        <table class="tableLineno">
                            <tr>
                                <td height="40px" class="tableLine_bottom" align="left" valign="top" width="490px"><b>15. RESULT OF VERIFICATION</b></td>
                            </tr>
                            <tr>
                                <td height="360px" class="tableLineno" align="left" valign="top" width="490px">Verification carried out shows that this certificate<br />&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;&nbsp;was issued by the authorized body indicated and that the information contained therein is accurate.<br />&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;&nbsp;does not meet the requirements as to authenticity and accuracy (see remarks appended)<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Place and date)<br /><br />&nbsp;&nbsp;&nbsp;&nbsp;.......................................................................................................................<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Signature)</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
            <p></p>
        </div>
    </body>
</html>