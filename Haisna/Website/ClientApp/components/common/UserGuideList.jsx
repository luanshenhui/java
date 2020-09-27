import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const UserGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>ユーザ名</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.userid}`} onClick={() => onSelectRow(rec.userid)}>
          <td>{rec.userid}</td>
          <td>{rec.username}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
UserGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default UserGuideList;
