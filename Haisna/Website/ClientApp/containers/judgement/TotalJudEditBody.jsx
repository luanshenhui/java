import React from 'react';
import PropTypes from 'prop-types';
import { formValueSelector, blur, Field } from 'redux-form';
import { connect } from 'react-redux';

import DropDown from '../../components/control/dropdown/DropDown';
import Table from '../../components/Table';
import Button from '../../components/control/Button';
import MessageBanner from '../../components/MessageBanner';
// import MenResult from './MenResult';

import { initializeInterview, getTotalJudEditBodyRequest, saveTotalJudRequest, openMenResultGuide } from '../../modules/judgement/interviewModule';

const formName = 'TotalJudEdit';

class TotalJudEditBody extends React.Component {
  componentDidMount() {
    const { onInit } = this.props;
    onInit();
    this.doSearch(this.props);
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { params } = nextProps;
    const nextMessage = nextProps.message && nextProps.message.length > 0 ? nextProps.message[0] : '';
    const nowMessage = this.props.message && this.props.message.length > 0 ? this.props.message[0] : '';
    if ((params.csgrp !== this.props.params.csgrp) || (nextMessage !== nowMessage)) {
      this.doSearch(nextProps);
    }
  }

  getJudList = () => {
    const { onOpenMenResultGuide, judHistoryRslList, judList } = this.props;

    // 表示位置
    let lngDspPoint;
    // 判定分類件数
    let lngJudClassCount;
    // 前判定分類コード
    let lngLastJudClassCd;

    lngJudClassCount = 0;
    lngLastJudClassCd = 0;
    lngDspPoint = 0;
    let tds = [];
    const trs = [];
    for (let i = 0; i < judHistoryRslList.length; i += 1) {
      // 判定分類が変わった？
      if (lngLastJudClassCd !== judHistoryRslList[i].judclasscd) {
        lngJudClassCount += 1;
        lngLastJudClassCd = judHistoryRslList[i].judclasscd;
      }

      if (lngDspPoint % 3 === 0) {
        if (judHistoryRslList[i].resultdispmode && !Number.isNaN(judHistoryRslList[i].resultdispmode)) {
          tds.push((
            <td key={`td-name-${lngDspPoint}`} width="150">
              <a role="presentation" onClick={() => onOpenMenResultGuide(judHistoryRslList[i].resultdispmode)} style={{ color: '#006699', cursor: 'pointer' }}>{judHistoryRslList[i].judclassname}</a>
            </td>
          ));
        } else {
          tds.push(<td key={`td-name-${lngDspPoint}`} width="150">{judHistoryRslList[i].judclassname}</td>);
        }
      }

      if (judHistoryRslList[i].seq === 1) {
        // 依頼無し
        if (!judHistoryRslList[i].rsvno || judHistoryRslList[i].rsvno === '') {
          tds.push(<td key={`td-data-${lngDspPoint}`} align="center"><span style={{ fontWeight: 'bold' }}>***</span></td>);
        } else {
          const judClassCount = lngJudClassCount;
          tds.push((
            <td key={`td-data-${lngDspPoint}`}>
              <Field
                name={`judcd[${i}]`}
                onChange={(e) => this.judCheck(e, judHistoryRslList[i].judclasscd, judClassCount)}
                component={DropDown}
                items={judList}
                value={`${judHistoryRslList[i].judcd}`}
                addblank
              />
            </td>
          ));
        }
        // 依頼無し
      } else if (!judHistoryRslList[i].rsvno || judHistoryRslList[i].rsvno === '') {
        tds.push(<td key={`td-data-${lngDspPoint}`} align="center" width="60"><span style={{ fontWeight: 'bold' }}>***</span></td>);
      } else if ((judHistoryRslList[i].updflg && judHistoryRslList[i].updflg.trim === '1')
        && (judHistoryRslList[i].rsvno && judHistoryRslList[i].rsvno !== '')
        && (judHistoryRslList[i].judcd && judHistoryRslList[i].judcd !== '')) {
        // ピンク色⇒灰色
        tds.push(<td key={`td-data-${lngDspPoint}`} bgcolor="#cccccc" align="center" width="60"><span style={{ fontWeight: 'bold' }}>{judHistoryRslList[i].judcd}</span></td>);
      } else {
        tds.push(<td key={`td-data-${lngDspPoint}`} align="center" width="60"><span style={{ fontWeight: 'bold' }}>{judHistoryRslList[i].judcd}</span></td>);
      }

      lngDspPoint += 1;

      if (lngDspPoint === judHistoryRslList.length && lngDspPoint % 6 !== 0) {
        tds.push(<td key="td-last-3" align="center" width="60" />);
        tds.push(<td key="td-last-2" align="center" width="60" />);
        tds.push(<td key="td-last-1" align="center" width="60" />);
      }

      if (lngDspPoint % 6 === 0) {
        trs.push((
          <tr key={`tr${lngDspPoint}`}>
            {tds}
          </tr>
        ));
        tds = [];
      }
    }
    return trs;
  };

