import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const RslCmtGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>結果コメント</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.rslcmtcd}`} onClick={() => onSelectRow(rec.rslcmtcd)}>
          <td>{rec.rslcmtcd}</td>
          <td>{rec.rslcmtname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
RslCmtGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default RslCmtGuideList;
