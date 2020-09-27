import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';

import Table from '../../components/Table';

const UpdClassName = (rec) => {
  let updClassName;
  switch (rec.updclass) {
    case 1:
      updClassName = 'フォローアップ情報';
      break;
    case 2:
      updClassName = '二次検査結果';
      break;
    default:
      updClassName = 'その他';
      break;
  }
  return updClassName;
};

const UpdDivName = (rec) => {
  let updDivName;
  switch (rec.upddiv) {
    case 'I':
      updDivName = '挿入';
      break;
    case 'U':
      updDivName = '更新';
      break;
    case 'D':
      updDivName = '削除';
      break;
    default:
      break;
  }
  return updDivName;
};

const FolUpdateHistoryBody = ({ data }) => (
  <Table>
    <thead>
      <tr style={{ backgroundColor: '#cccccc' }}>
        <th>更新日時</th>
        <th>更新者</th>
        <th>分類</th>
        <th>判定分類コース</th>
        <th>処理</th>
        <th style={{ width: 80 }}>変更項目</th>
        <th style={{ width: 80 }}>部位</th>
        <th style={{ width: 200 }}>更新前</th>
        <th style={{ width: 200 }}>更新後</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec, index) => (
        <tr key={[`${index}`]}>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{moment(rec.upddate).format('YYYY/MM/DD HH:mm:ss A')}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{rec.updusername}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{UpdClassName(rec)}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{rec.judclassname}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{UpdDivName(rec)}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{rec.itemname}</td>
          <td style={{ whiteSpace: 'pre', backgroundColor: '#eeeeee' }}>{rec.itemcdname}</td>
          <td style={{ backgroundColor: '#eeeeee' }}>{rec.before}</td>
          <td style={{ backgroundColor: '#eeeeee' }}>{rec.after}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
FolUpdateHistoryBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default FolUpdateHistoryBody;

