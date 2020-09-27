import React from 'react';
import PropTypes from 'prop-types';
import qs from 'qs';
import moment from 'moment';

import SectionBar from '../../components/SectionBar';
import Button from '../../components/control/Button';

import EditCsGrpInfo from './EditCsGrpInfo';
import { getMenResultGrpInfo } from './InterviewResult';
import * as constants from '../../constants/common';

class MenResultHeader extends React.Component {
  constructor(props) {
    super(props);

    // ＣＵ経年変化
    this.handleCUMainGraphClick = this.handleCUMainGraphClick.bind(this);
    // 表示切替
    this.handleChgHideFlgClick = this.handleChgHideFlgClick.bind(this);
    // 所見修正画面
    this.handleMenResultEntryClick = this.handleMenResultEntryClick.bind(this);
    // 保存
    this.handleSaveMenResultClick = this.handleSaveMenResultClick.bind(this);
    // 参照専用画面
    this.handleMenResultClick = this.handleMenResultClick.bind(this);
    // 波形
    this.handleEcgWaveClick = this.handleEcgWaveClick.bind(this);
    // 動脈硬化画像
    this.handleCaviAbiImageClick = this.handleCaviAbiImageClick.bind(this);
    // 動脈硬化レポート
    this.handleRayPaxReportClick = this.handleRayPaxReportClick.bind(this);
    // RayPax連携その１画像
    this.handleRayPaxImage1Click = this.handleRayPaxImage1Click.bind(this);
    // RayPax連携その１レポート
    this.handleRayPaxReport1Click = this.handleRayPaxReport1Click.bind(this);
    // RayPax連携その２画像
    this.handleRayPaxImage2Click = this.handleRayPaxImage2Click.bind(this);
    // RayPax連携その２レポート
    this.handleRayPaxReport2Click = this.handleRayPaxReport2Click.bind(this);
    // RayPax連携その３画像
    this.handleRayPaxImage3Click = this.handleRayPaxImage3Click.bind(this);
    // RayPax連携その３レポート
    this.handleRayPaxReport3Click = this.handleRayPaxReport3Click.bind(this);
  }

