import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';

import Table from '../../components/Table';

const prtDiv = (rec) => {
  let prtDivRet;
  if (rec.prtdiv !== 0) {
    switch (rec.prtdiv) {
      case 1:
        prtDivRet = <td style={{ whiteSpace: 'pre' }}>依頼状&nbsp;_&nbsp;{rec.seq}版  </td>;
        break;
      case 2:
        prtDivRet = <td style={{ whiteSpace: 'pre' }}>勧奨&nbsp;_&nbsp;{rec.seq}版  </td>;
        break;
      default:
        break;
    }
  } else {
    prtDivRet = <td style={{ whiteSpace: 'pre' }}>&nbsp;</td>;
  }

  return prtDivRet;
};

const judCd = (rec) => {
  let judCdRet;
  if (rec.judcd === '') {
    judCdRet = <td style={{ whiteSpace: 'pre' }}>フォローアップ情報削除</td>;
  } else {
    judCdRet = <td style={{ whiteSpace: 'pre' }}>&nbsp;</td>;
  }
  return judCdRet;
};

const FollowReqHistoryBody = ({ data }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th style={{ width: 90 }}>検査項目名</th>
        <th style={{ width: 60 }}>判定</th>
        <th style={{ width: 90 }}>版数</th>
        <th style={{ width: 140 }}>作成日</th>
        <th style={{ width: 120 }}>作成者</th>
        <th style={{ width: 100 }}>印刷ファイル名</th>
        <th style={{ width: 140 }}>発送日</th>
        <th style={{ width: 120 }}>発送者</th>
        <th style={{ width: 140 }}>備考</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec, index) => (
        <tr key={[`${index}`]}>
          <td style={{ whiteSpace: 'pre' }}>{rec.judclassname}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.judcd}</td>
          {prtDiv(rec)}
          <td style={{ whiteSpace: 'pre' }}>{moment(rec.adddate).format('M/D/YYYY HH:mm:ss A')}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.username}</td>
          <td style={{ whiteSpace: 'pre' }}><Link to={`/contents/follow/prtPreview/${rec.filename}/`}>{rec.filename}</Link></td>
          <td style={{ whiteSpace: 'pre' }}>{rec.reqsenddate}</td>
          <td style={{ whiteSpace: 'pre' }}>{rec.reqsenduser}</td>
          {judCd(rec)}
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
FollowReqHistoryBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default FollowReqHistoryBody;

