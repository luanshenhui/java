import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import styled from 'styled-components';
import { Field } from 'redux-form';
import { Link } from 'react-router-dom';
import Radio from '../../components/control/Radio';

const TdWrapper = styled.td`
  background-color: #ffc0cb;
`;
const Wrapperfont = styled.div`
  font-color: #666666;
`;

// フォロー情報
const FollowDetail = ({ data, index, handlePrintClick }) => {
  const resfollow = [];
  let webEquipDivName = '';
  let webStatusName = '';
  if (data && data.equipdiv === null) {
    resfollow.push(<Field component={Radio} name={`targetFollowData[${index}].secequipdiv`} label="対象外" checkedValue={9} key={`${0}-${index.toString()}`} />);
    resfollow.push(<div style={{ marginTop: 3 }} key={`${20}-${index.toString()}`} />);
    resfollow.push(<Field component={Radio} name={`targetFollowData[${index}].secequipdiv`} label="二次検査場所未定" checkedValue={0} key={`${1}-${index.toString()}`} />);
    resfollow.push(<div style={{ marginTop: 3 }} key={`${21}-${index.toString()}`} />);
    resfollow.push(<Field component={Radio} name={`targetFollowData[${index}].secequipdiv`} label="当センター" checkedValue={1} key={`${2}-${index.toString()}`} />);
    resfollow.push(<Field component={Radio} name={`targetFollowData[${index}].secequipdiv`} label="本院・メディローカス" checkedValue={2} key={`${3}-${index.toString()}`} />);
    resfollow.push(<Field component={Radio} name={`targetFollowData[${index}].secequipdiv`} label="他院" checkedValue={3} key={`${4}-${index.toString()}`} />);
  } else {
    switch (data && data.equipdiv) {
      case 0:
        webEquipDivName = '二次検査場所未定';
        break;
      case 1:
        webEquipDivName = '当センター';
        break;
      case 2:
        webEquipDivName = '本院・メディローカス';
        break;
      case 3:
        webEquipDivName = '他院';
        break;
      case 9:
        webEquipDivName = '対象外';
        break;
      default:
        break;
    }

    if (webEquipDivName === '対象外') {
      resfollow.push(<Wrapperfont key={`${5}-${index.toString()}`} ><b>{webEquipDivName}</b></Wrapperfont>);
    } else {
      resfollow.push(<b key={`${6}-${index.toString()}`} >{webEquipDivName}</b>);
    }

    if (data && data.statuscd !== null) {
      switch (data.statuscd) {
        case 11:
          webStatusName = '診断確定：異常なし';
          break;
        case 12:
          webStatusName = '診断確定：異常あり';
          break;
        case 21:
          webStatusName = '診断未確定(受診施設)：センター';
          break;
        case 22:
          webStatusName = '診断未確定(受診施設)：本院・メディローカス';
          break;
        case 23:
          webStatusName = '診断未確定(受診施設)：他院';
          break;
        case 29:
          webStatusName = '診断未確定(受診施設)：その他（未定・不明）';
          break;
        case 99:
          webStatusName = 'その他(フォローアップ登録終了)';
          break;
        default:
          break;
      }
      resfollow.push(<span key={`${7}-${index.toString()}`} >(</span>);
      resfollow.push(webStatusName);
      resfollow.push(<span key={`${8}-${index.toString()}`} >)</span>);
    }

    if (data && data.prtseq !== null) {
      resfollow.push(<div style={{ marginTop: 3 }} key={`${22}-${index.toString()}`} />);
      resfollow.push(<span key={`P_${9}`} ><a role="presentation" onClick={() => handlePrintClick(data.rsvno, data.judclasscd)}>依頼状({data.prtseq}版)：{data.prtuser} &nbsp; {data.prtdate}</a></span>);
    }
    if (data && data.reqconfirmdate !== null) {
      resfollow.push(<div style={{ marginTop: 3 }} key={`${23}-${index.toString()}`} />);
      resfollow.push(<span key={`${24}-${index.toString()}`} >結果承認済</span>);
      resfollow.push(<span key={`${25}-${index.toString()}`} >&nbsp;(</span>);
      resfollow.push(data.reqconfirmuser);
      resfollow.push(<span key={`${26}-${index.toString()}`} >)</span>);
    }
  }
  return resfollow;
};

// 操作情報
const OperationDetail = ({ data, winmode, index, handleResultClick, handleRequestClick }) => {
  const resoperation = [];
  // 「別ウィンドウで表示」の場合、面接支援画面参照できるようにする
  if (winmode === '1') {
    resoperation.push(<td width="90" key={`${0}-${index.toString()}`}><Link to={`/contents/judgement/interview/top/${data.rsvno}/totaljudview/0/0`}>面接支援&nbsp;</Link></td>);
  }
  if (data.equipdiv === 3 || data.equipdiv === 0) {
    resoperation.push(<td width="90" key={`${1}-${index.toString()}`}><a role="presentation" onClick={() => handleRequestClick(data.rsvno, data.judclasscd)}>依頼状作成</a></td>);
  } else {
    resoperation.push(<td key={`${2}-${index.toString()}`} />);
  }
  if (data.equipdiv !== null) {
    resoperation.push(<td width="90" key={`${3}-${index.toString()}`}><a role="presentation" onClick={() => handleResultClick(data.rsvno, data.judclasscd)}>結果入力</a></td>);
  } else {
    resoperation.push(<td key={`${4}-${index.toString()}`} />);
  }
  return resoperation;
};

// 婦人科診察フォローアップ情報
const FollowInfoBodyItem = ({ item, index, winmode, handleResultClick, handleRequestClick, handlePrintClick }) => (
  <tr>
    <td>{moment(item.csldate).format('YYYY/MM/DD')}</td>
    { /* TODO 検査結果画面呼び出し */ }
    <td><a href="#">{item.judclassname}</a></td>
    {(item.judcd !== null && item.judcd !== item.rsljudcd)
      ? <TdWrapper>{item.judcd}</TdWrapper>
      : <td>{item.judcd}</td>}
    {(item.judcd !== null && item.judcd !== item.rsljudcd)
      ? <TdWrapper>{item.rsljudcd}</TdWrapper>
      : <td>{item.rsljudcd}</td>}
    {/* フォロー */}
    <td><FollowDetail data={item} index={index} handlePrintClick={handlePrintClick} /></td>
    <td>{item.adduser}</td>
    <td>{item.upduser}</td>
    <td>{item.doc_jud}</td>
    <td>{item.doc_gf}</td>
    <td>{item.doc_cf}</td>
    <td>{item.doc_gyne}</td>
    <td>{item.doc_gynejud}</td>
    {/* 操作 */}
    <OperationDetail data={item} winmode={winmode} index={index} handleResultClick={handleResultClick} handleRequestClick={handleRequestClick} />
  </tr>
);

// propTypesの定義
FollowInfoBodyItem.propTypes = {
  item: PropTypes.shape(),
  index: PropTypes.number.isRequired,
  winmode: PropTypes.string,
  // 結果入力
  handleResultClick: PropTypes.func.isRequired,
  // 依頼状作成
  handleRequestClick: PropTypes.func.isRequired,
  // 依頼状印刷
  handlePrintClick: PropTypes.func.isRequired,
};

FollowInfoBodyItem.defaultProps = {
  item: {},
  winmode: undefined,
};

export default FollowInfoBodyItem;
