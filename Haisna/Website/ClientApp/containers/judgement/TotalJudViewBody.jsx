import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import qs from 'qs';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';

import Table from '../../components/Table';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';
import { getHistoriesRequest, openMenResultGuide } from '../../modules/judgement/interviewModule';
import { getConsultRequest } from '../../modules/reserve/consultModule';
import { getFreeRequest } from '../../modules/preference/freeModule';
import MenResult from './MenResult';
import * as constants from '../../constants/common';
import { openEntryAutherGuide } from '../../modules/result/resultModule';
import EntryAutherGuide from './EntryAutherGuide';
import { openFollowInfoGuide } from '../../modules/followup/followModule';
import FollowinfoTop from './FollowinfoTop';

class TotalJudViewBody extends React.Component {
  constructor(props) {
    super(props);

    // 過去総合コメント
    this.handleOldJudCommentClick = this.handleOldJudCommentClick.bind(this);
  }

  componentDidMount() {
    this.doSearch(this.props);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { params } = nextProps;
    if (params.csgrp !== this.props.params.csgrp) {
      this.doSearch(nextProps);
    }
  }

  // 病歴情報
  getHistoryRslDisData = (data) => {
    if (data && data.length > 0) {
      return <a role="presentation" onClick={this.callDiseaseHistory}>病歴情報</a>;
    }
    return <Button onClick={this.callDiseaseHistory} value="病歴情報" />;
  };

  // チャート情報
  getPubNoteChartData = (data) => {
    if (data && data.length > 0) {
      return <a role="presentation" onClick={() => this.callCommentList(constants.CHART_NOTEDIV)} style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>チャート情報</a>;
    }
    return <Button onClick={() => this.callCommentList(constants.CHART_NOTEDIV)} value="チャート情報" />;
  };

  // 注意事項
  getPubNoteCaution = (data) => {
    if (data && data.length > 0) {
      return <a role="presentation" onClick={() => this.callCommentList(constants.CAUTION_NOTEDIV)} style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>注意事項</a>;
    }
    return <Button onClick={() => this.callCommentList(constants.CAUTION_NOTEDIV)} value="注意事項" />;
  };

  // 自覚症状
  getJikakuData = (data) => {
    if (data && data.length > 0) {
      return <a role="presentation" onClick={this.showJikakushoujyou}>自覚症状</a>;
    }
    return <span />;
  };

  // 特定健診対象
  getJikakuData = (data) => {
    if (data && data.length > 0) {
      return <a role="presentation" onClick={this.showJikakushoujyou}>自覚症状</a>;
    }
    return <span />;
  };

  // 特定健診対象
  getClassCd = (classCdData) => {
    if (classCdData) {
      return <Button onClick={this.callSpecialKenshin} value="特定健診" />;
    }
    return <span />;
  };

  // 切替日以降の受診日であれば食習慣ボタンを表示
  getIsVer201210 = (consult, freedata) => {
    let chgDate = '';

    // 受診情報検索
    if (!consult || !consult.csldate) {
      return <Button onClick={this.callMenEiyoShido} value="栄養指導" />;
    }

    // 切替日の取得
    if (freedata && freedata.length > 0) {
      chgDate = freedata[0].freefield1;
    }

    if (chgDate && chgDate !== '' && moment(chgDate).isBefore(consult.csldate)) {
      return <Button onClick={this.callShokushukan} value="食習慣" />;
    }

    return <Button onClick={this.callMenEiyoShido} value="栄養指導" />;
  };

  // 前回フォロー情報が登録されている場合、ボタン表示
  getFollowupBefore = (data) => {
    if (JSON.stringify(data) !== '{}' && JSON.stringify(data) !== undefined) {
      return <Button onClick={() => this.callfollowupBefore(constants.CHART_NOTEDIV)} value="前回フォローアップ" />;
    }
    return '';
  };

  // フォローアップ
  getFollowupNyuryoku = (followInfoData, targetFollowData) => {
    if (JSON.stringify(followInfoData) !== '{}' && JSON.stringify(followInfoData) !== undefined) {
      return <Button onClick={() => this.callfollowupNyuryoku(constants.CHART_NOTEDIV)} value="フォローアップ_UP" />;
    } else if (targetFollowData && targetFollowData.length > 0) {
      return <Button onClick={() => this.callfollowupNyuryoku(constants.CHART_NOTEDIV)} value="フォローアップ" />;
    }

    return '';
  };

