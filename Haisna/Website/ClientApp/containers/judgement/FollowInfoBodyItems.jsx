import React from 'react';
import PropTypes from 'prop-types';
import FollowInfoBodyItem from './FollowInfoBodyItem';
import Table from '../../components/Table';

// 婦人科診察フォローアップ情報
const FollowInfoBodyItems = (props) => (
  <Table striped hover>
    <thead>
      <tr>
        <th rowSpan="2">受診日</th>
        <th rowSpan="2">検査項目<br />（判定分類）</th>
        <th colSpan="2">判定</th>
        <th rowSpan="2" width="350">フォロー</th>
        <th rowSpan="2">登録者</th>
        <th rowSpan="2">更新者</th>
        <th rowSpan="2" width="70">判定医</th>
        <th rowSpan="2" width="70">内視鏡医<br />(上部)</th>
        <th rowSpan="2" width="70">内視鏡医<br />(下部)</th>
        <th rowSpan="2">婦人科診察医</th>
        <th rowSpan="2">婦人科判定医</th>
        <th rowSpan="2" colSpan="3">操作</th>
      </tr>
      <tr>
        <th>フォロー</th>
        <th>現在判定</th>
      </tr>
    </thead>
    <tbody>
      {props.targetFollowData && props.fields.map((field, index) => <FollowInfoBodyItem {...props} key={index.toString()} index={index} item={props.targetFollowData[index]} />)}
    </tbody>
  </Table>

);

// propTypesの定義
FollowInfoBodyItems.propTypes = {
  fields: PropTypes.shape().isRequired,
  targetFollowData: PropTypes.arrayOf(PropTypes.shape()),
};

FollowInfoBodyItems.defaultProps = {
  targetFollowData: [],
};

export default FollowInfoBodyItems;