  // 新しい日本人のGFR推算式
  getGfr = () => {
    const { mdrdHistory, newGfrHistory } = this.props;
    const tds = [];
    const trs = [];

    tds.push(<td key="mdrdHistoryTH" width="119" bgcolor="#cccccc">eGFR(MDRD式)</td>);
    for (let i = 0; i <= 2; i += 1) {
      if (i <= mdrdHistory.length - 1) {
        tds.push(<td key={`mdrdHistory${i}`} align="right" width="50"><span style={{ fontWeight: 'bold' }}>{mdrdHistory[i].egfr}</span></td>);
      } else {
        tds.push(<td key={`mdrdHistory${i}`} align="center" width="60"><span style={{ fontWeight: 'bold', color: '#999999' }}>***</span></td>);
      }
    }

    tds.push(<td key="newGfrHistoryTH" width="119" bgcolor="#cccccc">GFR(日本人推算式)</td>);
    for (let i = 0; i <= 2; i += 1) {
      if (i <= newGfrHistory.length - 1) {
        tds.push(<td key={`newGfrHistory${i}`} align="right" width="50"><span style={{ fontWeight: 'bold' }}>{newGfrHistory[i].gfr}</span></td>);
      } else {
        tds.push(<td key={`newGfrHistory${i}`} align="center" width="60"><span style={{ fontWeight: 'bold', color: '#999999' }}>***</span></td>);
      }
    }

    trs.push((
      <tr key="gfrTR" bgcolor="#eeeeee" height="18px">
        {tds}
      </tr>
    ));

    return trs;
  };

  // 判定コメント文章データ
  getSelectDataJudCmtstc = () => {
    const { editCmtData } = this.props;
    const opts = [];
    if (editCmtData && editCmtData.length > 0) {
      for (let i = 0; i < editCmtData.length; i += 1) {
        opts.push(<option key={`selectDataJudCmtstc${i + 1}`} value={i + 1}>{editCmtData[i].judcmtstc}</option>);
      }
    }
    return (
      <Field name="selectLine" component="select" size="20" style={{ width: '600px' }}>
        {opts}
      </Field>
    );
  };

  // 総合コメントセット
  setTotalCmt = (index, cmtmode, selCmtData) => {
    const { editCmtData, setValue } = this.props;

    if (!selCmtData || selCmtData.length === 0) {
      return;
    }
    let startline;
    if (cmtmode === 'add') {
      startline = Number(index);
    } else if (cmtmode === 'insert') {
      startline = Number(index) - 1;
    } else if (cmtmode === 'edit') {
      startline = Number(index) - 1;
      editCmtData.splice(startline, 1);
    }
    for (let i = 0; i < selCmtData.length; i += 1) {
      editCmtData.splice(startline + i, 0, selCmtData[i]);
    }

    const varEditCmtData = [];
    for (let i = 0; i < editCmtData.length; i += 1) {
      varEditCmtData[i] = { ...editCmtData[i], seq: i + 1, value: i + 1, name: editCmtData[i].judcmtstc };
    }
    setValue('editCmtData', varEditCmtData);
    setValue('cmtmode', 'save');
  }

  // 総合コメント削除
  deleteJudComment = (index, msgflg) => {
    const { editCmtData, setValue } = this.props;
    if (!index || Number(index) === 0) {
      alert('編集する行が選択されていません。');
      return;
    }

    if (msgflg === 1) {
      if (!confirm('選択されたコメントを削除します。よろしいですか？')) {
        return;
      }
    }

    // editCmtData = editCmtData.filter((val) => (val.value !== index));
    editCmtData.splice(Number(index) - 1, 1);
    const varEditCmtData = [];
    for (let i = 0; i < editCmtData.length; i += 1) {
      varEditCmtData[i] = { ...editCmtData[i], seq: i + 1, value: i + 1 };
    }
    setValue('editCmtData', varEditCmtData);
    setValue('cmtmode', 'save');
  };

