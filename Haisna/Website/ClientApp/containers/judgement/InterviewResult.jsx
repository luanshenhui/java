import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';
import { Field } from 'redux-form';

import * as constants from '../../constants/common';
import CheckBox from '../../components/control/CheckBox';
import Table from '../../components/Table';
import MessageBanner from '../../components/MessageBanner';

const Wrapper = styled.div`
  table.mensetsu-tb {
    border-right: 1px solid #bbb;
  }

  table.mensetsu-tb td,
  table.mensetsu-tb th {
    padding: 3px 3px;
    border-left: 1px solid #bbb;
    border-bottom: 1px solid #bbb;
  }

  table.mensetsu-tb th {
    background-color: #ccc;
  }
`;

const icondelete = (
  <svg width="18" height="18" viewBox="0 0 1024 1024" fill="red">
    <path d="M920.144 187.344l-147.424-147.536-668.816 668.912 147.568 147.472zM772.72 856.192l147.424-147.472-668.608-668.912-147.68 147.536z" />
  </svg>);

const iconquestionData = 'M366.16 198.56l1.616 263.008c0 62.208 42.048 112.736 92.224 112.736h226.288l25.936 30.944v89.536l-25.936 31.184h-404.144l-25.856-31.184v-38.816h-187.552v147.712c0 62.256 42 112.8 93.68 112.8h643.568c51.648 0 93.76-50.544 93.76-112.8v-309.024c0-62.288-42.128-112.944-93.76-112.944h-224.784l-27.488-31.024v-152.128h-187.552zM550.528-64h-181.12v186.656h181.12v-186.656z';
const iconquestion = (
  <svg width="18" height="18" viewBox="0 0 1024 1024" fill="#6699FF" transform="rotate(180) scale(-1, 1)">
    <path
      d={iconquestionData}
    />
  </svg>);

// 検査結果表示タイプ１用のTABLEタグ生成 (type = 0)
// 検査結果表示タイプ３用のTABLEタグ生成 (type = 2)
class EditMenResultTable extends React.Component {
  clearSentenceInfo(lineno) {
    const { setValue } = this.props;
    // 所見、更新フラグ
    if (document.getElementById(`sentence${lineno}`)) {
      document.getElementById(`sentence${lineno}`).innerHTML = '&nbsp;';
    }
    setValue(`updinfo[${lineno}]`, { stccd: '', updflg: '1' });
  }

