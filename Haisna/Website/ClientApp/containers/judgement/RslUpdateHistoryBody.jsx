import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import styled from 'styled-components';

import Table from '../../components/Table';

const Wrapper = styled.div`
  white-space: nowrap;
`;

// 更新分類名称セット
const updClass = (data) => {
  const resUpdClass = [];
  let updClassName = '';
  switch (data.updclass) {
    case 1:
      updClassName = '検診結果';
      break;
    case 2:
      updClassName = '判定';
      break;
    case 3:
      updClassName = 'コメント';
      break;
    case 4:
      updClassName = '個人検査結果';
      break;
    default:
      updClassName = 'その他';
      break;
  }
  resUpdClass.push(updClassName);
  return resUpdClass;
};

// 項目名称セット
const updItem = (data) => {
  const resUpdItem = [];
  let updItemName = '';
  switch (data.updclass) {
    case 2:
      updItemName = data.judclassname;
      break;
    case 3:
      updItemName = data.itemname === null ? data.judclassname : data.itemname;
      break;
    default:
      updItemName = data.itemname;
      break;
  }
  resUpdItem.push(updItemName);
  return resUpdItem;
};

// 処理区分名称セット
const updDiv = (data) => {
  const resUpdDiv = [];
  let updDivName = '';
  switch (data.upddiv) {
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
  resUpdDiv.push(updDivName);
  return resUpdDiv;
};
const RslUpdateHistoryBody = ({ data }) => (
  <Table striped hover style={{ height: '360px', width: '1100px' }}>
    <thead>
      <tr bgcolor="#cccccc">
        <th width="120">更新日時</th>
        <th width="90">更新者</th>
        <th width="60">分類</th>
        <th width="120">項目名称</th>
        <th width="40">処理</th>
        <th width="228">更新前</th>
        <th width="244">更新後</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec, index) => (
        <tr valign="top" style={{ backgroundColor: '#eeeeee' }} key={index.toString()}>
          <td><Wrapper>{moment(rec.upddate).format('YYYY/MM/DD HH:mm:ss')}</Wrapper></td>
          <td><Wrapper>{rec.updusername}</Wrapper></td>
          <td><Wrapper>{updClass(rec)}</Wrapper></td>
          <td><Wrapper>{updItem(rec)}</Wrapper></td>
          <td><Wrapper>{updDiv(rec)}</Wrapper></td>
          <td width="228">{rec.beforeresult}</td>
          <td width="244">{rec.afterresult}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);
// propTypesの定義
RslUpdateHistoryBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default RslUpdateHistoryBody;
