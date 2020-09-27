import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const ConsultListGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>対象予約番号</th>
        <th>受診コース</th>
        <th>個人氏名</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.rsvno}`} onClick={() => onSelectRow(rec.rsvno)}>
          <td>{rec.rsvno}</td>
          <td>{rec.csname}</td>
          <td>{rec.lastname}{rec.firstname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
ConsultListGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default ConsultListGuideList;
