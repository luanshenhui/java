import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const OrgGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>団体コード</th>
        <th>団体名称</th>
        <th>略称</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.orgcd1}-${rec.orgcd2}`} onClick={() => onSelectRow(rec.orgcd1, rec.orgcd2)}>
          <td>{rec.orgcd1}-{rec.orgcd2}</td>
          <td>{rec.orgname}</td>
          <td>{rec.orgsname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
OrgGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default OrgGuideList;
