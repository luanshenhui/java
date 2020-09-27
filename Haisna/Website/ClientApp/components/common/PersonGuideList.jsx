import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const PersonGuideList = ({ data, onSelectRow }) => (
  <Table>
    <thead>
      <tr>
        <th>個人ID</th>
        <th>氏名</th>
        <th>ローマ字</th>
        <th>生年月日</th>
        <th>性別</th>
        <th>年齢</th>
        <th>電話番号</th>
        <th>住所</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.perid}`} onClick={() => onSelectRow(rec.perid)}>
          <td>{rec.perid}</td>
          <td>{rec.lastname} {rec.firstname}</td>
          <td>{rec.romename}</td>
          <td>{rec.birth}</td>
          <td>{rec.gender}</td>
          <td>{rec.age}</td>
          <td>{rec.tel}</td>
          <td>{rec.prefname}{rec.cityname}{rec.address1}{rec.address2}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
PersonGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default PersonGuideList;
