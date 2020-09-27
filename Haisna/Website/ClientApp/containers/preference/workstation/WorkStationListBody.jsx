/**
 * @file 管理端末一覧テーブル
 */
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';

// 標準コンポーネント
import Table from '../../../components/Table';

// 共通定数
import * as Constants from '../../../constants/common';

// 結果入力の印刷ボタンの表示文字列
const isprintbuttonItems = Object.values(Constants.isPrintButton).reduce((accum, item) => ({ ...accum, [item.value]: item.name }), {});

// 管理端末一覧表
const WorkStationListBody = ({ data, history }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>IPアドレス</th>
        <th>端末名</th>
        <th>グループコード</th>
        <th>グループ名</th>
        <th>結果入力の印刷ボタン</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.ipaddress}`} onClick={() => history.push(`/contents/preference/workstation/edit/${rec.ipaddress}`)}>
          <td>{rec.ipaddress}</td>
          <td>{rec.wkstnname}</td>
          <td>{rec.grpcd}</td>
          <td>{rec.grpname}</td>
          <td>
            {isprintbuttonItems[rec.isprintbutton] || ''}
          </td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
WorkStationListBody.propTypes = {
  // 管理端末データ
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  // react-router-domのhistory定義
  history: PropTypes.shape().isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  // 管理端末データ
  data: state.app.preference.workstation.list.data,
});

export default withRouter(connect(mapStateToProps)(WorkStationListBody));