  // 判定コード onChange
  judCheck = (e, judclass, classindex) => {
    const { editJudData, judList, editCmtData } = this.props;
    let i;
    let j;
    const selJudCd = e.target.value;
    editJudData[classindex - 1] = { judclasscd: judclass, judcd: selJudCd };

    for (i = 0; i < judList.length; i += 1) {
      if (judList[i].judcd === selJudCd) {
        // //判定の重みが20より大
        if (judList[i].weight > 20) {
          // 総合コメントガイドを表示する
          this.showJudCommentWindow(editCmtData.length, judclass, 'add');
        } else {
          // 編集エリアに未セットならセット
          for (j = 0; j < editCmtData.length; j += 1) {
            // 判定分類一致で判定の重いコメントは削除
            if (editCmtData[j].judclasscd === judclass && editCmtData[j].weight > 20) {
              this.deleteJudComment(j + 1, 0);
              j -= 1;
            }
          }
        }
      }
    }
  };

  // 総合コメントウインドウ呼び出し
  showJudCommentWindow = (index, judclscd, cmtmode) => {
    const { editCmtData } = this.props;
    const selCmtData = [];
    let pIndex = index;

    if (cmtmode === 'insert' || cmtmode === 'edit') {
      if (!index || Number(index) === 0) {
        alert('編集する行が選択されていません。');
        return;
      }
    }

    if (!pIndex || pIndex === 0) {
      pIndex = editCmtData.length;
    }

    selCmtData.push({ seq: 0, judcmtcd: '', judcmtstc: `TEST 1 ～ 分類コード：${judclscd}`, judclasscd: judclscd, judcd: 0, weight: 21 });
    selCmtData.push({ seq: 0, judcmtcd: '', judcmtstc: `TEST 2 ～ 分類コード：${judclscd}`, judclasscd: judclscd, judcd: 0, weight: 31 });
    selCmtData.push({ seq: 0, judcmtcd: '', judcmtstc: `TEST 3 ～ 分類コード：${judclscd}`, judclasscd: judclscd, judcd: 0, weight: 41 });
    this.setTotalCmt(pIndex, cmtmode, selCmtData);
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
    onLoad({ rsvNo: params.rsvno, lastDspMode: lngLastDspMode, csGrp: vntCsGrp, formName });
  }

  // urlボタンクリック時の処理
  handleUrlClick = (strUrl) => {
    const { history } = this.props;
    history.push({
      pathname: strUrl,
    });
  }

  // 総合判定参照画面呼び出し
  calltotalJudView = (winmode, rsvno, grpcd, cscd) => {
    const strUrl = `/contents/judgement/interview/top/${rsvno}/totaljudview/${winmode}/${grpcd}/${cscd}`;
    this.handleUrlClick(strUrl);
  }

  // 保存
  saveJud = () => {
    const { onSave, params, judHistoryRslList, editJudData, cmtmode, commentData, editCmtData, consultHistoryData } = this.props;

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
    onSave({
      rsvNo: params.rsvno,
      lastDspMode: lngLastDspMode,
      csGrp: vntCsGrp,
      vntJudData: judHistoryRslList,
      vntEditJudData: editJudData,
      vntCmtData: commentData,
      vntEditCmtData: editCmtData,
      cmtmode,
      cscd: consultHistoryData[0].cscd,
      formName,
    });
  }

