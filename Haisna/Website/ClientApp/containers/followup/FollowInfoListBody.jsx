import React from 'react';
import moment from 'moment';
import { Link } from 'react-router-dom';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';

import Radio from '../../components/control/Radio';
import Table from '../../components/Table';

const webJudCd = (rec) => {
  let res;
  if (rec.judCd !== null && rec.judCd !== rec.rslJudCd) {
    res = <td style={{ backgroundColor: '#FFC0CB', whiteSpace: 'pre', textAlign: 'center' }}>{rec.webJudCd}</td>;
  } else {
    res = <td style={{ whiteSpace: 'pre', textAlign: 'center' }}>{rec.webJudCd}</td>;
  }
  return res;
};

const webRslJudCd = (rec) => {
  let res;
  if (rec.judCd !== null && rec.judCd !== rec.rslJudCd) {
    res = <td style={{ backgroundColor: '#FFC0CB', whiteSpace: 'pre', textAlign: 'center' }}>{rec.webRslJudCd}</td>;
  } else {
    res = <td style={{ whiteSpace: 'pre', textAlign: 'center' }}>{rec.webRslJudCd}</td>;
  }
  return res;
};

const follow = (rec) => {
  const res = [];
  let equipStat = '';
  let webEquipDivName = '';
  let webStatusName = '';
  let checkedValue;
  let key = 0;
  if (rec.equipDiv === null) {
    for (let i = 0; i < 5; i += 1) {
      switch (i) {
        case 0:
          equipStat = '対象外';
          checkedValue = 9;
          break;
        case 1:
          equipStat = '二次検査場所未定';
          checkedValue = 0;
          break;
        case 2:
          equipStat = '当センター ';
          checkedValue = 1;
          break;
        case 3:
          equipStat = '本院・メディローカス ';
          checkedValue = 2;
          break;
        case 4:
          equipStat = '他院';
          checkedValue = 3;
          break;
        default:
          break;
      }
      res.push(<Field key={`equipDiv_${key}`} name={`equipDiv${rec.key}`} component={Radio} checkedValue={checkedValue} label={equipStat} />);
      if (i === 0 || i === 1) {
        res.push(<br key={`br_${key}`} />);
      }
      key += 1;
    }
  } else {
    switch (rec.equipDiv) {
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
    if (rec.equipDiv === 9) {
      res.push(<strong key={`equipDivName_${key}`}><span style={{ color: '#666666' }}>{webEquipDivName}</span></strong>);
    } else {
      res.push(<strong key={`equipDivName_${key}`}><span>{webEquipDivName}</span></strong>);
    }
    if (rec.statusCd !== null) {
      switch (rec.statusCd) {
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
      if (webStatusName === '') {
        res.push(<span key={`statusName_${key}`} />);
      } else {
        res.push(<span key={`statusName_${key}`}>{`(${webStatusName})`}</span>);
      }
    }
    if (rec.prtSeq !== null) {
      res.push(<br key={`br1_${key}`} />);
      res.push(<Link key={`link_${key}`} to={`/contents/follow/prtPreview/${rec.webFileName}/`}>依頼状({rec.prtSeq}版)：{rec.webPrtUser}&nbsp;{rec.webPrtDate}</Link>);
    }
    if (rec.reqConfirmDate !== null) {
      res.push(<br key={`br2_${key}`} />);
      res.push(`結果承認済(${rec.reqConfirmUser})`);
    }
    key += 1;
  }
  return res;
};

const addUser = (rec) => {
  let res;
  if (rec.addUser === null) {
    res = <td style={{ textAlign: 'center', whiteSpace: 'pre' }}>{rec.webAddUser}</td>;
  } else {
    res = <td style={{ whiteSpace: 'pre' }}>{rec.webAddUser}</td>;
  }
  return res;
};

const docJud = (rec) => {
  let res;
  if (rec.docJud === '-') {
    res = <td style={{ textAlign: 'center' }}>{rec.webDocJud}</td>;
  } else {
    res = <td>{rec.webDocJud}</td>;
  }
  return res;
};

const docGf = (rec) => {
  let res;
  if (rec.docGf === '-') {
    res = <td style={{ textAlign: 'center' }}>{rec.webDocGf}</td>;
  } else {
    res = <td>{rec.webDocGf}</td>;
  }
  return res;
};

const docCf = (rec) => {
  let res;
  if (rec.docCf === '-') {
    res = <td style={{ textAlign: 'center' }}>{rec.webDocCf}</td>;
  } else {
    res = <td>{rec.webDocCf}</td>;
  }
  return res;
};

const docGyne = (rec) => {
  let res;
  if (rec.docGyne === '-') {
    res = <td style={{ textAlign: 'center' }}>{rec.webDocGyne}</td>;
  } else {
    res = <td>{rec.webDocGyne}</td>;
  }
  return res;
};

const docGyneJud = (rec) => {
  let res;
  if (rec.docGyneJud === '-') {
    res = <td style={{ textAlign: 'center' }}>{rec.webDocGyneJud}</td>;
  } else {
    res = <td>{rec.webDocGyneJud}</td>;
  }
  return res;
};

const manipulate = (rec, onOpenFollowReqEditGuide, onOpenFollowInfoEditGuide) => {
  const res = [];
  let key = 0;
  res.push(<span key={`jud_${key}`}><Link to={`/contents/interview/interviewTop/${rec.webRsvNo}/`}>面接&nbsp;</Link></span>);
  if (rec.equipDiv === 3 || rec.equipDiv === 0 || (rec.equipDiv === 2 && rec.judClassCd === 31)) {
    res.push(<a key={`print_${key}`} href="#" onClick={() => { onOpenFollowReqEditGuide(rec.webRsvNo, rec.judClassCd); }} style={{ color: '#0000ff' }}>依頼&nbsp;</a>);
  } else {
    res.push(<span key={`print_${key}`}>&nbsp;</span>);
  }
  if (rec.equipDiv !== null) {
    res.push(<a key={`result_${key}`} href="#" onClick={() => { onOpenFollowInfoEditGuide(rec.webRsvNo, rec.judClassCd); }} style={{ color: '#0000ff' }}>結果</a>);
  } else {
    res.push(<span key={`result_${key}`}>&nbsp;</span>);
  }
  key += 1;
  return res;
};

const FollowInfoListBody = ({ data, onOpenFollowInfoGuide, onOpenMenResultGuide, onOpenFollowReqEditGuide, onOpenFollowInfoEditGuide }) => (
  <Table>
    <thead>
      <tr>
        <th style={{ textAlign: 'center' }} rowSpan="2">受診日</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">当日ＩＤ</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">個人ＩＤ</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">受診者名</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">性</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">年齢</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">生年月日</th>
        <th style={{ textAlign: 'center' }} rowSpan="2" >検査項目<br />（判定分類）</th>
        <th style={{ textAlign: 'center' }} colSpan="2">判定</th>
        <th style={{ textAlign: 'center', width: 200 }} rowSpan="2">フォロー</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">登録者</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">判定医</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">内視鏡医<br />(上部)</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">内視鏡医<br />(下部)</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">婦人科診察医</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">婦人科判定医</th>
        <th style={{ textAlign: 'center' }} rowSpan="2">操作</th>
      </tr>
      <tr>
        <th style={{ textAlign: 'center' }}>フォロー</th>
        <th style={{ textAlign: 'center' }}>現在判定</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec) => (
        <tr key={rec.key}>
          <td style={{ whiteSpace: 'pre' }}>{rec.webCslDate && moment(rec.webCslDate).format('M/D/YYYY')}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.webDayId}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.webPerId}</td>
          <td style={{ whiteSpace: 'pre' }}>
            <a
              href="#"
              onClick={() => { onOpenFollowInfoGuide(rec.webRsvNo); }}
              style={{ color: '#0000ff' }}
            >
              <span style={{ fontSize: '8pt' }}>{rec.webPerKName}</span><br />
              {rec.webPerName}
            </a>
          </td>
          <td style={{ whiteSpace: 'pre' }}>{rec.webGender}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.webAge}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.webBirth}</td>
          <td style={{ whiteSpace: 'pre' }}>
            <a
              href="#"
              onClick={() => { onOpenMenResultGuide(rec.webRsvNo, rec.webCsCd, rec.webResultDispMode); }}
              style={{ color: '#0000ff' }}
            >
              {rec.webJudClassName}
            </a>
          </td>
          {webJudCd(rec)}
          {webRslJudCd(rec)}
          <td style={{ whiteSpace: 'pre' }}>{follow(rec)}</td>
          {addUser(rec)}
          {docJud(rec)}
          {docGf(rec)}
          {docCf(rec)}
          {docGyne(rec)}
          {docGyneJud(rec)}
          <td style={{ whiteSpace: 'pre' }}>{manipulate(rec, onOpenFollowReqEditGuide, onOpenFollowInfoEditGuide)}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
FollowInfoListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenFollowInfoGuide: PropTypes.func.isRequired,
  onOpenMenResultGuide: PropTypes.func.isRequired,
  onOpenFollowReqEditGuide: PropTypes.func.isRequired,
  onOpenFollowInfoEditGuide: PropTypes.func.isRequired,
};

export default FollowInfoListBody;
