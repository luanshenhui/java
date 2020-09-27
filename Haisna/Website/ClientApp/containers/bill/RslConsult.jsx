import React from 'react';
import PropTypes from 'prop-types';

import { Link } from 'react-router-dom';
import moment from 'moment';

import Table from '../../components/Table';

const RslConsult = ({ data }) => (
  <Table>
    <thead>
      <tr>
        <th>受診日</th>
        <th>受診コース</th>
        <th>予約番号</th>
        <th>個人ＩＤ</th>
        <th>受診者名</th>
      </tr>
    </thead>
    <tbody>
      {data.rsvno &&
      <tr>
        <td>{moment(data.csldate).format('YYYY/MM/DD')}</td>
        <td>{data.csname}</td>
        <td><Link to={`/contents/bill/${data.rsvno}`}>{data.rsvno}</Link></td>
        <td>{data.perid}</td>
        <td><strong>{data.lastname} {data.firstname} </strong> {data.lastkname && `(${data.lastkname}  ${data.firstkname})`}</td>
      </tr>
      }
    </tbody>
  </Table>
);

// propTypesの定義
RslConsult.propTypes = {
  data: PropTypes.shape().isRequired,
};

export default RslConsult;
