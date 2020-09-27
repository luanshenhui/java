<%
'-----------------------------------------------------------------------------
'        団体ガイド Include File (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
%>
<SCRIPT TYPE="text/javascript">
<!--
// エレメント参照用変数
var orgGuide_OrgCd1;            // 団体コード1
var orgGuide_OrgCd2;            // 団体コード2
var orgGuide_OrgName;           // 団体名称
var orgGuide_OrgSName;          // 団体略称
var orgGuide_OrgKName;          // 団体カナ名称
var orgGuide_IsrSign;           // 健保記号
var orgGuide_ZipCd;             // 郵便番号
var orgGuide_PrefCd;            // 都道府県コード
var orgGuide_CityName;          // 市区町村名
var orgGuide_Address1;          // 住所１
var orgGuide_Address2;          // 住所２
var orgGuide_DirectTel;         // 電話番号１
var orgGuide_Tel;               // 電話番号２
var orgGuide_Extension;         // 内線１
var orgGuide_Fax;               // ＦＡＸ
var orgGuide_EMail;             // e-Mail
var orgGuide_Url;               // URL
var orgGuide_CalledFunction;    // 団体選択時に呼び出される関数オブジェクト
var orgGuide_ConnectCodeName;   // true指定時、コードと名前を結合する

var orgGuide_BillCslDiv;        // 請求書本人家族区分出力

// ## 2004.01.29 Add By T.Takagi@FSIT 項目追加
var orgGuide_ReptCslDiv;        // 成績書本人家族区分出力
// ## 2004.01.29 Add End

// ### 2016.09.19 張 送付案内コメント項目追加 STR ###
var orgGuide_SendComment;       // 送付案内コメント出力
// ### 2016.09.19 張 送付案内コメント項目追加 END ###

var winGuideOrg;                // ウィンドウハンドル

// 団体検索ガイド画面を表示
// ### 2016.09.19 張 送付案内コメント項目追加 STR ###
//function orgGuide_showGuideOrg( orgCd1, orgCd2, orgName, orgSName, orgKName, calledFunc, connectCodeName, isrSign, orgDiv, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl ) {
function orgGuide_showGuideOrg( orgCd1, orgCd2, orgName, orgSName, orgKName, calledFunc, connectCodeName, isrSign, orgDiv, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl, sendComment) {
// ### 2016.09.19 張 送付案内コメント項目追加 END ###

    var url = '/webHains/contents/guide/gdeOrganization.asp';    // 団体検索ガイド画面のURL

    // ガイド画面との連絡域を使用して処理制御を行う
    orgGuide_OrgCd1    = orgCd1;
    orgGuide_OrgCd2    = orgCd2;
    orgGuide_OrgName   = document.getElementById( orgName  );
    orgGuide_OrgSName  = document.getElementById( orgSName );
    orgGuide_OrgKName  = document.getElementById( orgKName );
    orgGuide_IsrSign   = isrSign;
    orgGuide_ZipCd     = zipCd;
    orgGuide_PrefCd    = prefCd;
    orgGuide_CityName  = cityName;
    orgGuide_Address1  = address1;
    orgGuide_Address2  = address2;
    orgGuide_DirectTel = directTel;
    orgGuide_Tel       = tel;
    orgGuide_Extension = extension;
    orgGuide_Fax       = fax;
    orgGuide_EMail     = eMail;
    orgGuide_Url       = orgUrl;
    orgGuide_CalledFunction  = calledFunc;
    orgGuide_ConnectCodeName = connectCodeName;

// ### 2016.09.19 張 送付案内コメント項目追加 STR ###
    orgGuide_SendComment = sendComment;
// ### 2016.09.19 張 送付案内コメント項目追加 END ###

    // 団体種別指定時は追加
    if ( orgDiv != null ) {
        url = url + '?orgDiv=' + orgDiv;
    }

    // ガイド画面を表示
    orgGuide_openWindow( url );

}

