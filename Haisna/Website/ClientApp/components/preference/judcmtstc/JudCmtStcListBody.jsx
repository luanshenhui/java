/**
 * @file 判定コメント一覧（ボディ）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';

import Table from '../../../components/Table';

export default class JudCmtStcListBody extends React.Component {

  componentWillMount() {
    this.props.onLoad();
  }

  render() {
    return (
      <Table>
        <thead>
          <tr>
            <th>判定コメントコード</th>
            <th>判定コメント</th>
          </tr>
        </thead>
        <tbody>
          {this.props.judcmtstc.map((rec) => (
            <tr key={rec.judcmtcd}>
              <td><Link to={`${this.props.match.url}/edit/${rec.judcmtcd}`}>{rec.judcmtcd}</Link></td>
              <td>{rec.judcmtstc}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  }
}

// propTypesの定義
JudCmtStcListBody.propTypes = {
  judcmtstc: PropTypes.arrayOf(PropTypes.shape({
    judclasscd: PropTypes.number,
  })).isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
};
