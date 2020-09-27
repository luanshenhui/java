import React from 'react';
import PropTypes from 'prop-types';
import MntPerInspectionItem from './MntPerInspectionItem';
import Table from '../../../components/Table';

// 個人検査情報
const MntPerInspectionItems = (props) => (

  <Table striped hover>
    <thead>
      <tr>
        <th>検査項目名</th>
        <th colSpan="2">検査結果</th>
        <th>文章</th>
        <th>更新時予約日</th>
      </tr>
    </thead>
    <tbody>
      {props.perresultitem && props.fields.map((field, index) => <MntPerInspectionItem {...props} key={field} index={index} item={props.perresultitem[index]} field={field} />)}
    </tbody>
  </Table>
);

// propTypesの定義
MntPerInspectionItems.propTypes = {
  fields: PropTypes.shape().isRequired,
  perresultitem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default MntPerInspectionItems;