  render() {
    const { menResultTypeNo, hisCount, tabletype, consultHistoryData, historyRslData1, historyRslData3, hideflg, entrymode, message } = this.props;

    // 面接支援非表示フラグ(1:検査結果がない場合は非表示)
    const lngHideFlg = hideflg;
    const lngEntryMode = entrymode;

    let table;
    // 検査結果表示タイプ１用のTABLEタグ生成 (type = 0)
    if (tabletype === '0') {
      if (hisCount < 1) return null;
      if (!historyRslData1 || historyRslData1.length <= 0) return null;
      let lngRslCnt = historyRslData1 ? historyRslData1.length : -1;

      // 検査分類名称
      let strClassName;
      // 検査項目コード
      let strItemCd;
      // サフィックス
      let strSuffix;
      // 結果タイプ
      let lngResultType;
      // 検査項目名称
      let strItemName;
      // CU経年変化表示対象
      let strCUTargetFlg;
      // 単位
      let strUnit;
      // 基準値（最低）
      let strLowerValue;
      // 基準値（最高）
      let strUpperValue;
      // 最小値
      let strMinValue;
      // 最大値
      let strMaxValue;
      // 面接支援非表示フラグ
      let strHideInterview;
      // 検査分類名称(上の行）
      let strClassName1;
      // 行表示フラグ
      let blnTRFlg;
      // 値フラグ（True:有効値、False:無効値）
      let blnIsValue;
      // 基準値フラグ
      let lngStdValueFlg;
      // 背景色
      let strBgColor;
      // 検査結果インデックス
      let ArrIndex = [-1, -1, -1];

      if (lngRslCnt > 0) {
        strClassName = historyRslData1[0].classname;
        strItemCd = historyRslData1[0].itemcd;
        strSuffix = historyRslData1[0].suffix;
        lngResultType = historyRslData1[0].resulttype;
        strItemName = historyRslData1[0].itemname;
        strCUTargetFlg = historyRslData1[0].cutargetflg;
        strUnit = historyRslData1[0].unit;
        strLowerValue = historyRslData1[0].lowervalue;
        strUpperValue = historyRslData1[0].uppervalue;
        strMinValue = historyRslData1[0].minvalue;
        strMaxValue = historyRslData1[0].maxvalue;
        strHideInterview = historyRslData1[0].hideinterview;
      } else {
        lngRslCnt = -1;
      }
      strClassName1 = '';
      const trs = [];
      for (let i = 0; i <= lngRslCnt; i += 1) {
        const tds = [];

        blnTRFlg = false;
        // 次の検査項目になったとき、１行表示(最後の検査結果も含む)
        if (i === lngRslCnt) {
          blnTRFlg = true;
        } else if (strItemCd !== historyRslData1[i].itemcd || strSuffix !== historyRslData1[i].suffix) {
          blnTRFlg = true;
        }

        if (blnTRFlg) {
          // 検査分類
          if (strClassName1 !== strClassName) {
            strClassName1 = strClassName;
            tds.push((
              <td nowrap="true" align="center">{strClassName1}</td>
            ));
          } else {
            tds.push((
              <td nowrap="true" align="center">&nbsp;</td>
            ));
          }

          // CU
          if (lngEntryMode === 0) {
            if (strCUTargetFlg === 1) {
              tds.push((
                <td nowrap="true" width="18px"><Field component={CheckBox} name={`CUSelectItems[${i - 1}]`} checkedValue="1" /></td>
              ));
            } else {
              tds.push((
                <td nowrap="true" width="18px" />
              ));
            }
          }

          // 検査項目
          if (!strItemName || strItemName === '') {
            tds.push((
              <td nowrap="true">&nbsp;</td>
            ));
          } else {
            tds.push((
              <td nowrap="true">{strItemName}</td>
            ));
          }

          blnIsValue = [false, false, false];

          for (let j = 0; j <= 2; j += 1) {
            switch (j) {
              // 今回
              case 0: strBgColor = '#eeeeee'; break;
              // 前回
              case 1: strBgColor = '#90f0aa'; break;
              // 前々回
              case 2: strBgColor = '#ffffcc'; break;
              default: strBgColor = '#ffffff'; break;
            }

            if (ArrIndex[j] !== -1) {
              if (historyRslData1[ArrIndex[j]].rslflg === 0) {
                // 検査項目が存在しなかったら"***"表示
                tds.push((
                  <td nowrap="true" align="center" bgcolor={strBgColor}>&nbsp;</td>
                ));
                tds.push((
                  <td nowrap="true" align="right" bgcolor={strBgColor}>***</td>
                ));
              } else {
                // 基準値フラグ
                if (!historyRslData1[ArrIndex[j]] || !historyRslData1[ArrIndex[j]].stdflg || historyRslData1[ArrIndex[j]].stdflg === '') {
                  tds.push((
                    <td nowrap="true" align="center" bgcolor={strBgColor}>&nbsp;</td>
                  ));
                } else if (historyRslData1[ArrIndex[j]].stdflg === 'S' || historyRslData1[ArrIndex[j]].stdflg === 'X') {
                  tds.push((
                    <td nowrap="true" align="center" bgcolor={strBgColor}>&nbsp;</td>
                  ));
                } else {
                  tds.push((
                    <td nowrap="true" align="center" bgcolor={strBgColor}><span style={{ color: '#ff0000', fontWeight: 'bolder' }}>*</span></td>
                  ));
                }

                // 検査結果
                if (!historyRslData1[ArrIndex[j]] || !historyRslData1[ArrIndex[j]].result || historyRslData1[ArrIndex[j]].result === '') {
                  tds.push((
                    <td nowrap="true" align="right" bgcolor={strBgColor}>&nbsp;</td>
                  ));
                } else {
                  blnIsValue[j] = true;
                  // 符号つき数字のときはコメント１と結合
                  if (lngResultType === 8) {
                    // 符号つき数字のコメントを結果の後ろに表示する
                    tds.push((
                      <td nowrap="true" align="right" bgcolor={strBgColor}>{historyRslData1[ArrIndex[j]].result}{historyRslData1[ArrIndex[j]].rslcmtname1}</td>
                    ));
                  } else {
                    tds.push((
                      <td nowrap="true" align="right" bgcolor={strBgColor}>{historyRslData1[ArrIndex[j]].result}</td>
                    ));
                  }
                }
              }
            } else {
              // 検査項目が存在しなかったら"***"表示
              tds.push((
                <td nowrap="true" align="center" bgcolor={strBgColor}>&nbsp;</td>
              ));
              tds.push((
                <td nowrap="true" align="right" bgcolor={strBgColor}>***</td>
              ));
            }
          }

          // 単位（標準範囲）
          // 文章タイプの基準値を表示する
          if (lngResultType === 4) {
            if (!strUpperValue || strUpperValue === '') {
              tds.push((
                <td nowrap="true" align="center">{strUnit}</td>
              ));
            } else {
              tds.push((
                <td nowrap="true" align="center">{strUnit}　{strUpperValue}</td>
              ));
            }
          } else if (!strLowerValue || strLowerValue === '' || !strUpperValue || strUpperValue === '') {
            tds.push((
              <td nowrap="true" align="center">{strUnit}</td>
            ));
          } else {
            lngStdValueFlg = 0;
            if (strLowerValue && !Number.isNaN(parseFloat(strLowerValue))
              && strUpperValue && !Number.isNaN(parseFloat(strUpperValue))
              && strMinValue && !Number.isNaN(parseFloat(strMinValue))
              && strMaxValue && !Number.isNaN(parseFloat(strMaxValue))) {
              if (parseFloat(strLowerValue) <= parseFloat(strMinValue)
                && parseFloat(strMaxValue) <= parseFloat(strUpperValue)) {
                // 最小値～最大値より基準値の範囲の方が広い場合は基準値表示なし
                lngStdValueFlg = -1;
              } else {
                if (parseFloat(strLowerValue) <= parseFloat(strMinValue)) {
                  // 以下表示
                  lngStdValueFlg = 1;
                }
                if (parseFloat(strMaxValue) <= parseFloat(strUpperValue)) {
                  // 以上表示
                  lngStdValueFlg = 2;
                }
              }
            } else {
              // 判断ができないときは、基準値をそのまま表示
              lngStdValueFlg = 0;
            }
            switch (lngStdValueFlg) {
              // 基準値は「最低～最高」表示
              case 0: tds.push((<td nowrap="true" align="center">{strUnit}　（{strLowerValue}～{strUpperValue}）</td>)); break;
              // 基準値は「最高以下」表示
              case 1: tds.push((<td nowrap="true" align="center">（{strUpperValue}　以下）</td>)); break;
              // 基準値は「最低以上」表示
              case 2: tds.push((<td nowrap="true" align="center">（{strLowerValue}　以上）</td>)); break;
              // 基準値は表示なし
              default: tds.push((<td nowrap="true" align="center">{strUnit}</td>)); break;
            }
          }

          // 非表示チェックがONで、検査項目テーブルの面接支援非表示フラグが"1"かつ値がない場合は非表示
          if (lngHideFlg === '1' && strHideInterview === 1
            && (!blnIsValue[0] && !blnIsValue[1] && blnIsValue[2])) {
            // 非表示
          } else {
            trs.push((
              <tr bgcolor="#ffffff">
                {tds}
              </tr>
            ));
          }

          // リセット
          if (i < lngRslCnt) {
            ArrIndex = [-1, -1, -1];

            strClassName = historyRslData1[i].classname;
            strItemCd = historyRslData1[i].itemcd;
            strSuffix = historyRslData1[i].suffix;
            strItemName = historyRslData1[i].itemname;
            strCUTargetFlg = historyRslData1[i].cutargetflg;
            strUnit = !historyRslData1[i] || !historyRslData1[i].unit ? '' : historyRslData1[i].unit;
            strLowerValue = !historyRslData1[i] || !historyRslData1[i].lowervalue ? '' : historyRslData1[i].lowervalue;
            strUpperValue = !historyRslData1[i] || !historyRslData1[i].uppervalue ? '' : historyRslData1[i].uppervalue;
            strMinValue = !historyRslData1[i] || !historyRslData1[i].minvalue ? '' : historyRslData1[i].minvalue;
            strMaxValue = !historyRslData1[i] || !historyRslData1[i].maxvalue ? '' : historyRslData1[i].maxvalue;
            strHideInterview = historyRslData1[i].hideinterview;
          }
        }
        if (i < lngRslCnt) {
          lngResultType = historyRslData1[i].resulttype;
          ArrIndex[historyRslData1[i].hisno - 1] = i;
        }
      }

      const headDiv = (
        <tr align="center" bgcolor="#cccccc">
          <th nowrap="true" width="130px">検査分類</th>
          {lngEntryMode === 0 && <th nowrap="true" width="18px">CU</th>}
          <th nowrap="true" width="160px">検査項目</th>
          <th nowrap="true" />
          <th nowrap="true" width="90px">今回</th>
          <th nowrap="true" />
          <th nowrap="true" width="90px">前回</th>
          <th nowrap="true" />
          <th nowrap="true" width="90px">前々回</th>
          <th nowrap="true" width="343px">単位（標準範囲）</th>
        </tr>);
      table = (
        <Table style={{ padding: '0' }} border="0" cellSpacing="0" cellPadding="0" width="921px" className="mensetsu-tb">
          <thead>
            {headDiv}
          </thead>
          <tbody>
            {trs}
          </tbody>
        </Table>
      );
    } else if (tabletype === '2') {
      if (hisCount < 1) return null;
      if (!historyRslData3 || historyRslData3.length <= 0) return null;
      const lngRslCnt = historyRslData3 ? historyRslData3.length : -1;

      // 検査分類名称
      let strClassName3;
      // 検査分類名称(上の行）
      let strClassName13;
      // ワーク
      let strWork;
      // 更新可能フラグ
      let strUpdFlg3;
      // 値フラグ（True:有効値、False:無効値）
      let blnIsValue3;
      // 背景色
      let strBgColor3;

      strClassName13 = '';

      const trs = [];
      const updateflg = [];
      for (let i = 0; i < lngRslCnt; i += 1) {
        const tds = [];
        // 結果タイプにより表示項目を判断する
        if (historyRslData3[i].resulttype === 3
          || historyRslData3[i].resulttype === 4
          || historyRslData3[i].resulttype === 7) {
          blnIsValue3 = false;
          switch (historyRslData3[i].hisno) {
            // 今回
            case 1: strBgColor3 = '#eeeeee'; break;
            // 前回
            case 2: strBgColor3 = '#90f0aa'; break;
            // 前々回
            case 3: strBgColor3 = '#ffffcc'; break;
            default: strBgColor3 = '#ffffff'; break;
          }

          // 検査分類
          strClassName3 = historyRslData3[i].classname;
          if (strClassName13 !== strClassName3) {
            strClassName13 = strClassName3;
            tds.push((
              <td nowrap="true" align="center" bgcolor={strBgColor3}>{strClassName13}</td>
            ));
          } else {
            tds.push((
              <td nowrap="true" align="center" bgcolor={strBgColor3}>&nbsp;</td>
            ));
          }

          // 検査項目
          if (!historyRslData3[i].itemname || historyRslData3[i].itemname === '') {
            tds.push((
              <td nowrap="true" align="center" bgcolor={strBgColor3}>&nbsp;</td>
            ));
          } else {
            tds.push((
              <td nowrap="true" align="center" bgcolor={strBgColor3}><span id={`itemname${i}`}>{historyRslData3[i].itemname}</span></td>
            ));
          }

          // 所見
          strUpdFlg3 = -1;
          if (historyRslData3[i].rslflg === 0) {
            // 検査項目が存在しなかったら"***"表示
            tds.push((
              <td nowrap="true" colSpan="3" align="left" bgcolor={strBgColor3}>***</td>
            ));
          } else {
            if (!historyRslData3[i].result || historyRslData3[i].result === '') {
              strWork = <span>&nbsp;</span>;
            } else {
              blnIsValue3 = true;
              strWork = historyRslData3[i].result;
            }
            if (lngEntryMode === 0) {
              tds.push((
                <td nowrap="true" align="left" bgcolor={strBgColor3}>{strWork}</td>
              ));
            } else if (historyRslData3[i].rsvno === consultHistoryData[0].rsvno) {
              // 更新モードで今回分は所見の修正が可能
              strUpdFlg3 = 0;
              // メモタイプのときは別ガイドを表示する
              if (historyRslData3[i].resulttype === 7) {
                tds.push((
                  <td width="20px" nowrap="true" bgcolor={strBgColor3}><a href={`JavaScript:callMemo(${i})`}><span title="メモ入力ガイドを表示します">{iconquestion}</span></a></td>
                ));
              } else {
                tds.push((
                  <td width="20px" nowrap="true" bgcolor={strBgColor3}><a href={`JavaScript:callSentence(${i})`}><span title="所見選択ガイドを表示します">{iconquestion}</span></a></td>
                ));
              }
              tds.push((
                <td width="20px" nowrap="true" bgcolor={strBgColor3}>
                  <a role="presentation" onClick={() => this.clearSentenceInfo(i)} style={{ cursor: 'pointer' }}><span title="所見を削除します">{icondelete}</span></a>
                </td>
              ));
              tds.push((
                <td nowrap="true" align="left" bgcolor={strBgColor3}><span id={`sentence${i}`}>{strWork}</span></td>
              ));
            } else {
              tds.push((
                <td nowrap="true" colSpan="3" align="left" bgcolor={strBgColor3}>{strWork}</td>
              ));
            }
          }

          // 非表示チェックがONで、検査項目テーブルの面接支援非表示フラグが"1"かつ値がない場合は非表示
          if (lngHideFlg === '1' && historyRslData3[i].hideinterview === 1 && blnIsValue3 === false) {
            // 非表示
          } else {
            updateflg.push(strUpdFlg3);
            trs.push((
              <tr bgcolor={strBgColor3}>
                {tds}
              </tr>
            ));
          }
        }
      }

      const headDiv = (
        <tr align="center" bgcolor="#cccccc">
          <th nowrap="true" width="130px">検査分類</th>
          <th nowrap="true" width="160px">検査項目</th>
          {lngEntryMode === 0 ? <th nowrap="true" width="610px">所見</th> : <th nowrap="true" colSpan="3" width="610px">所見</th>}
        </tr>
      );
      table = (
        <Table style={{ padding: '0' }} border="0" cellSpacing="0" cellPadding="0" width="900px" className="mensetsu-tb">
          <thead>
            {headDiv}
          </thead>
          <tbody>
            {trs}
          </tbody>
        </Table>
      );
    }
    const height = (menResultTypeNo === constants.INTERVIEWRESULT_TYPE2) ? 280 : 500;
    return (
      <Wrapper style={{ overflowX: 'hidden', overflowY: 'auto', maxHeight: `${height}px`, float: 'left', marginTop: '10px', marginBottom: '10px' }}>
        { message && <MessageBanner messages={message} /> }
        {table}
      </Wrapper>
    );
  }
}