  getJudCd = (data) => {
    let res = '';
    const judCd = data.judcd;
    const rsvNo = data.rsvno;
    const updFlg = data.updflg;
    if (!rsvNo || rsvNo === '') {
      res = '***';
      return res;
    }
    if (updFlg === '1' && rsvNo && rsvNo !== '' && judCd && judCd !== '') {
      res = judCd;
    } else {
      res = judCd;
    }
    return res;
  };

  getJudList = (data) => {
    const { onOpenMenResultGuide } = this.props;

    // 表示位置
    let lngDspPoint;
    // 前判定分類コード
    let lngLastJudClassCd;

    lngLastJudClassCd = 0;
    lngDspPoint = 0;
    let tds = [];
    const trs = [];
    for (let i = 0; i < data.length; i += 1) {
      // 判定分類が変わった？
      if (lngLastJudClassCd !== data[i].judclasscd) {
        lngLastJudClassCd = data[i].judclasscd;
      }

      if (lngDspPoint % 3 === 0) {
        if (data[i].resultdispmode && !Number.isNaN(data[i].resultdispmode)) {
          tds.push(<td width="150"><a role="presentation" onClick={() => onOpenMenResultGuide(data[i].resultdispmode)} style={{ color: '#006699', cursor: 'pointer' }}>{data[i].judclassname}</a></td>);
        } else {
          tds.push(<td width="150">{data[i].judclassname}</td>);
        }
      }

      if (data[i].seq === 1) {
        // 依頼無し
        if (!data[i].rsvno || data[i].rsvno === '') {
          tds.push(<td align="center" width="50"><span style={{ color: '999999', fontWeight: 'bold' }}>***</span></td>);
        } else if ((data[i].updflg && data[i].updflg.trim === '1') && (data[i].rsvno && data[i].rsvno !== '') && (data[i].judcd && data[i].judcd !== '')) {
          // ピンク色⇒灰色
          tds.push(<td bgcolor="#cccccc" align="center" width="50"><span style={{ fontWeight: 'bold' }}>{data[i].judcd}</span></td>);
        } else {
          tds.push(<td align="center" width="50"><span style={{ fontWeight: 'bold' }}>{data[i].judcd}</span></td>);
        }
        // 依頼無し
      } else if (!data[i].rsvno || data[i].rsvno === '') {
        tds.push(<td align="center" width="50"><span style={{ color: '999999', fontWeight: 'bold' }}>***</span></td>);
      } else if ((data[i].updflg && data[i].updflg.trim === '1') && (data[i].rsvno && data[i].rsvno !== '') && (data[i].judcd && data[i].judcd !== '')) {
        // ピンク色⇒灰色
        tds.push(<td bgcolor="#cccccc" align="center" width="60"><span style={{ fontWeight: 'bold' }}>{data[i].judcd}</span></td>);
      } else {
        tds.push(<td align="center" width="60"><span style={{ fontWeight: 'bold' }}>{data[i].judcd}</span></td>);
      }

      lngDspPoint += 1;

      if (lngDspPoint === data.length && lngDspPoint % 6 !== 0) {
        tds.push(<td align="center" width="60" />);
        tds.push(<td align="center" width="60" />);
        tds.push(<td align="center" width="60" />);
      }

      if (lngDspPoint % 6 === 0) {
        trs.push((
          <tr key={`${lngDspPoint}`}>
            {tds}
          </tr>
        ));
        tds = [];
      }
    }
    return trs;
  };

