/**
 * @file 検査分類一覧（ボディ部）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';

import Table from '../../../components/Table';

export default class ItemClassListBody extends React.Component {

  componentWillMount() {
    this.props.onLoad();
  }

  render() {
    return (
      <Table>
        <thead>
          <tr>
            <th>検査分類コード</th>
            <th>検査分類名</th>
          </tr>
        </thead>
        <tbody>
          {this.props.className.map((rec) => (
            <tr key={rec.classcd}>
              <td><Link to={`${this.props.match.url}/edit/${rec.classcd}`}>{rec.classcd}</Link></td>
              <td>{rec.classname}</td>
            </tr>
          ))}
        </tbody>
      </Table>
    );
  }
}

// propTypesの定義
ItemClassListBody.propTypes = {
  className: PropTypes.arrayOf(PropTypes.shape({
    classcd: PropTypes.number,
  })).isRequired,
  match: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
};