// propTypesの定義
EditMenResultTable.propTypes = {
  menResultTypeNo: PropTypes.number.isRequired,
  hisCount: PropTypes.number.isRequired,
  tabletype: PropTypes.string.isRequired,
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData1: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData3: PropTypes.arrayOf(PropTypes.shape()),
  hideflg: PropTypes.string,
  entrymode: PropTypes.number,
  setValue: PropTypes.func.isRequired,
  message: PropTypes.arrayOf(PropTypes.string),
};

// defaultPropsの定義
EditMenResultTable.defaultProps = {
  consultHistoryData: [],
  historyRslData1: [],
  historyRslData3: [],
  hideflg: '',
  entrymode: undefined,
  message: [],
};

export default EditMenResultTable;

function getMenResultGrpInfo(strGrpNo) {
  // グループ情報取得
  let lngMenResultTypeNo = 0;
  let strMenResultTitle = '？？？';
  let strMenResultGrpCd1 = '';
  let strMenResultGrpCd3 = '';
  let strRayPaxOrdDiv = '';
  let strRayPaxOrdDiv2 = '';
  let strRayPaxOrdDiv3 = '';
  switch (strGrpNo) {
    case 1:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '診察・体格・血圧・肺機能';
      strMenResultGrpCd3 = 'X001';
      strMenResultGrpCd1 = 'X002';
      break;
    case 2:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE3;
      strMenResultTitle = '心電図';
      strMenResultGrpCd3 = 'X003';
      strRayPaxOrdDiv = 'ORDDIV000006';
      break;
    case 3:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE3;
      strMenResultTitle = '胸部Ｘ線';
      strMenResultGrpCd3 = 'X004';
      strRayPaxOrdDiv = 'ORDDIV000009';
      break;
    case 4:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '上部消化管・便潜血';
      strMenResultGrpCd3 = 'X005';
      strMenResultGrpCd1 = 'X006';
      strRayPaxOrdDiv = 'ORDDIV000011';
      strRayPaxOrdDiv2 = 'ORDDIV000014';
      break;
    case 5:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE3;
      strMenResultTitle = '上腹部超音波';
      strMenResultGrpCd3 = 'X007';
      strRayPaxOrdDiv = 'ORDDIV000007';
      break;
    case 6:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '血液';
      strMenResultGrpCd1 = 'X008';
      break;
    case 7:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '糖代謝・脂質代謝';
      strMenResultGrpCd1 = 'X009';
      break;
    case 8:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '尿酸・肝機能・腎機能';
      strMenResultGrpCd1 = 'X010';
      break;
    case 9:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '電解質・血清・尿検査・前立腺';
      strMenResultGrpCd1 = 'X011';
      break;
    case 10:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '視力・眼底・聴力・骨密度';
      strMenResultGrpCd3 = 'X012';
      strMenResultGrpCd1 = 'X013';
      strRayPaxOrdDiv = 'ORDDIV000013';
      break;
    case 11:
      // menResultTypeNo = 3;
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '乳房・婦人科・婦人科超音波';
      strMenResultGrpCd3 = 'X119';
      strMenResultGrpCd1 = 'X118';
      strRayPaxOrdDiv = 'ORDDIV000008';
      strRayPaxOrdDiv2 = 'ORDDIV000012';
      strRayPaxOrdDiv3 = 'ORDDIV000020';
      break;
    case 12:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE3;
      strMenResultTitle = '大腸内視鏡';
      strMenResultGrpCd3 = 'X015';
      strRayPaxOrdDiv = 'ORDDIV000015';
      break;
    case 13:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = 'ヘリカルＣＴ／喀痰／ＣＴ肺気腫';
      strMenResultGrpCd3 = 'X016';
      strMenResultGrpCd1 = 'X679';
      strRayPaxOrdDiv = 'ORDDIV000010';
      break;
    case 14:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '後日検査';
      strMenResultGrpCd1 = 'X053';
      break;
    case 15:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '大腸３Ｄ－ＣＴ';
      strMenResultGrpCd3 = 'X100';
      strMenResultGrpCd1 = 'X101';
      strRayPaxOrdDiv = 'ORDDIV000016';
      break;
    case 16:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '頸動脈超音波';
      strMenResultGrpCd3 = 'X102';
      strMenResultGrpCd1 = 'X103';
      strRayPaxOrdDiv = 'ORDDIV000018';
      break;
    case 17:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '動脈硬化';
      strMenResultGrpCd3 = 'X104';
      strMenResultGrpCd1 = 'X105';
      strRayPaxOrdDiv = 'ORDDIV000019';
      break;
    case 18:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '内臓脂肪面積';
      strMenResultGrpCd1 = 'X106';
      strRayPaxOrdDiv = 'ORDDIV000017';
      break;
    case 19:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE1;
      strMenResultTitle = '心不全スクリーニング';
      strMenResultGrpCd1 = 'X108';
      break;
    case 20:
      lngMenResultTypeNo = constants.INTERVIEWRESULT_TYPE2;
      strMenResultTitle = '婦人科超音波';
      strMenResultGrpCd3 = 'X117';
      strMenResultGrpCd1 = 'X118';
      strRayPaxOrdDiv = 'ORDDIV000020';
      break;
    default: break;
  }

  return {
    lngMenResultTypeNo,
    strMenResultTitle,
    strMenResultGrpCd1,
    strMenResultGrpCd3,
    strRayPaxOrdDiv,
    strRayPaxOrdDiv2,
    strRayPaxOrdDiv3,
  };
}

export { getMenResultGrpInfo };
