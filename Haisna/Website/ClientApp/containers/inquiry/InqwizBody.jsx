import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';
import styled from 'styled-components';

import moment from 'moment';

import Table from '../../components/Table';

const Kname = styled.span`
  font-size: 9px;
`;

const InqwizBody = ({ data }) => (
  <div>
    {data && data.length > 0 &&
      <Table striped hover style={{ whiteSpace: 'nowrap', width: '50%' }}>
        <thead>
          <tr>
            <th>個人ＩＤ</th>
            <th>氏名</th>
            <th>ローマ字</th>
            <th>性別</th>
            <th>生年月日</th>
            <th>年齢</th>
          </tr>
        </thead>
        <tbody>
          {data.map((rec) => (
            <tr key={`${rec.perid}`}>
              <td><Link to={`/contents/inquiry/inqMain/${rec.perid}`}>{rec.perid}</Link></td>
              <td><Kname>{rec.lastkname} {rec.firstkname}</Kname><br /><Link to={`/contents/inquiry/inqMain/${rec.perid}`}>{rec.lastname} {rec.firstname}</Link></td>
              <td>{rec.romename}</td>
              <td>{(rec.gender === 1) ? '男性' : '女性'}</td>
              <td>{rec.birthyearshorteraname}{rec.birtherayear}.{moment(rec.birth).format('MM')}.{moment(rec.birth).format('DD')}</td>
              <td>{parseInt(rec.age, 10)}歳</td>
            </tr>
          ))}
        </tbody>
      </Table >
    }
  </div>
);

// propTypesの定義
InqwizBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

export default InqwizBody;