  // 病歴情報
  callDiseaseHistory = () => {
    const { history, consultHistoryData, params } = this.props;
    const { cscd } = consultHistoryData[0];
    const winmode = '0';
    const { rsvno } = params;
    history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/diseasehistory/${winmode}`);
  }

  // コメント一覧（チャート情報、注意事項）呼び出し
  callCommentList = (noteDiv) => {
    const { history, consultHistoryData, params } = this.props;
    const { rsvno } = params;
    const { csldate, cscd } = consultHistoryData[0];
    const startdate = moment(csldate).subtract(5, 'years').format('YYYY/MM/DD');
    const enddate = moment(csldate).format('YYYY/MM/DD');
    history.push({
      pathname: `/contents/judgement/interview/top/${rsvno}/${cscd}/commentlistflame/22/0`,
      search: qs.stringify({ startdate, enddate, pubnotedivcd: noteDiv, dispkbn: '1', dispmode: '2', cmtmode: '1,1,0,0' }),
    });
  }

  // 問診内容
  callMonshinNyuryoku = () => {
    const { history, params } = this.props;
    const { winmode } = params;
    const { rsvno } = params;
    history.push(`/contents/judgement/interview/top/${rsvno}/monshinnyuryoku/${winmode}`);
  }

  // 自覚症状
  showJikakushoujyou = () => {
  }

  // 特定健診対象
  callSpecialKenshin = () => {
    const { history, params } = this.props;
    const { rsvno } = params;
    history.push(`/contents/judgement/specialinterview/${rsvno}`);
  }

  // 判定修正
  calltotalJudEdit = (winmode, rsvno, grpcd, cscd) => {
    const { history } = this.props;
    history.push(`/contents/judgement/interview/top/${rsvno}/totaljudedit/${winmode}/${grpcd}/${cscd}`);
  }

  // 虚血性心疾患
  callMenKyoketsu = () => {
  }

  // 栄養指導呼び出し
  callMenEiyoShido = () => {
  }

  // 食習慣呼び出し
  callShokushukan = () => {
  }

  // CU経年変化
  callCUSelectItemsMain = () => {
  }

  // 変更履歴
  callrslUpdateHistory = () => {
    const { history, consultHistoryData, params } = this.props;
    const { cscd } = consultHistoryData[0];
    const winmode = '0';
    const { rsvno } = params;
    history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/rslupdatehistory/${winmode}`);
  }

  // 前回フォローアップ情報画面呼び出し
  // callfollowupBefore = (noteDiv) => {
  callfollowupBefore = () => {
    const { onOpenFollowInfoGuide } = this.props;
    onOpenFollowInfoGuide();
  }

  // フォローアップ登録画面呼び出し
  // callfollowupNyuryoku = (noteDiv) => {
  callfollowupNyuryoku = () => {
    const { history, consultHistoryData, params } = this.props;
    const { cscd } = consultHistoryData[0];
    const { winmode } = params;
    const { rsvno } = params;
    history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/followinfo/${winmode}`);
  }

  // 担当者登録ウインドウ呼び出し
  showTantouWindow = () => {
    const { onOpenEntryAutherGuide } = this.props;
    onOpenEntryAutherGuide();
  }

  doSearch = (props) => {
    const { onLoad, params } = props;

    // 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
    let lngLastDspMode;
    // 前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
    let vntCsGrp;
    let strSelCsGrp = params.csgrp;
    strSelCsGrp = ((!strSelCsGrp || strSelCsGrp === '') ? '0' : strSelCsGrp);

    switch (strSelCsGrp) {
      // すべてのコース
      case '0':
        lngLastDspMode = 0;
        vntCsGrp = '';
        break;
      // 同一コース
      case '1':
        lngLastDspMode = 1;
        vntCsGrp = params.cscd;
        break;
      default:
        lngLastDspMode = 2;
        vntCsGrp = params.csgrp;
    }
    onLoad({ rsvNo: params.rsvno, lastDspMode: lngLastDspMode, csGrp: vntCsGrp });
  }

  // 過去総合コメント
  handleOldJudCommentClick = () => {
    const { history, consultHistoryData, params } = this.props;
    const { cscd } = consultHistoryData[0];
    const winmode = '0';
    const { rsvno } = params;
    history.push(`/contents/judgement/interview/top/${rsvno}/${cscd}/viewoldjudcomment/${winmode}`);
  }

  render() {
    const { consultHistoryData, judHistoryRslList, message, historyRslData, commentData, history, location } = this.props;
    const { historyRslDisData, pubNoteChartData, pubNoteCautionData, historyRslJikakuData, classCdData, consult, freedata, followBeforeData, followInfoData, targetFollowData } = this.props;
    let { params } = this.props;

    // 今回コースコード退避
    if (consultHistoryData && consultHistoryData.length > 0) {
      params = { ...params, cscd: consultHistoryData[0].cscd };
    } else {
      return null;
    }

    if (!judHistoryRslList && judHistoryRslList.length === 0) {
      return null;
    }

    return (
      <div>
        <div style={{ float: 'left' }}>
          <MessageBanner messages={message} />
          <Table BORDER="0" CELLSPACING="1" CELLPADDING="2">
            <thead>
              <tr bgcolor="#cccccc" align="center">
                <th rowSpan="2" width="119">分類</th>
                <th colSpan="3" width="180">判定結果</th>
                <th rowSpan="2" width="100">分類</th>
                <th colSpan="3" width="190">判定結果</th>
              </tr>
              <tr bgcolor="#cccccc" align="center">
                <th width="50">今回</th>
                <th width="60">前回</th>
                <th width="60">前々回</th>
                <th width="60">今回</th>
                <th width="60">前回</th>
                <th width="60">前々回</th>
              </tr>
            </thead>
            <tbody>
              {this.getJudList(judHistoryRslList)}
            </tbody>
          </Table>
          <MenResult params={{ grpno: '', winmode: '1', rsvno: params.rsvno, grpcd: params.grpcd, cscd: params.cscd }} history={history} location={location} />
        </div>
        <div style={{ float: 'left', marginLeft: '30px' }}>
          <GridList cols={2} cellHeight={30} style={{ width: 260 }}>
            {/* 病歴情報あり？ */}
            <GridListTile><div>{this.getHistoryRslDisData(historyRslDisData)}</div></GridListTile>
            {/* 判定修正 */}
            <GridListTile><div><Button onClick={() => this.calltotalJudEdit(params.winmode, params.rsvno, params.grpcd, params.cscd)} value="判定修正" /></div></GridListTile>
            {/* チャート情報あり？ */}
            <GridListTile><div>{this.getPubNoteChartData(pubNoteChartData)}</div></GridListTile>
            {/* 虚血性心疾患 */}
            <GridListTile><div><Button onClick={this.callMenKyoketsu} value="虚血性心疾患" /></div></GridListTile>
            {/* 注意事項あり？ */}
            <GridListTile><div>{this.getPubNoteCaution(pubNoteCautionData)}</div></GridListTile>
            {/* 切替日付による画面切替 */}
            <GridListTile><div>{this.getIsVer201210(consult, freedata)}</div></GridListTile>
            {/* 問診画面 */}
            <GridListTile><div><Button onClick={this.callMonshinNyuryoku} value="問診内容" /></div></GridListTile>
            {/* CU経年変化 */}
            <GridListTile><div><Button onClick={this.callCUSelectItemsMain} value="CU経年変化" /></div></GridListTile>
            {/* 自覚症状あり？ */}
            <GridListTile><div>{this.getJikakuData(historyRslJikakuData)}</div></GridListTile>
            {/* 変更履歴 */}
            <GridListTile><div><Button onClick={this.callrslUpdateHistory} value="変更履歴" /></div></GridListTile>
            {/* 特定健診対象 */}
            <GridListTile><div>{this.getClassCd(classCdData)}</div></GridListTile>
            <GridListTile><div /></GridListTile>
          </GridList>
          <GridList cols={2} cellHeight="auto" style={{ marginTop: '200px', width: 300 }}>
            {/* 判定医検索  */}
            <GridListTile>
              {historyRslData && historyRslData.length > 0 && historyRslData.map((rec) => (
                <div>
                  <div style={{ float: 'left', backgroundColor: '#eeeeee', marginBottom: '3px' }}>{rec.itemname}</div>
                  <div style={{ float: 'left', backgroundColor: '#eeeeee', marginBottom: '3px', marginLeft: '10px' }}>{rec.result}</div>
                  <div style={{ clear: 'left' }} />
                </div>
              ))}
            </GridListTile>
            <GridListTile>
              <div style={{ marginBottom: '5px' }}>{this.getFollowupBefore(followBeforeData)}</div>
              <div style={{ marginBottom: '5px' }}>{this.getFollowupNyuryoku(followInfoData, targetFollowData)}</div>
              <div style={{ marginBottom: '5px' }}><Button onClick={this.showTantouWindow} value="担当者登録" /></div>
            </GridListTile>
          </GridList>
        </div>
        <div style={{ clear: 'both' }} />
        <div style={{ marginTop: '20px' }}>
          <div style={{ marginRight: '10px', border: '1px solid #999999', float: 'left', backgroundColor: '#eeeeee', height: '22px', width: '700px', color: '#333333' }} ><span>総合コメント</span></div>
          <div><Button onClick={this.handleOldJudCommentClick} value="過去総合コメント" /></div>
        </div>
        {commentData && commentData.length > 0 && commentData.map((rec) => (
          <div>{rec.judcmtstc}</div>
        ))}
        <div>
          <EntryAutherGuide match={{ params: { rsvno: params.rsvno } }} />
          <FollowinfoTop match={{ params: { rsvno: followBeforeData.rsvno, winmode: '1' } }} />
        </div>
      </div>
    );
  }
}

// propTypesの定義
TotalJudViewBody.propTypes = {
  // onLoad: PropTypes.func.isRequired,
  historyRslDisData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  pubNoteChartData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  pubNoteCautionData: PropTypes.arrayOf(PropTypes.shape()),
  historyRslJikakuData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  classCdData: PropTypes.bool.isRequired,
  consult: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  freedata: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  followBeforeData: PropTypes.shape(),
  followInfoData: PropTypes.shape(),
  targetFollowData: PropTypes.arrayOf(PropTypes.shape()),
  judHistoryRslList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  historyRslData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  commentData: PropTypes.arrayOf(PropTypes.shape()),
  onOpenMenResultGuide: PropTypes.func.isRequired,
  params: PropTypes.shape().isRequired,
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
  onOpenEntryAutherGuide: PropTypes.func.isRequired,
  onOpenFollowInfoGuide: PropTypes.func.isRequired,
};

// defaultPropsの定義
TotalJudViewBody.defaultProps = {
  followBeforeData: undefined,
  followInfoData: undefined,
  targetFollowData: undefined,
  pubNoteCautionData: undefined,
  commentData: undefined,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  judHistoryRslList: state.app.judgement.interview.interView.judHistoryRslList,
  commentData: state.app.judgement.interview.interView.commentData,
  message: state.app.judgement.interview.interView.message,
  historyRslData: state.app.judgement.interview.interView.historyRslData,
  historyRslDisData: state.app.judgement.interview.interView.historyRslDisData,
  pubNoteChartData: state.app.judgement.interview.interView.pubNoteChartData,
  pubNoteCautionData: state.app.judgement.interview.interView.pubNoteCautionData,
  historyRslJikakuData: state.app.judgement.interview.interView.historyRslJikakuData,
  consult: state.app.reserve.consult.consultList.consult,
  freedata: state.app.preference.free.freeList.freedata,
  followBeforeData: state.app.judgement.interview.interView.followBeforeData,
  followInfoData: state.app.judgement.interview.interView.followInfoData,
  targetFollowData: state.app.judgement.interview.interView.targetFollowData,
  classCdData: state.app.judgement.interview.interView.classCdData,
  consultHistoryData: state.app.judgement.interview.interView.consultHistoryData,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 検索条件に従い受診情報一覧を抽出する
    dispatch(getHistoriesRequest({ ...params }));
    dispatch(getConsultRequest({ rsvno: params.rsvNo }));
    dispatch(getFreeRequest({ ...params, mode: 0, freeCd: 'CHG201210' }));
  },
  onOpenMenResultGuide: (resultdispmode) => {
    // 開くアクションを呼び出す
    dispatch(openMenResultGuide(resultdispmode));
  },

  // 担当者登録ウインドウ呼び出し
  onOpenEntryAutherGuide: () => {
    // const { rsvno } = params;
    // 開くアクションを呼び出す
    dispatch(openEntryAutherGuide());
  },

  // 前回フォローアップ情報画面呼び出し
  onOpenFollowInfoGuide: () => {
    // const { rsvno } = params;
    // 開くアクションを呼び出す
    dispatch(openFollowInfoGuide());
  },

});

export default connect(mapStateToProps, mapDispatchToProps)(TotalJudViewBody);