// ガイド画面を表示
function orgGuide_openWindow( url ) {

    var opened = false;    // 画面が開かれているか

    // すでにガイドが開かれているかチェック
    if ( winGuideOrg ) {
        if ( !winGuideOrg.closed ) {
            opened = true;
        }
    }

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winGuideOrg.focus();
        winGuideOrg.location.replace( url );
    } else {
        winGuideOrg = window.open( url, '', 'width=700,height=600,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// 団体情報編集用関数
// ## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
// function orgGuide_setOrgInfo( orgCd1, orgCd2, orgName, orgSName, orgKName, isrSign, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl, billCslDiv ) {
// function orgGuide_setOrgInfo( orgCd1, orgCd2, orgName, orgSName, orgKName, isrSign, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl, billCslDiv, reptCslDiv) {
// ## 団体名称ハイライト表示区分(highLight)追加 2013.12.24 張
// ### 2016.09.19 張 送付案内コメント項目追加 STR ###
//function orgGuide_setOrgInfo( orgCd1, orgCd2, orgName, orgSName, orgKName, isrSign, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl, billCslDiv, reptCslDiv, nameHighLight ) {
function orgGuide_setOrgInfo( orgCd1, orgCd2, orgName, orgSName, orgKName, isrSign, zipCd, prefCd, cityName, address1, address2, directTel, tel, extension, fax, eMail, orgUrl, billCslDiv, reptCslDiv, nameHighLight, sendComment ) {
// ### 2016.09.19 張 送付案内コメント項目追加 END ###
// ## 2004.01.29 Mod End

    // 団体コード１の編集
    if ( orgGuide_OrgCd1 ) {
        orgGuide_OrgCd1.value = orgCd1;
    }

    // 団体コード２の編集
    if ( orgGuide_OrgCd2 ) {
        orgGuide_OrgCd2.value = orgCd2;
    }

    // 団体名の編集
    //if ( orgGuide_OrgName ) {
    //    if ( orgGuide_ConnectCodeName ) {
    //        orgGuide_OrgName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgName;
    //    } else {
    //        orgGuide_OrgName.innerHTML = orgName;
    //    }
    //}

    if ( orgGuide_OrgName ) {
        if (nameHighLight=="1"){
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgCd1 + '-' + orgCd2 + '：' + orgName+'<\/b><\/font>';
            } else {
                orgGuide_OrgName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgName+'<\/b><\/font>';
            }
        } else {
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgName;
            } else {
                orgGuide_OrgName.innerHTML = orgName;
            }
        }
    }

    // 団体略称の編集
    //if ( orgGuide_OrgSName ) {
    //    if ( orgGuide_ConnectCodeName ) {
    //        orgGuide_OrgSName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgSName;
    //    } else {
    //        orgGuide_OrgSName.innerHTML = orgSName;
    //    }
    //}

    if ( orgGuide_OrgSName ) {
        if (nameHighLight=="1"){
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgSName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgCd1 + '-' + orgCd2 + '：' + orgSName+'<\/b><\/font>';
            } else {
                orgGuide_OrgSName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgSName+'<\/b><\/font>';
            }
        } else {
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgSName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgSName;
            } else {
                orgGuide_OrgSName.innerHTML = orgSName;
            }
        }
    }

    // 団体カナ名称の編集
    //if ( orgGuide_OrgKName ) {
    //    if ( orgGuide_ConnectCodeName ) {
    //        orgGuide_OrgKName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgKName;
    //    } else {
    //        orgGuide_OrgKName.innerHTML = orgKName;
    //    }
    //}
    if ( orgGuide_OrgKName ) {
        if (nameHighLight=="1"){
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgKName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgCd1 + '-' + orgCd2 + '：' + orgKName+'<\/b><\/font>';
            } else {
                orgGuide_OrgKName.innerHTML = '<font style=\' font-weight:bold; background-color:#00FFFF;\'><b>'+orgKName+'<\/b><\/font>';
            }
        } else {
            if ( orgGuide_ConnectCodeName ) {
                orgGuide_OrgKName.innerHTML = orgCd1 + '-' + orgCd2 + '：' + orgKName;
            } else {
                orgGuide_OrgKName.innerHTML = orgKName;
            }
        }
    }

    // 健保記号の編集
    if ( orgGuide_IsrSign ) {
        orgGuide_IsrSign.value = isrSign;
    }

    // 住所情報の編集
    if ( orgGuide_ZipCd     ) orgGuide_ZipCd.value     = zipCd;
    if ( orgGuide_PrefCd    ) orgGuide_PrefCd.value    = prefCd;
    if ( orgGuide_CityName  ) orgGuide_CityName.value  = cityName;
    if ( orgGuide_Address1  ) orgGuide_Address1.value  = address1;
    if ( orgGuide_Address2  ) orgGuide_Address2.value  = address2;
    if ( orgGuide_DirectTel ) orgGuide_DirectTel.value = directTel;
    if ( orgGuide_Tel       ) orgGuide_Tel.value       = tel;
    if ( orgGuide_Extension ) orgGuide_Extension.value = extension;
    if ( orgGuide_Fax       ) orgGuide_Fax.value       = fax;
    if ( orgGuide_EMail     ) orgGuide_EMail.value     = eMail;
    if ( orgGuide_Url       ) orgGuide_Url.value       = orgUrl;

    // 請求書本人家族区分出力の編集
    orgGuide_BillCslDiv = billCslDiv;

// ## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    // 成績書本人家族区分出力の編集
    orgGuide_ReptCslDiv = reptCslDiv;
// ## 2004.01.29 Add End

// ### 2016.09.19 張 送付案内コメント項目追加 STR ###
    if ( orgGuide_SendComment ) orgGuide_SendComment.value  = sendComment;
// ### 2016.09.19 張 送付案内コメント項目追加 END ###


}

// 団体情報のクリア
function orgGuide_clearOrgInfo( orgCd1, orgCd2, orgName ) {

    // 団体コード1のクリア
    if ( orgCd1 ) {
        orgCd1.value = '';
    }

    // 団体コード2のクリア
    if ( orgCd2 ) {
        orgCd2.value = '';
    }

    // 団体名称エレメントのクリア
    if ( document.getElementById(orgName) ) {
        document.getElementById(orgName).innerHTML = '';
    }

}

// ガイドを閉じる
function orgGuide_closeGuideOrg() {

    if ( winGuideOrg ) {
        if ( !winGuideOrg.closed ) {
            winGuideOrg.close();
        }
    }

    winGuideOrg = null;
}
//-->
</SCRIPT>
