/**
 * @file 受診者検索画面検索結果（gdeConsultList.asp）
 */
import React from 'react';
import PropTypes from 'prop-types';

import Table from '../Table';

const ConsultationListGuideList = ({ data, onSelectRow }) => (
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
        <tr key={`${rec.rsvno}`} onClick={() => onSelectRow(rec)}>
          <td>{rec.rsvno}</td>
          <td>{rec.csname}</td>
          <td>{rec.name}（{rec.kananame}）</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
ConsultationListGuideList.propTypes = {
  // 一覧データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // 行を選択した時の処理
  onSelectRow: PropTypes.func.isRequired,
};

export default ConsultationListGuideList;
