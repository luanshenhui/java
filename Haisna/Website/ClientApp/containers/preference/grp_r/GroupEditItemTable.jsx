import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import Table from '../../../components/Table';

import { selectGroupEditItem } from '../../../modules/preference/groupModule';

const GroupEditItemTable = ({ item, onSelectItem }) => (
  <Table>
    <thead>
      <tr>
        <th>コード</th>
        <th>名称</th>
        <th>検査分類</th>
      </tr>
    </thead>
    <tbody>
      {item.map((rec) => (
        <tr key={`${rec.itemcd}-${rec.suffix}`} onClick={() => onSelectItem(rec)} className={rec.selected ? 'info' : ''}>
          <td>{rec.itemcd}-{rec.suffix}</td>
          <td>{rec.itemname}</td>
          <td>{rec.classname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
GroupEditItemTable.propTypes = {
  item: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onSelectItem: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  item: state.app.preference.group.groupEdit.item,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSelectItem: (item) => {
    dispatch(selectGroupEditItem(item));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(GroupEditItemTable);