  render() {
    const { message, params, selectLine } = this.props;
    return (
      <div>
        <div style={{ float: 'left', width: 800 }}>
          <MessageBanner messages={message} />
          <Table BORDER="0" CELLSPACING="1" CELLPADDING="2">
            <thead>
              <tr bgcolor="#cccccc" align="center">
                <th rowSpan="2" width="150">分類</th>
                <th colSpan="3" width="182">判定結果</th>
                <th rowSpan="2" width="150">分類</th>
                <th colSpan="3" width="182">判定結果</th>
              </tr>
              <tr bgcolor="#cccccc" align="center">
                <th width="60">今回</th>
                <th width="60">前回</th>
                <th width="60">前々回</th>
                <th width="60">今回</th>
                <th width="60">前回</th>
                <th width="60">前々回</th>
              </tr>
            </thead>
            <tbody>
              {this.getJudList()}
              {this.getGfr()}
            </tbody>
          </Table>
        </div>
        <div style={{ float: 'left', marginLeft: '60px' }}>
          <div><Button className="btn" onClick={() => this.saveJud()} value="保存" /></div>
          <div><a role="presentation" onClick={() => this.calltotalJudView(params.winmode, params.rsvno, params.grpcd, params.cscd)} style={{ color: '#006699', cursor: 'pointer' }}>参照専用画面へ</a></div>
        </div>
        <div style={{ clear: 'both' }} />
        <div style={{ marginTop: '20px' }} >
          <div>総合コメント</div>
          <div>
            <div style={{ float: 'left' }}>
              {this.getSelectDataJudCmtstc()}
            </div>
            <div style={{ float: 'left', border: '1px solid', padding: '1px', marginLeft: '2px' }}>
              <div style={{ border: '1px solid', width: '60px', textAlign: 'center', padding: '0', margin: '1px' }}>
                <a role="presentation" onClick={() => this.showJudCommentWindow(selectLine, 0, 'add')} style={{ color: '#006699', cursor: 'pointer' }}>追加</a>
              </div>
              <div style={{ border: '1px solid', width: '60px', textAlign: 'center', padding: '0', margin: '1px' }}>
                <a role="presentation" onClick={() => this.showJudCommentWindow(selectLine, 0, 'insert')} style={{ color: '#006699', cursor: 'pointer' }}>挿入</a>
              </div>
              <div style={{ border: '1px solid', width: '60px', textAlign: 'center', padding: '0', margin: '1px' }}>
                <a role="presentation" onClick={() => this.showJudCommentWindow(selectLine, 0, 'edit')} style={{ color: '#006699', cursor: 'pointer' }}>修正</a>
              </div>
              <div style={{ border: '1px solid', width: '60px', textAlign: 'center', padding: '0', margin: '1px' }}>
                <a role="presentation" onClick={() => this.deleteJudComment(selectLine, 1)} style={{ color: '#006699', cursor: 'pointer' }}>削除</a>
              </div>
            </div>
            <div style={{ clear: 'both' }} />
          </div>
        </div>
        {/* <MenResult params={{ grpno: '', winmode: '1', rsvno: params.rsvno, grpcd: params.grpcd, cscd: params.cscd }} history={history} location={location} /> */}
      </div>
    );
  }
}
// propTypesの定義
TotalJudEditBody.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  params: PropTypes.shape().isRequired,
  onOpenMenResultGuide: PropTypes.func.isRequired,
  judHistoryRslList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  judList: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  mdrdHistory: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  newGfrHistory: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  selectLine: PropTypes.string,
  cmtmode: PropTypes.string,
  editJudData: PropTypes.arrayOf(PropTypes.shape()),
  editCmtData: PropTypes.arrayOf(PropTypes.shape()),
  history: PropTypes.shape().isRequired,
  onSave: PropTypes.func.isRequired,
  onInit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  commentData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // location: PropTypes.shape().isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => {
  const selector = formValueSelector(formName);
  return {
    cmtmode: selector(state, 'cmtmode'),
    selectLine: selector(state, 'selectLine'),
    editJudData: selector(state, 'editJudData'),
    editCmtData: selector(state, 'editCmtData'),
    message: state.app.judgement.interview.interView.message,
    consultHistoryData: state.app.judgement.interview.interView.consultHistoryData,
    judHistoryRslList: state.app.judgement.interview.interView.judHistoryRslList,
    judList: state.app.judgement.interview.interView.judList,
    mdrdHistory: state.app.judgement.interview.interView.mdrdHistory,
    newGfrHistory: state.app.judgement.interview.interView.newGfrHistory,
    commentData: state.app.judgement.interview.interView.commentData,
  };
};

// defaultPropsの定義
TotalJudEditBody.defaultProps = {
  editJudData: [],
  editCmtData: [],
  selectLine: '',
  cmtmode: '',
};

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onInit: () => {
    // 面接支援初期化処理
    dispatch(initializeInterview);
  },
  onLoad: (params) => {
    // 検索条件に従い受診情報一覧を抽出する
    dispatch(getTotalJudEditBodyRequest({ ...params }));
  },
  onSave: (params) => {
    // 検索条件に従い受診情報一覧を抽出する
    dispatch(saveTotalJudRequest({ ...params }));
  },
  onOpenMenResultGuide: (resultdispmode) => {
    // 開くアクションを呼び出す
    dispatch(openMenResultGuide(resultdispmode));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(TotalJudEditBody);
