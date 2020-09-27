import React from 'react';
import PropTypes from 'prop-types';
import { Field } from 'redux-form';
import { connect } from 'react-redux';
import CheckBox from '../../components/control/CheckBox';
import Label from '../../components/control/Label';
import Table from '../../components/Table';
// 描画処理
const EntryRecogLevelBody = ({ list }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th colSpan="2">生活指導コメント</th>
      </tr>
    </thead>
    <tbody>
      {list && list.map((rec) => (
        <tr key={`${rec.seq}`}>
          <td width="80%"><Label>{rec.judcmtstc}</Label></td>
          <td>
            <Field component={CheckBox} name={`CmtDelFlag.${rec.seq}`} checkvalue={1} label="削除" />
          </td>
        </tr>
        ))}
    </tbody>
  </Table>
);

// propTypesの定義
EntryRecogLevelBody.propTypes = {
  list: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.judgement.interview.entryRecogLevel.commentData,
});

export default connect(mapStateToProps)(EntryRecogLevelBody);
