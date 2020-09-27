import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Table from '../../../components/Table';

const GroupListBody = ({ data }) => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>グループ名</th>
        <th>検査分類</th>
        <th>システムグループ</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={rec.grpcd}>
          <td><Link to={`/preference/maintenance/group/edit/${rec.grpcd}`}>{rec.grpcd}</Link></td>
          <td>{rec.grpname}</td>
          <td>{rec.classname}</td>
          <td>{(rec.systemgrp === 1) ? 'システム使用グループ' : ''}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
GroupListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.group.groupList.data,
});

export default connect(mapStateToProps)(GroupListBody);
