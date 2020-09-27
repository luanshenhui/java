import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const SecondLineDivGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>名称</th>
        <th>金額</th>
        <th>税額</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.secondlinedivcd}`} onClick={() => onSelectRow(rec.secondlinedivcd)}>
          <td>{rec.secondlinedivcd}</td>
          <td>{rec.secondlinedivname}</td>
          <td>&yen;{rec.stdprice.toLocaleString()}</td>
          <td>&yen;{rec.stdtax}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
SecondLineDivGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default SecondLineDivGuideList;
