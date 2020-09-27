import React from 'react';
import PropTypes from 'prop-types';
import styled from 'styled-components';

import Table from '../../components/Table';

const Color = styled('span')`.
  font-weight: bold;
  color: #999999;
`;

const PerPaymentListBody = ({ data, rsvno }) => {
  const bodyList = (rec) => {
    const res = [];
    if (rec.rsvno === rsvno) {
      res.push(<td>{rec.dayid}</td>);
      res.push(<td>{rec.perid}</td>);
      res.push(<td>{rec.csname}</td>);
      res.push(<td>{rec.lastname}　{rec.firstname}<Color>（{rec.lastkname}　{rec.firstkname}）</Color></td>);
    }
    return res;
  };
  return (
    <Table style={{ width: '40%' }}>
      <thead>
        <tr>
          <th>当日ID</th>
          <th>個人ID</th>
          <th>コース名</th>
          <th>受診者名</th>
        </tr>
      </thead>
      <tbody>
        {data && data.map((rec) => (
          <tr key={rec.rsvno}>
            {bodyList(rec)}
          </tr>
        ))}
      </tbody>
    </Table>
  );
};
PerPaymentListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  rsvno: PropTypes.string.isRequired,
};

export default PerPaymentListBody;

