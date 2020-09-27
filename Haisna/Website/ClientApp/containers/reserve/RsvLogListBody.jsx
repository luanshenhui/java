import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';

import Table from '../../components/Table';

const RsvLogListBody = ({ data, onOpenGuide }) => (
  <Table style={{ width: '40%' }}>
    <thead>
      <tr>
        <th>更新日時</th>
        <th>更新者</th>
        <th>予約番号</th>
      </tr>
    </thead>
    <tbody>
      {data && data.map((rec) => (
        <tr key={`${rec.rsvno}-${rec.seq}`}>
          <td><a href="#" onClick={() => { onOpenGuide(); }} style={{ color: '#0000ff' }}>{moment(rec.upddate).format('YYYY/MM/DD hh:mm:ss A')}</a></td>
          <td>{rec.username}</td>
          <td>{rec.rsvno}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
RsvLogListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onOpenGuide: PropTypes.func.isRequired,
};

export default RsvLogListBody;

