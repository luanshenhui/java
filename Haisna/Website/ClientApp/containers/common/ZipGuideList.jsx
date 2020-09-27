import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import Table from '../../components/Table';

const ZipGuideList = ({ data, onSelectRow }) => (
  <Table striped bordered condensed hover>
    <thead>
      <tr>
        <th>郵便番号</th>
        <th>住所</th>
        <th>住所カナ</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.zipcd1}-${rec.zipcd2}`} onClick={() => onSelectRow(rec)}>
          <td>{rec.zipcd1}-{rec.zipcd2}</td>
          <td>{rec.prefname}　{rec.cityname}　{rec.section}</td>
          <td>{rec.citykname}　{rec.sectionkname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
ZipGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default ZipGuideList;