  // 更新モード
  getMenResultButtons = (lngEntryMode) => {
    const { memResult, handleSubmit } = this.props;
    const strHtml = [];
    const strLink = [];

    // グループ情報取得
    const {
      lngMenResultTypeNo,
    } = getMenResultGrpInfo(memResult.grpno);
    if (lngEntryMode === constants.INTERVIEWRESULT_REFER) {
      if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE1 || lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE2) {
        strLink.push(<span><a role="presentation" onClick={handleSubmit(this.handleCUMainGraphClick)} style={{ color: '#006699', cursor: 'pointer' }}>ＣＵ経年変化</a>&nbsp;&nbsp;</span>);
      }

      if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE2 || lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE3) {
        strLink.push(<span><a role="presentation" onClick={handleSubmit(this.handleChgHideFlgClick)} style={{ color: '#006699', cursor: 'pointer' }}>表示切替</a>&nbsp;&nbsp;</span>);
        strLink.push(<span><a role="presentation" onClick={handleSubmit(this.handleMenResultEntryClick)} style={{ color: '#006699', cursor: 'pointer' }}>所見修正画面</a>&nbsp;&nbsp;</span>);
      }
    } else if (lngEntryMode === constants.INTERVIEWRESULT_ENTRY) {
      strLink.push(<span><Button className="btn" onClick={handleSubmit(this.handleSaveMenResultClick)} value="保存" />&nbsp;&nbsp;</span>);
      strLink.push(<span><a role="presentation" onClick={handleSubmit(this.handleMenResultClick)} style={{ color: '#006699', cursor: 'pointer' }}>参照専用画面</a>&nbsp;&nbsp;</span>);
    }

    strHtml.push((
      <span>
        {strLink}
      </span>
    ));
    return strHtml;
  };

  getMenResult1 = () => {
    // const { memResult, peridData, consultHistoryData, orderNoData1, orderNoData2, orderNoData3 } = this.props;
    const { memResult, orderNoData1, orderNoData2, orderNoData3 } = this.props;

    // グループ情報取得
    const {
      lngMenResultTypeNo,
      strMenResultTitle,
      strRayPaxOrdDiv,
      strRayPaxOrdDiv2,
      strRayPaxOrdDiv3,
    } = getMenResultGrpInfo(memResult.grpno);

    const strHtml = [];
    const strLink = [];
    if (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE2 ||
      lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE3 ||
      (lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE1 && strMenResultTitle === '内臓脂肪面積')) {
      // 健診完了後変更された受診者個人ID追跡
      // let vntResultPerId = '';
      // if (peridData && peridData.peridbefore && peridData.peridbefore !== '') {
      //  vntResultPerId = peridData.peridafter;
      // } else {
      //  vntResultPerId = consultHistoryData[0].perid;
      // }

      // 心電図のとき
      if (strMenResultTitle === '心電図') {
        // 心電図連携
        if (strRayPaxOrdDiv && strRayPaxOrdDiv !== '') {
          // オーダ番号を取得する
          if (orderNoData1 && orderNoData1.orderno && orderNoData1.orderno !== '') {
            // let strUrlEcgWave = '';
            // strUrlEcgWave = strUrlEcgWave & "http://" & convertAddress("Ecg") & "/VitaWeb/Start.aspx"
            // strUrlEcgWave = strUrlEcgWave & "?id=" & Right("0000000000" & vntPerId(0), 10)
            // strUrlEcgWave = strUrlEcgWave & "&sdate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd") & "000000"
            // strUrlEcgWave = strUrlEcgWave & "&edate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd") & "235959"
            // strUrlEcgWave = strUrlEcgWave & "&SORT3=JHA999"
            strLink.push(<a>波形</a>);
          }
        }
        // 動脈硬化のとき
      } else if (strMenResultTitle === '動脈硬化') {
        // 動脈硬化連携
        if (strRayPaxOrdDiv && strRayPaxOrdDiv !== '') {
          // オーダ番号を取得する
          if (orderNoData1 && orderNoData1.orderno && orderNoData1.orderno !== '') {
            // let strUrlCaviAbiImage = '';
            // 動脈硬化のURL
            // strUrlCaviAbiImage = strUrlCaviAbiImage & "http://" & convertAddress("CaviABi") & "/scripts8800/ecg_idx.exe"
            // strUrlCaviAbiImage = strUrlCaviAbiImage & "?PID=" & vntPerId(0)
            // strUrlCaviAbiImage = strUrlCaviAbiImage & "&ORDER=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yyyymmdd")

            // 動脈硬化レポートのURL
            // let strUrlRayPaxReport = '';
            // strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
            // strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
            // strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&userid=" & Session("USERID")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&perid=" & vntPerId(0)
            // strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
            strLink.push(<a>画像</a>);
            strLink.push(<a>レポート</a>);
          }
        }
      } else {
        // RayPax連携その１
        // RayPax画像レポート表示あり
        if (strRayPaxOrdDiv && strRayPaxOrdDiv !== '') {
          // オーダ番号を取得する
          if (orderNoData1 && orderNoData1.orderno && orderNoData1.orderno !== '') {
            // RayPax画像のURL
            // let strUrlRayPaxImage = '';
            // If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
            // ELSE
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
            // End If
            // let strUrlRayPaxReport = '';
            // strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
            // strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
            // strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&userid=" & Session("USERID")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&perid=" & vntPerId(0)
            // strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
            strLink.push(<a>画像</a>);
            strLink.push(<a>レポート</a>);
          }
        }

        // RayPax連携その２
        // RayPax画像レポート表示あり
        if (strRayPaxOrdDiv2 && strRayPaxOrdDiv2 !== '') {
          // オーダ番号を取得する
          if (orderNoData2 && orderNoData2.orderno && orderNoData2.orderno !== '') {
            // RayPax画像のURL
            // let strUrlRayPaxImage = '';
            // If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
            // ELSE
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
            // End If
            // let strUrlRayPaxReport = '';
            // strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
            // strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
            // strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&userid=" & Session("USERID")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&perid=" & vntPerId(0)
            // strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
            strLink.push(<a>画像</a>);
            strLink.push(<a>レポート</a>);
          }
        }

        // RayPax連携その３
        // RayPax画像レポート表示あり
        if (strRayPaxOrdDiv3 && strRayPaxOrdDiv3 !== '') {
          // オーダ番号を取得する
          if (orderNoData3 && orderNoData3.orderno !== '') {
            // RayPax画像のURL
            // let strUrlRayPaxImage = '';
            // If objCommon.FormatString(vntCslDate(0), "yy") < "11" Then
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntSendDate, "yy")'
            // Else
            // strUrlRayPaxImage = ""
            // strUrlRayPaxImage = strUrlRayPaxImage & "http://" & convertAddress("XrayImage") & "/ami/html/webviewer.html"
            // strUrlRayPaxImage = strUrlRayPaxImage & "?view&un=cweb&pw=viewer"
            // strUrlRayPaxImage = strUrlRayPaxImage & "&order_nbr=" & vntOrderNo & objCommon.FormatString(vntCslDate(0), "yy")
            // End If
            // let strUrlRayPaxReport = '';
            // strUrlRayPaxReport = strUrlRayPaxReport & "/webHains/contents/sso/HainsEgmainConnect.asp"
            // strUrlRayPaxReport = strUrlRayPaxReport & "?funccode=FC002"
            // strUrlRayPaxReport = strUrlRayPaxReport & "&csldate=" & objCommon.FormatString(vntCslDate(0), "yyyymmdd")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&userid=" & Session("USERID")
            // strUrlRayPaxReport = strUrlRayPaxReport & "&perid=" & vntPerId(0)
            // strUrlRayPaxReport = strUrlRayPaxReport & "&orderno=" & vntOrderNo
            strLink.push(<a>画像</a>);
            strLink.push(<a>レポート</a>);
          }
        }
      }
    }

    strHtml.push((
      <span>
        {strLink}
      </span>
    ));
    return strHtml;
  };

  // 表示
  handleHyouJiClick = (values) => {
    const { history, match, memResult, ismodal } = this.props;
    // 判定入力画面のURL編集
    const strUrlJud = `/contents/judgement/interview/top/${memResult.rsvno}/totaljudview/${memResult.grpno}/${memResult.winmode}`;
    const strUrlMem = `/contents/judgement/interview/top/${memResult.rsvno}/menresult/${memResult.grpno}/${memResult.winmode}`;
    const strUrl = ismodal === 1 ? strUrlMem : strUrlJud;
    history.push({
      pathname: match ? match.url : strUrl,
      search: qs.stringify({ ...memResult, ...values }),
    });
  }

  // ＣＵ経年変化
  handleCUMainGraphClick = (values) => {
    const { historyRslData1 } = this.props;
    const SelectItems = [];
    const { CUSelectItems } = values;
    if (CUSelectItems && CUSelectItems.length > 0) {
      for (let i = 0; i < CUSelectItems.length; i += 1) {
        if (CUSelectItems[i] && CUSelectItems[i] === '1') {
          SelectItems.push({ SelectItemcd: historyRslData1[i].itemcd, SelectSuffix: historyRslData1[i].suffix });
        }
      }
    }

    if (SelectItems.length === 0) {
      // alert("表示検査項目を最低１つは選択してください");
      // return;
    }

    if (SelectItems.length > 20) {
      // alert("表示検査項目の最大選択数は２０件です");
      // return;
    }

    // url = '/WebHains/contents/interview/CUMainGraphMain.asp';
    // url = url + '?winmode=' + '<%= strWinMode %>';
    // url = url + '&grpno=' + '<%= strGrpNo %>';
    // url = url + '&rsvno=' + '<%= lngRsvNo %>';
    // url = url + '&cscd=' + '<%= strCsCd %>';
    // url = url + '&itemcd=' + SelectItemcd;
    // url = url + '&suffix=' + SelectSuffix;

    // parent.location.href(url);
  }

  // 表示切替
  handleChgHideFlgClick = (values) => {
    const { setValue } = this.props;
    if (!values.hideflg || values.hideflg === '' || values.hideflg === '1') {
      setValue('hideflg', '0');
    } else {
      setValue('hideflg', '1');
    }
  }
  // 所見修正画面
  handleMenResultEntryClick = () => {
    const { setValue } = this.props;
    setValue('entrymode', constants.INTERVIEWRESULT_ENTRY);
    setValue('hideflg', '0');
  }
  // 保存
  handleSaveMenResultClick = (values) => {
    const { historyRslData3, memResult, onUpdate } = this.props;
    const { updinfo } = values;
    const data = [];
    if (updinfo && updinfo.length > 0) {
      for (let i = 0; i < updinfo.length; i += 1) {
        if (updinfo[i] && updinfo[i].updflg === '1') {
          data.push({
            ItemCd: historyRslData3[i].itemcd,
            Suffix: historyRslData3[i].suffix,
            Result: updinfo[i].stccd,
            RslCmtCd1: historyRslData3[i].rslcmtcd1,
            RslCmtCd2: historyRslData3[i].rslcmtcd2,
          });
        }
      }
      onUpdate({ rsvNo: memResult.rsvno }, data);
    }
  }
  // 参照専用画面
  handleMenResultClick = () => {
    const { setValue } = this.props;
    setValue('entrymode', constants.INTERVIEWRESULT_REFER);
    setValue('hideflg', '1');
  }
  // 波形
  handleEcgWaveClick = () => {
  }
  // 動脈硬化画像
  handleCaviAbiImageClick = () => {
  }
  // 動脈硬化レポート
  handleRayPaxReportClick = () => {
  }
  // RayPax連携その１画像
  handleRayPaxImage1Click = () => {
  }
  // RayPax連携その１レポート
  handleRayPaxReport1Click = () => {
  }
  // RayPax連携その２画像
  handleRayPaxImage2Click = () => {
  }
  // RayPax連携その２レポート
  handleRayPaxReport2Click = () => {
  }
  // RayPax連携その３画像
  handleRayPaxImage3Click = () => {
  }
  // RayPax連携その３レポート
  handleRayPaxReport3Click = () => {
  }

  render() {
    const { consultHistoryData, memResult, entrymode, handleSubmit } = this.props;

    if (!consultHistoryData || consultHistoryData.length === 0) {
      return null;
    }

    // 引数値の取得
    const strGrpNo = memResult.grpno;

    let lngEntryMode = entrymode;
    if (!lngEntryMode || lngEntryMode === '') {
      lngEntryMode = constants.INTERVIEWRESULT_REFER;
    }

    // グループ情報取得
    const {
      strMenResultTitle,
    } = getMenResultGrpInfo(strGrpNo);

    return (
      <div>
        <SectionBar title={`${strMenResultTitle} 検査結果表示`} />
        <EditCsGrpInfo rsvno={parseInt(memResult.rsvno, 10)} handleSubmit={handleSubmit} dispCalledFunction={this.handleHyouJiClick} data={consultHistoryData} />
        <div style={{ float: 'left' }}>
          <span>前回受診日</span>
          <span><font color="#ff6600"><b>{consultHistoryData && consultHistoryData.length > 1 && moment(consultHistoryData[1].csldate).format('YYYY/MM/DD')}</b></font></span>
          <span><font color="#ff6600"><b>{consultHistoryData && consultHistoryData.length > 1 && consultHistoryData[1].cssname}</b></font></span>
          <span>前々回受診日</span>
          <span><font color="#ff6600"><b>{consultHistoryData && consultHistoryData.length > 2 && moment(consultHistoryData[2].csldate).format('YYYY/MM/DD')}</b></font></span>
          <span><font color="#ff6600"><b>{consultHistoryData && consultHistoryData.length > 2 && consultHistoryData[2].cssname}</b></font></span>
        </div>
        <div style={{ float: 'right', marginRight: '100px' }}>
          {this.getMenResultButtons(lngEntryMode)}
        </div>
        {this.getMenResult1()}
      </div>
    );
  }
}
// propTypesの定義
MenResultHeader.propTypes = {
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData1: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData3: PropTypes.arrayOf(PropTypes.shape()),
  memResult: PropTypes.shape().isRequired,
  // peridData: PropTypes.shape().isRequired,
  orderNoData1: PropTypes.shape().isRequired,
  orderNoData2: PropTypes.shape().isRequired,
  orderNoData3: PropTypes.shape().isRequired,
  // redux-form化によって紐付けされた項目
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  onUpdate: PropTypes.func,
  entrymode: PropTypes.number.isRequired,
  match: PropTypes.shape().isRequired,
  ismodal: PropTypes.number.isRequired,
};

MenResultHeader.defaultProps = {
  consultHistoryData: [],
  historyRslData1: [],
  historyRslData3: [],
  onUpdate: undefined,
};

export default MenResultHeader;
